//
//  JournalKeeper.h
//  Journal
//
//  Created by Peter Hosey on 2015-10-19.
//  Copyright © 2015 Peter Hosey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class JournalEntry;

///Posted whenever a new entry is recorded in the journal. Object is the journal.
extern NSString *__nonnull JournalDidRecordNewEntryNotification;

///Entry in the userInfo dictionary containing the entry that was created or otherwise acted upon.
extern NSString *__nonnull JournalNotificationUserInfoKeyEntry;

@interface JournalKeeper : NSObject

///The name of who's writing entries in this journal.
@property(nonnull, nonatomic, copy) NSString *author;

///The maximum number of characters per entry. Not actually enforced, but supplied for users who want a Twitter-like experience.
@property(nonatomic) NSUInteger characterLimit;

///Getter so the relevant VC can set its array controller's MOC to this.
@property(nonnull, nonatomic, readonly, strong) NSManagedObjectContext *managedObjectContext;

///Pass the URL to a Core Data SQLite file capable of storing JournalEntries.
- (__nullable instancetype) initWithURL:(NSURL *__nonnull)URL error:(NSError *__nullable *__nonnull)outError;

///Insert a new entry and return it. The entry is not dated until it is recorded (see recordEntry:).
- (JournalEntry *__nonnull) makeNewEntry;

///Date this entry, and tell the MOC to save. Posts JournalDidRecordNewEntryNotification. All of these together should cause the new entry to show up in the list.
- (void) recordEntry:(JournalEntry *__nonnull)entry;

@end
