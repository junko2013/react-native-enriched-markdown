#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ENRMCustomEmojiEntry : NSObject
@property (nonatomic) NSUInteger offset;
@property (nonatomic, copy) NSString *imageUri;
@property (nonatomic) CGFloat size;

+ (instancetype)entryWithOffset:(NSUInteger)offset imageUri:(NSString *)imageUri size:(CGFloat)size;
@end

NS_ASSUME_NONNULL_END
