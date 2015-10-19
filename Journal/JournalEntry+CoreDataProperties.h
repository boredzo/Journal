//
//  JournalEntry+CoreDataProperties.h
//  Journal
//
//  Created by Peter Hosey on 2015-10-19.
//  Copyright © 2015 Peter Hosey. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "JournalEntry.h"

NS_ASSUME_NONNULL_BEGIN

@interface JournalEntry (CoreDataProperties)

@property (nonnull, nonatomic, strong) NSString *byline;
@property (nonnull, nonatomic, strong) NSString *text;
@property (nullable, nonatomic, strong) NSDate *date;

@end

NS_ASSUME_NONNULL_END
