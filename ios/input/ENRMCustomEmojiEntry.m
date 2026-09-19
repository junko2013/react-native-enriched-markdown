#import "ENRMCustomEmojiEntry.h"

@implementation ENRMCustomEmojiEntry

+ (instancetype)entryWithOffset:(NSUInteger)offset imageUri:(NSString *)imageUri size:(CGFloat)size
{
  ENRMCustomEmojiEntry *entry = [[ENRMCustomEmojiEntry alloc] init];
  entry.offset = offset;
  entry.imageUri = imageUri;
  entry.size = size;
  return entry;
}

@end
