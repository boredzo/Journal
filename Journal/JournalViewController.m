//
//  JournalViewController.m
//  Journal
//
//  Created by Peter Hosey on 2015-10-19.
//  Copyright © 2015 Peter Hosey. All rights reserved.
//

#import "JournalViewController.h"
#import "JournalKeeper.h"
#import "ComposeViewController.h"

JournalViewController *journalVC_global = nil;

@interface JournalViewController ()

@property (strong) IBOutlet NSArrayController *arrayController;

@end

@implementation JournalViewController
{
	NSMutableArray <NSWindowController *> *_composeWindowControllers;
}

- (IBAction)summonNewEntryUI:(id)sender {
	NSStoryboard *const storyboard = self.storyboard;
	NSWindowController *const composeWC = [storyboard instantiateControllerWithIdentifier:@"JournalEntryCompose"];
	ComposeViewController *const composeVC = (ComposeViewController *const)composeWC.contentViewController;
	composeVC.journal = self.journal;

	if (_composeWindowControllers == nil) {
		_composeWindowControllers = [NSMutableArray new];
	}
	[_composeWindowControllers addObject:composeWC];

	[composeWC showWindow:sender];
}

- (IBAction)newDocument:(id)sender {
	return [self summonNewEntryUI:sender];
}

- (void)viewDidLoad {
	[super viewDidLoad];

	NSFileManager *const manager = [NSFileManager defaultManager];
	NSError *error = nil;
	NSURL *libraryDirURL = [manager URLForDirectory:NSLibraryDirectory inDomain:NSUserDomainMask
			appropriateForURL:nil create:YES error:&error];
	if (libraryDirURL == nil) {
		[self presentError:error modalForWindow:self.view.window delegate:self
				didPresentSelector:@selector(didPresentErrorWithRecovery:contextInfo:) contextInfo:NULL];
		return;
	}
	NSURL *appSupportDirURL = [libraryDirURL URLByAppendingPathComponent:@"Application Support" isDirectory:YES];
	NSURL *journalDirURL = [appSupportDirURL URLByAppendingPathComponent:@"org.boredzo.Journal" isDirectory:YES];
	[manager createDirectoryAtURL:journalDirURL withIntermediateDirectories:YES
			attributes:@{} error:NULL];
	NSURL *journalFileURL = [journalDirURL URLByAppendingPathComponent:@"Journal-v1.sqlite"
			isDirectory:YES];
	self.journal = [[JournalKeeper alloc] initWithURL:journalFileURL error:&error];
	if (self.journal == nil) {
		[self presentError:error modalForWindow:self.view.window delegate:self
				didPresentSelector:@selector(didPresentErrorWithRecovery:contextInfo:) contextInfo:NULL];
		return;
	}

	self.arrayController.managedObjectContext = self.journal.managedObjectContext;
	self.arrayController.sortDescriptors = @[
		[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]
	];

	[[NSNotificationCenter defaultCenter]
			addObserverForName:JournalDidRecordNewEntryNotification object:self.journal queue:[NSOperationQueue mainQueue]
			usingBlock:^(NSNotification *note) {
		[self.arrayController fetch:nil];
	}];

	journalVC_global = self;
}

- (void) didPresentErrorWithRecovery:(BOOL)didPresentErrorWithRecovery contextInfo:(id)contextInfo {
	[NSApp terminate:nil];
}

- (void)setRepresentedObject:(id)representedObject {
	[super setRepresentedObject:representedObject];

	// Update the view, if already loaded.
}

@end
