#import <Cocoa/Cocoa.h>

@interface JournalTableCellView: NSTableCellView

@property(weak) NSTextField *bylineField;
@property(weak) NSTextField *dateField;
@property(weak) NSTextField *entryTextField;

@end
