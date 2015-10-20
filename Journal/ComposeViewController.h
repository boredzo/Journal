//
//  ComposeViewController.h
//  Journal
//
//  Created by Peter Hosey on 2015-10-19.
//  Copyright © 2015 Peter Hosey. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class JournalKeeper;
@class JournalEntry;

@interface ComposeViewController : NSViewController

@property(strong) JournalKeeper *journal;

@end
