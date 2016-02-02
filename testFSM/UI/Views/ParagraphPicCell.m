//
//  ParagraphPicCell.m
//  testFSM
//
//  Created by CocoaChina_yangjh on 16/2/1.
//  Copyright © 2016年 yjh4866. All rights reserved.
//

#import "ParagraphPicCell.h"
#import "XMLParser.h"
#import "UIImageView+NBL.h"

@interface ParagraphPicCell ()
@property (nonatomic, strong) UIImageView *imageViewPic;
@end

@implementation ParagraphPicCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.imageViewPic = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.imageViewPic.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.imageViewPic];
        // KVO
        [self addObserver:self forKeyPath:@"paragraphElement" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageViewPic.frame = CGRectMake(10, 5, self.bounds.size.width-20, self.bounds.size.height-10);
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"paragraphElement"];
}

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSString*, id> *)change context:(nullable void *)context
{
    if ([keyPath isEqualToString:@"paragraphElement"]) {
        XMLNode *xmlNode = [self.paragraphElement.sourceText xmlNodeWithEncoding:NSUTF8StringEncoding];
        NSString *picUrl = xmlNode.nodeAttributesDict[@"src"];
        if (picUrl.length == 0) {
            picUrl = xmlNode.nodeAttributesDict[@"SRC"];
        }
        
        self.imageViewPic.image = nil;
        if (picUrl.length > 0) {
            NSString *filePath = [FileManager picturePathOfUrl:picUrl];
            __weak typeof(self) weakSelf = self;
            [self.imageViewPic loadImageFromCachePath:filePath orPicUrl:picUrl withDownloadResult:^(UIImageView *imageView, NSString *picUrl, float progress, BOOL finished, NSError *error) {
                // 下载完成
                if (finished) {
                    // 下载成功
                    if (nil == error) {
                        [weakSelf.delegate paragraphPicCellDownloadPictureSuccess:weakSelf];
                    }
                }
            }];
        }
        if (nil == self.imageViewPic.image) {
            // 设置默认图片
        }
    }
}

+ (CGFloat)cellHeightWith:(ParagraphElement *)paragraphElement andCellWidth:(CGFloat)cellWidth
{
    XMLNode *xmlNode = [paragraphElement.sourceText xmlNodeWithEncoding:NSUTF8StringEncoding];
    NSString *picUrl = xmlNode.nodeAttributesDict[@"src"];
    if (picUrl.length == 0) {
        picUrl = xmlNode.nodeAttributesDict[@"SRC"];
    }
    if (picUrl.length > 0) {
        UIImage *picture = [FileManager pictureOfUrl:picUrl];
        if (picture) {
            CGFloat heightPic = (cellWidth-20)*picture.size.height/picture.size.width;
            if (heightPic > picture.size.height) {
                heightPic = picture.size.height;
            }
            return 5+heightPic+5;
        }
        return 40;
    }
    return 0;
}

@end
