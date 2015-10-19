//
//  TestJournalEntry.m
//  Journal
//
//  Created by Peter Hosey on 2015-10-19.
//  Copyright © 2015 Peter Hosey. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "JournalEntry.h"
#import "JournalEntry+CoreDataProperties.h"

@interface TestJournalEntry : XCTestCase

@end

@implementation TestJournalEntry
{
	NSManagedObjectContext *_managedObjectContext;
	JournalEntry *_entry;
}

- (void)setUp {
    [super setUp];

	_managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
	NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:[[NSBundle bundleForClass:self.class]
		URLForResource:@"Journal" withExtension:@"momd"]];
	NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
	_managedObjectContext.persistentStoreCoordinator = psc;
	_entry = (JournalEntry *)[[JournalEntry alloc]
		initWithEntity:[NSEntityDescription entityForName:@"JournalEntry" inManagedObjectContext:_managedObjectContext]
		insertIntoManagedObjectContext:_managedObjectContext];
	_entry.byline = @"Example author";
	_entry.text = @"This is a test specimen of a journal entry that is a little bit longer than Twitter’s character limit, but significantly shorter than App.net’s character limit.";
}

- (void)tearDown {
    [super tearDown];
}

- (void)testUnderCharacterLimit {
	XCTAssertFalse([_entry exceedsCharacterLimit:256]);
}
- (void)testOverCharacterLimit {
	XCTAssertTrue([_entry exceedsCharacterLimit:140]);
}
- (void)testExactlyMeetsCharacterLimit {
	XCTAssertFalse([_entry exceedsCharacterLimit:_entry.text.length]);
}
- (void)testOverCharacterLimitZero {
	XCTAssertTrue([_entry exceedsCharacterLimit:0]);
}

@end
