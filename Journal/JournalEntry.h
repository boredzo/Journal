//
//  JournalEntry.h
//  Journal
//
//  Created by Peter Hosey on 2015-10-19.
//  Copyright © 2015 Peter Hosey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface JournalEntry : NSManagedObject

@property(nonatomic) CGFloat cachedRowHeight;

- (bool) exceedsCharacterLimit:(NSUInteger)limit;
- (NSInteger) charactersRemainingUnderLimit:(NSUInteger)limit;

@end
