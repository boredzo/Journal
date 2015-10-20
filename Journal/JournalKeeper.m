//
//  JournalKeeper.m
//  Journal
//
//  Created by Peter Hosey on 2015-10-19.
//  Copyright © 2015 Peter Hosey. All rights reserved.
//

#import "JournalKeeper.h"
#import "JournalEntry.h"
#import "JournalEntry+CoreDataProperties.h"

#import "PreferenceKeys.h"

NSString *JournalDidRecordNewEntryNotification = @"JournalDidRecordNewEntryNotification";

NSString *JournalNotificationUserInfoKeyEntry = @"JournalEntry";

@implementation JournalKeeper
{
	NSManagedObjectContext *_managedObjectContext;
}

- (__nullable instancetype) initWithURL:(NSURL *__nonnull)URL error:(NSError *__nullable *__nonnull)outError {
	self = [super init];
	if (self) {
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		[defaults registerDefaults:@{
			JournalPrefAuthor : NSFullUserName(),
			JournalPrefCharacterLimit: @(JournalPrefCharacterLimitDefaultValue),
		}];
		_author = [defaults stringForKey:JournalPrefAuthor];
		__weak typeof(self) weakSelf = self;
		void (^const prefsChanged)(NSNotification *__nullable) = ^(NSNotification *__nullable note) {
			NSInteger characterLimitFromPrefs = [defaults integerForKey:JournalPrefCharacterLimit];
			if (characterLimitFromPrefs <= 0) {
				characterLimitFromPrefs = JournalPrefCharacterLimitDefaultValue;
			}
			weakSelf.characterLimit = (NSUInteger)characterLimitFromPrefs;
		};
		[[NSNotificationCenter defaultCenter]
				addObserverForName:NSUserDefaultsDidChangeNotification object:defaults
				queue:[NSOperationQueue mainQueue]
				usingBlock:prefsChanged];
		prefsChanged(nil);

		_managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
		NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:[[NSBundle bundleForClass:self.class]
				URLForResource:@"Journal" withExtension:@"momd"]];
		NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
		_managedObjectContext.persistentStoreCoordinator = psc;
		NSError *error = nil;
		if ( ! [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil
				URL:URL options:@{ } error:&error] ) {
			if (outError != NULL) *outError = error;
			self = nil;
		}
	}
	return self;
}

- (JournalEntry *__nonnull) makeNewEntry {
	JournalEntry *entry = (JournalEntry *)[NSEntityDescription insertNewObjectForEntityForName:@"JournalEntry"
			inManagedObjectContext:_managedObjectContext];
	entry.byline = _author;
	entry.text = @"";
	return entry;
}

- (void) recordEntry:(JournalEntry *__nonnull)entry {
	entry.date = [NSDate date];
	NSError *error = nil;
	if ( ! [_managedObjectContext save:&error] ) {
		//TODO: Make this a delegate method or something
		NSLog(@"Error saving journal: %@", error);
	}

	[[NSNotificationCenter defaultCenter] postNotificationName:JournalDidRecordNewEntryNotification object:entry userInfo:@{ JournalNotificationUserInfoKeyEntry: entry }];
}

@end
