#import "ENRMUIKit.h"

NS_ASSUME_NONNULL_BEGIN

@interface ENRMCustomEmojiAttachment : NSTextAttachment
@property (nonatomic, readonly) CGFloat emojiSize;

+ (instancetype)attachmentWithImageUri:(NSString *)imageUri size:(CGFloat)size baseFont:(UIFont *)baseFont;
@end

NS_ASSUME_NONNULL_END
