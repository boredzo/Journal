//
//  JournalViewController.h
//  Journal
//
//  Created by Peter Hosey on 2015-10-19.
//  Copyright © 2015 Peter Hosey. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class JournalKeeper;

@interface JournalViewController: NSViewController

@property (strong) JournalKeeper *journal;

- (void) summonNewEntryUI:(id)sender;
@end

extern JournalViewController *journalVC_global;
