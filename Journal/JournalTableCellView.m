#import "JournalTableCellView.h"

enum {
	JournalTableCellViewSubviewTagBylineField = 1,
	JournalTableCellViewSubviewTagDateField,
	JournalTableCellViewSubviewTagEntryTextField,
};

@implementation JournalTableCellView

- (void) awakeFromNib {
	[super awakeFromNib];

	self.bylineField = (NSTextField *)[self viewWithTag:JournalTableCellViewSubviewTagBylineField];
	self.dateField = (NSTextField *)[self viewWithTag:JournalTableCellViewSubviewTagDateField];
	self.entryTextField = (NSTextField *)[self viewWithTag:JournalTableCellViewSubviewTagEntryTextField];
}

@end