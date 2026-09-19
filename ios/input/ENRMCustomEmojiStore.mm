#import "ENRMCustomEmojiStore.h"
#import "ENRMCustomEmojiEntry.h"
#import "ENRMRangeEditAdjustment.h"

@implementation ENRMCustomEmojiStore {
  NSMutableArray<ENRMCustomEmojiEntry *> *_entries;
}

- (instancetype)init
{
  if (self = [super init]) {
    _entries = [NSMutableArray array];
  }
  return self;
}

- (NSArray<ENRMCustomEmojiEntry *> *)allEntries
{
  return [_entries copy];
}

- (NSArray<ENRMCustomEmojiEntry *> *)entriesIntersectingRange:(NSRange)range
{
  if (range.length == 0) {
    return @[];
  }
  NSMutableArray<ENRMCustomEmojiEntry *> *result = [NSMutableArray array];
  NSUInteger rangeEnd = NSMaxRange(range);
  for (ENRMCustomEmojiEntry *entry in _entries) {
    NSUInteger entryEnd = entry.offset + 1;
    if (entry.offset < rangeEnd && entryEnd > range.location) {
      [result addObject:entry];
    }
  }
  return result;
}

- (void)clearAll
{
  [_entries removeAllObjects];
}

- (void)setEntries:(NSArray<ENRMCustomEmojiEntry *> *)entries
{
  _entries = [[entries sortedArrayUsingComparator:^NSComparisonResult(ENRMCustomEmojiEntry *first, ENRMCustomEmojiEntry *second) {
    if (first.offset < second.offset)
      return NSOrderedAscending;
    if (first.offset > second.offset)
      return NSOrderedDescending;
    return NSOrderedSame;
  }] mutableCopy];
}

- (void)addEntry:(ENRMCustomEmojiEntry *)entry
{
  [_entries addObject:entry];
  [self setEntries:_entries];
}

- (void)removeEntryAtOffset:(NSUInteger)offset
{
  NSIndexSet *indexes = [_entries indexesOfObjectsPassingTest:^BOOL(ENRMCustomEmojiEntry *entry, NSUInteger idx, BOOL *stop) {
    return entry.offset == offset;
  }];
  if (indexes.count > 0) {
    [_entries removeObjectsAtIndexes:indexes];
  }
}

- (void)adjustForEditAtLocation:(NSUInteger)editLocation
                  deletedLength:(NSUInteger)deletedLength
                 insertedLength:(NSUInteger)insertedLength
{
  if (deletedLength == 0 && insertedLength == 0) {
    return;
  }

  NSMutableIndexSet *indexesToRemove = [NSMutableIndexSet indexSet];
  for (NSUInteger idx = 0; idx < _entries.count; idx++) {
    ENRMCustomEmojiEntry *entry = _entries[idx];
    ENRMAdjustedRange adjusted = ENRMAdjustRangeForEdit(NSMakeRange(entry.offset, 1), editLocation, deletedLength,
                                                        insertedLength, NO, NO);
    if (adjusted.shouldRemove) {
      [indexesToRemove addIndex:idx];
    } else {
      entry.offset = adjusted.range.location;
    }
  }
  if (indexesToRemove.count > 0) {
    [_entries removeObjectsAtIndexes:indexesToRemove];
  }
}

@end
