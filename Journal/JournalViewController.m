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
#import "JournalTableCellView.h"
#import "JournalEntry+CoreDataProperties.h"

JournalViewController *journalVC_global = nil;

@interface JournalViewController () <NSTableViewDelegate>

@property (strong) IBOutlet NSArrayController *arrayController;
@property (strong) IBOutlet NSTableCellView *tableCellView;
@property (weak) IBOutlet NSButton *buttonForCreationOfPosts;

@end

@implementation JournalViewController
{
	NSMutableArray <NSWindowController *> *_composeWindowControllers;
	bool _computeRowHeights;
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

	_computeRowHeights = false;

	//HAX: Nib compiler or unarchiver doesn't seem to preserve this correctly; it gets reset to NSImageOverlaps at run time.
	self.buttonForCreationOfPosts.imagePosition = NSImageOnly;

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

- (CGFloat) tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
	if ( ! _computeRowHeights ) {
		static CGFloat defaultHeight = 40.0;
		static dispatch_once_t onceToken;
		dispatch_once(&onceToken, ^{
			JournalTableCellView *const cellView = (JournalTableCellView *const)self.tableCellView;
			const CGFloat height = cellView.frame.size.height;
			if (height > 0.0) {
				defaultHeight = height;
			}
		});
		return defaultHeight;
	}
	JournalEntry *__nonnull entry = self.arrayController.arrangedObjects[(NSUInteger)row];
	CGFloat cachedHeight = entry.cachedRowHeight;
	if (cachedHeight < 1.0) {
		JournalTableCellView *const cellView = (JournalTableCellView *const)self.tableCellView;
		cellView.bylineField.stringValue = entry.byline;
		cellView.dateField.objectValue = entry.date;
		NSTextField *entryTextField = cellView.entryTextField;
		entryTextField.stringValue = entry.text;
		[entryTextField sizeToFit];
		cachedHeight = cellView.fittingSize.height;
		entry.cachedRowHeight = cachedHeight;
	}
	return cachedHeight;
}

- (void) tableView:(NSTableView *)tableView didAddRowView:(NSTableRowView *)rowView forRow:(NSInteger)row {
	_computeRowHeights = true;
	if (row >= 0) {
		[tableView noteHeightOfRowsWithIndexesChanged:[NSIndexSet indexSetWithIndex:(NSUInteger)row]];
	}
}

- (void)setRepresentedObject:(id)representedObject {
	[super setRepresentedObject:representedObject];

	// Update the view, if already loaded.
}

@end
