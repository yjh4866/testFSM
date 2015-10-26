//
//  ArticlePicView.m
//  testFSM
//
//  Created by yangjh on 13-6-13.
//  Copyright (c) 2013年 yjh4866. All rights reserved.
//

#import "ArticlePicView.h"
#import "UIMacro.h"

#define Width_ArticlePicProgress         142.0f

@interface ArticlePicView () {
    
    UIImageView *_imageViewPic;
    UIImageView *_imageViewProgressBG;
    UIImageView *_imageViewProgress;
    
    NSUInteger _picSize;
}

@end

@implementation ArticlePicView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //
        CGRect framePic = CGRectMake(0.0f, 0.0f, self.bounds.size.width, 0.0f);
        _imageViewPic = [[UIImageView alloc] initWithFrame:framePic];
        _imageViewPic.userInteractionEnabled = YES;
        UITapGestureRecognizer *grTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(clickPic:)];
        [_imageViewPic addGestureRecognizer:grTap];
        [grTap release];
        [self addSubview:_imageViewPic];
        
        //默认图片
        [self privateSetPicture:[UIImage imageNamed:@"article_defaultpic"]];
        //
        [self addObserver:self forKeyPath:@"self.picture" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"self.picture"];
    //
    [_imageViewPic release];
    [_imageViewProgressBG release];
    [_imageViewProgress release];
    //
    self.url = nil;
    self.picture = nil;
    
    [super dealloc];
}


#pragma mark - NSKeyValueObserving

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"self.picture"]) {
        [_imageViewProgressBG removeFromSuperview];
        [_imageViewProgressBG release];
        _imageViewProgressBG = nil;
        [_imageViewProgress removeFromSuperview];
        [_imageViewProgress release];
        _imageViewProgress = nil;
        //
        if (self.picture) {
            [self privateSetPicture:self.picture];
        }
    }
}


#pragma mark - Public

// 设置指定url的图片大小
- (void)setPictureSize:(NSUInteger)picSize
{
    _picSize = picSize;
    //
    if (nil == _imageViewProgressBG) {
        CGRect frameProgress = CGRectMake(((self.bounds.size.width-20.0f)-Width_ArticlePicProgress)/2, 100.0f,
                                          Width_ArticlePicProgress, 8.0f);
        _imageViewProgressBG = [[UIImageView alloc] initWithFrame:frameProgress];
        SetStretchableImageForImageView(_imageViewProgressBG, @"article_picprogressbg");
        //
        _imageViewProgress = [[UIImageView alloc] initWithFrame:CGRectZero];
        SetStretchableImageForImageView(_imageViewProgress, @"article_picprogress");
        [_imageViewProgressBG addSubview:_imageViewProgress];
    }
    [self addSubview:_imageViewProgressBG];
}

// 设置下载指定url的图片的进度
- (void)setProgressOfDownloadPicture:(CGFloat)progress
{
    if (_picSize > 0) {
        CGFloat widthProgress = progress*(Width_ArticlePicProgress-4.0f);
        _imageViewProgress.frame = CGRectMake(2.0f, 1.5f, widthProgress, 5.0f);
    }
}


#pragma mark - ClickEvent

- (void)clickPic:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(articlePicViewClickPic:)]) {
        [self.delegate articlePicViewClickPic:self];
    }
}


#pragma mark - Private

- (void)privateSetPicture:(UIImage *)picture
{
    if (picture.size.width == 0 || picture.size.height == 0) {
        return;
    }
    //设置图片并重新计算尺寸
    _imageViewPic.image = picture;
    CGRect framePic = _imageViewPic.frame;
    framePic.size.width = picture.size.width;
    if (framePic.size.width > self.bounds.size.width) {
        framePic.size.width = self.bounds.size.width;
    }
    framePic.size.height = framePic.size.width*(picture.size.height/picture.size.width);
    framePic.origin.x = (self.bounds.size.width-framePic.size.width)/2.0f;
    _imageViewPic.frame = framePic;
    //
    CGRect frameSelf = self.frame;
    frameSelf.size.height = _imageViewPic.bounds.size.height;
    self.frame = frameSelf;
}

@end
