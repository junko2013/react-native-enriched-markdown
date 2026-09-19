#import "ENRMCustomEmojiAttachment.h"
#import <React/RCTUtils.h>

@interface ENRMCustomEmojiAttachment ()
@property (nonatomic, copy) NSString *imageUri;
@property (nonatomic, strong) UIFont *baseFont;
@property (nonatomic, strong) RCTUIImage *loadedImage;
@end

@implementation ENRMCustomEmojiAttachment

+ (instancetype)attachmentWithImageUri:(NSString *)imageUri size:(CGFloat)size baseFont:(UIFont *)baseFont
{
  ENRMCustomEmojiAttachment *attachment = [[ENRMCustomEmojiAttachment alloc] init];
  attachment.imageUri = imageUri;
  attachment->_emojiSize = size;
  attachment.baseFont = baseFont;
  attachment.bounds = CGRectMake(0, 0, size, size);
  [attachment loadImageIfNeeded];
  return attachment;
}

- (void)loadImageIfNeeded
{
  if (self.imageUri.length == 0) {
    return;
  }

  NSURL *url = [NSURL URLWithString:self.imageUri];
  if (url == nil && [self.imageUri hasPrefix:@"/"]) {
    url = [NSURL fileURLWithPath:self.imageUri];
  }
  if (url == nil) {
    return;
  }

  __weak typeof(self) weakSelf = self;
  dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
    NSData *data = nil;
    if (url.isFileURL) {
      data = [NSData dataWithContentsOfURL:url];
    } else {
      data = [NSData dataWithContentsOfURL:url];
    }
    RCTUIImage *image = data.length > 0 ? [RCTUIImage imageWithData:data scale:RCTScreenScale()] : nil;
    dispatch_async(dispatch_get_main_queue(), ^{
      __strong typeof(weakSelf) strongSelf = weakSelf;
      if (!strongSelf || !image) {
        return;
      }
      strongSelf.loadedImage = image;
      strongSelf.image = image;
    });
  });
}

- (CGRect)attachmentBoundsForTextContainer:(NSTextContainer *)textContainer
                      proposedLineFragment:(CGRect)lineFragment
                             glyphPosition:(CGPoint)position
                            characterIndex:(NSUInteger)characterIndex
{
  UIFont *appliedFont = self.baseFont;
  NSTextStorage *textStorage = textContainer.layoutManager.textStorage;
  if (textStorage.length > 0 && characterIndex < textStorage.length) {
    UIFont *font = [textStorage attribute:NSFontAttributeName atIndex:characterIndex effectiveRange:NULL];
    if (font != nil) {
      appliedFont = font;
    }
  }

  CGFloat height = self.emojiSize;
  CGFloat verticalOffset = appliedFont ? (appliedFont.capHeight - height) / 2.0 : 0;
  return CGRectMake(0, verticalOffset, height, height);
}

- (RCTUIImage *)imageForBounds:(CGRect)imageBounds
                 textContainer:(NSTextContainer *)textContainer
                characterIndex:(NSUInteger)characterIndex
{
  self.bounds = imageBounds;
  return self.loadedImage ?: self.image;
}

@end
