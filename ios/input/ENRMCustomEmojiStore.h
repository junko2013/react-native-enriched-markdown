#import <Foundation/Foundation.h>

@class ENRMCustomEmojiEntry;

NS_ASSUME_NONNULL_BEGIN

@interface ENRMCustomEmojiStore : NSObject

- (NSArray<ENRMCustomEmojiEntry *> *)allEntries;
- (NSArray<ENRMCustomEmojiEntry *> *)entriesIntersectingRange:(NSRange)range;
- (void)clearAll;
- (void)setEntries:(NSArray<ENRMCustomEmojiEntry *> *)entries;
- (void)addEntry:(ENRMCustomEmojiEntry *)entry;
- (void)removeEntryAtOffset:(NSUInteger)offset;
- (void)adjustForEditAtLocation:(NSUInteger)editLocation
                  deletedLength:(NSUInteger)deletedLength
                 insertedLength:(NSUInteger)insertedLength;

@end

NS_ASSUME_NONNULL_END
