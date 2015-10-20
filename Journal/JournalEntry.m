//
//  JournalEntry.m
//  Journal
//
//  Created by Peter Hosey on 2015-10-19.
//  Copyright © 2015 Peter Hosey. All rights reserved.
//

#import "JournalEntry.h"

#import "JournalEntry+CoreDataProperties.h"

@implementation JournalEntry

- (void) awakeFromInsert {
	[super awakeFromInsert];
	[self setPrimitiveValue:@"" forKey:@"byline"];
	[self setPrimitiveValue:@"" forKey:@"text"];
}

- (bool) exceedsCharacterLimit:(NSUInteger)limit {
	return self.text.length > limit;
}

- (NSInteger) charactersRemainingUnderLimit:(NSUInteger)limit {
	NSUInteger length = self.text.length;
	if (length > NSIntegerMax) {
		length = NSIntegerMax;
	}
	return (NSInteger)limit - (NSInteger)length;
}

@end
