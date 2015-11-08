//
//  JournalUITests.m
//  JournalUITests
//
//  Created by Peter Hosey on 2015-10-19.
//  Copyright © 2015 Peter Hosey. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface JournalUITests : XCTestCase

@end

@implementation JournalUITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testNewEntryWorkflow {
	
	NSString *journalEntryString = @"Bacon ipsum dolar ham.";
	XCUIApplication *app = [[XCUIApplication alloc] init];
	
	XCUIElement *journalWindow = app.windows[@"Journal"];
	
	XCTAssertTrue(journalWindow.buttons[@"new_entry"].exists);
	
	[journalWindow.buttons[@"new_entry"] click];
	
	XCUIElement *composeWindow = app.windows[@"Compose"];
	XCTAssertTrue(composeWindow.exists);
	XCTAssertTrue(composeWindow.textViews[@"compose_entry"].exists);
	XCTAssertTrue(composeWindow.buttons[@"Save"].exists);
	
	[composeWindow.textViews[@"compose_entry"] typeText:journalEntryString];
	[composeWindow.buttons[@"Save"] click];
	
	XCTAssertTrue([[journalWindow.tables childrenMatchingType:XCUIElementTypeTableRow] elementBoundByIndex:0].staticTexts[journalEntryString].exists);
	
}

@end
