//
//  ComposeViewController.m
//  Journal
//
//  Created by Peter Hosey on 2015-10-19.
//  Copyright © 2015 Peter Hosey. All rights reserved.
//

#import "ComposeViewController.h"
#import "JournalViewController.h"
#import "JournalKeeper.h"
#import "JournalEntry.h"
#import "JournalEntry+CoreDataProperties.h"
#import "PreferenceKeys.h"

@interface ComposeViewController () <NSTextDelegate, NSTextViewDelegate>

@property (weak) IBOutlet NSTextField *characterCountField;

@property(strong) JournalEntry *entry;

@end

@implementation ComposeViewController

- (IBAction)newDocument:(id)sender {
	//TODO: Cascade the new window from self.windowController's window
	return [journalVC_global summonNewEntryUI:sender];
}

- (void)viewWillAppear {
	[super viewWillAppear];

	if (self.entry == nil) {
		self.entry = [self.journal makeNewEntry];
	}

	NSUserDefaults *const __nonnull defaults = [NSUserDefaults standardUserDefaults];
	__weak NSTextField *const characterCountField = self.characterCountField;
	void (^const prefsChanged)(NSNotification *__nullable) = ^(NSNotification *__nullable note) {
		NSInteger characterLimitFromPrefs = [defaults integerForKey:JournalPrefCharacterLimit];
		characterCountField.integerValue = characterLimitFromPrefs;
	};
	[[NSNotificationCenter defaultCenter]
			addObserverForName:NSUserDefaultsDidChangeNotification object:defaults
			queue:[NSOperationQueue mainQueue]
			usingBlock:prefsChanged];
	prefsChanged(nil);

	[self textDidChange:[NSNotification notificationWithName:NSTextDidChangeNotification object:nil]];
}

- (void) textDidChange:(NSNotification *__nonnull)notification {
	NSTextView *const __nullable textView = notification.object;
	NSString *const __nonnull text = textView.string ?: @"";

	self.entry.text = text;

	NSTextField *const characterCountField = self.characterCountField;
	const NSUInteger limit = self.journal.characterLimit;
	const bool overLimit = [self.entry exceedsCharacterLimit:limit];
	const NSInteger charactersRemaining = [self.entry charactersRemainingUnderLimit:limit];
	characterCountField.objectValue = @(charactersRemaining);
	characterCountField.textColor = overLimit ? [NSColor redColor] : [NSColor blackColor];
}

- (BOOL) textView:(NSTextView *)textView doCommandBySelector:(SEL)commandSelector {
	if (commandSelector == @selector(insertLineBreak:)) {
		//Ctrl-enter
		[self finishAndRecordEntry:textView];
		return YES;
	}
	return NO;
}

- (IBAction)finishAndRecordEntry:(id)sender {
	[self.journal recordEntry:self.entry];
	[self.view.window.windowController close];
}

@end
