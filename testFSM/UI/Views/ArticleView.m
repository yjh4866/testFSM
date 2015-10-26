//
//  ArticleView.m
//  testFSM
//
//  Created by yangjh on 13-6-13.
//  Copyright (c) 2013年 yjh4866. All rights reserved.
//

#import "ArticleView.h"
#import "ArticlePicView.h"
#import "XMLParser.h"
#import "ArticleParagraph.h"
#import "UIMacro.h"

#define DistanceBetweenParagraph      8.0f

@interface ArticleView () <ArticlePicViewDelegate> {
    
    NSMutableArray *_marrParagraph;
}

@end

@implementation ArticleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _marrParagraph = [[NSMutableArray alloc] init];
        self.fontSize = 16.0f;
        //
        [self addObserver:self forKeyPath:@"self.article" options:NSKeyValueObservingOptionNew context:nil];
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
    [self removeObserver:self forKeyPath:@"self.article"];
    //
    self.article = nil;
    //
    [_marrParagraph release];
    
    [super dealloc];
}


#pragma mark - NSKeyValueObserving

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"self.article"]) {
        if (self.frame.size.width == 0 || self.article.length == 0) {
            return;
        }
        //先移除原有段落
        for (int i = self.subviews.count-1; i >= 0; i--) {
            UIView *subView = [self.subviews objectAtIndex:i];
            [subView removeFromSuperview];
        }
        [_marrParagraph removeAllObjects];
        //解析段落
        NSArray *arrParagraph = [ArticleParagraph parseParagraphFromArticle:self.article];
        //遍历段落
        CGFloat widthArticle = self.bounds.size.width-20.0f;
        CGFloat leftArticle = 10.0f;
        UIFont *fontParagraph = [UIFont systemFontOfSize:self.fontSize];
        CGFloat topParagraph = DistanceBetweenParagraph;
        CGSize maxSizeText = CGSizeMake(widthArticle, 15000.0f);
        for (NSArray *arrParagraphElement in arrParagraph) {
            for (ParagraphElement *pElement in arrParagraphElement) {
                //文本
                if (ParagraphElementType_Text == pElement.eleType) {
                    //
                    CGSize contentSize = [pElement.sourceText sizeWithFont:fontParagraph constrainedToSize:maxSizeText lineBreakMode:NSLineBreakByCharWrapping];
                    //
                    CGRect frameText = CGRectMake(leftArticle, topParagraph, widthArticle, contentSize.height);
                    UILabel *label = [[UILabel alloc] initWithFrame:frameText];
                    label.backgroundColor = [UIColor clearColor];
                    label.font = fontParagraph;
                    label.textColor = [UIColor colorWithWhite:1.0f*0x66/0xff
                                                        alpha:1.0f];
                    label.lineBreakMode = NSLineBreakByCharWrapping;
                    label.numberOfLines = 0;
                    label.text = pElement.sourceText;
                    [self addSubview:label];
                    //
                    [_marrParagraph addObject:@{@"view": label, @"pe": pElement}];
                    [label release];
                    //
                    topParagraph += contentSize.height+DistanceBetweenParagraph;
                }
                //图片
                else if (ParagraphElementType_Picture == pElement.eleType) {
                    XMLNode *xmlNode = [pElement.sourceText xmlNodeWithEncoding:NSUTF8StringEncoding];
                    NSString *picUrl = [xmlNode.nodeAttributesDict objectForKey:@"src"];
                    if (picUrl.length == 0) {
                        picUrl = [xmlNode.nodeAttributesDict objectForKey:@"SRC"];
                        if (picUrl.length == 0) {
                            continue;
                        }
                    }
                    //
                    CGRect framePicture = CGRectMake(leftArticle, topParagraph, widthArticle, 0.0f);
                    ArticlePicView *picView = [[ArticlePicView alloc] initWithFrame:framePicture];
                    picView.url = picUrl;
                    picView.delegate = self;
                    [self addSubview:picView];
                    //
                    [_marrParagraph addObject:@{@"view": picView, @"pe": pElement}];
                    [picView release];
                    //
                    topParagraph += picView.bounds.size.height+DistanceBetweenParagraph;
                }
            }
        }
        //
        CGRect frameArticle = self.frame;
        frameArticle.size.height = topParagraph;
        self.frame = frameArticle;
    }
}


#pragma mark - Public

// 设置显示区域以计算是否需要下载图片
- (void)showRect:(CGRect)frameShow
{
    if ([self.dataSource respondsToSelector:@selector(articleView:getArticlePicWithUrl:)] &&
        [self.delegate respondsToSelector:@selector(articleView:forceDownloadArticlePic:withUrl:)]) {
        for (NSDictionary *dicParagraph in _marrParagraph) {
            ParagraphElement *pElement = [dicParagraph objectForKey:@"pe"];
            //图片段落
            if (ParagraphElementType_Picture == pElement.eleType) {
                ArticlePicView *picView = [dicParagraph objectForKey:@"view"];
                //当前在显示位置
                if (CGRectIntersectsRect(frameShow, picView.frame)) {
                    NSString *url = picView.url;
                    //无图片且url存在
                    if (nil == picView.picture && url.length > 0) {
                        //先从本地加载
                        @autoreleasepool {
                            UIImage *picture = [self.dataSource articleView:self
                                                       getArticlePicWithUrl:url];
                            if (picture) {
                                //设置指定url的图片以重排
                                [self setPicture:picture withUrl:url];
                            }
                            else {
                                //未加载到则下载
                                [self.delegate articleView:self
                                   forceDownloadArticlePic:NO withUrl:url];
                            }
                        }
                    }
                }
            }
        }
    }
}

// 设置指定url的图片大小
- (void)setPictureSize:(NSUInteger)picSize withUrl:(NSString *)url
{
    for (NSDictionary *dicParagraph in _marrParagraph) {
        ParagraphElement *pElement = [dicParagraph objectForKey:@"pe"];
        //图片段落
        if (ParagraphElementType_Picture == pElement.eleType) {
            ArticlePicView *picView = [dicParagraph objectForKey:@"view"];
            if ([url isEqualToString:picView.url]) {
                [picView setPictureSize:picSize];
            }
        }
    }
}

// 设置下载指定url的图片的进度
- (void)setProgressOfDownloadPicture:(CGFloat)progress withUrl:(NSString *)url
{
    for (NSDictionary *dicParagraph in _marrParagraph) {
        ParagraphElement *pElement = [dicParagraph objectForKey:@"pe"];
        //图片段落
        if (ParagraphElementType_Picture == pElement.eleType) {
            ArticlePicView *picView = [dicParagraph objectForKey:@"view"];
            if ([url isEqualToString:picView.url]) {
                [picView setProgressOfDownloadPicture:progress];
            }
        }
    }
}

// 设置指定url的图片
- (void)setPicture:(UIImage *)picture withUrl:(NSString *)url
{
    BOOL needLayout = NO;
    for (NSDictionary *dicParagraph in _marrParagraph) {
        ParagraphElement *pElement = [dicParagraph objectForKey:@"pe"];
        //图片段落
        if (ParagraphElementType_Picture == pElement.eleType) {
            ArticlePicView *picView = [dicParagraph objectForKey:@"view"];
            if ([url isEqualToString:picView.url]) {
                picView.picture = picture;
                //
                needLayout = YES;
            }
        }
    }
    if (!needLayout) {
        return;
    }
    //重排
    CGFloat topParagraph = DistanceBetweenParagraph;
    for (NSDictionary *dicParagraph in _marrParagraph) {
        UIView *viewParagraph = [dicParagraph objectForKey:@"view"];
        //
        CGRect frameParagraph = viewParagraph.frame;
        frameParagraph.origin.y = topParagraph;
        viewParagraph.frame = frameParagraph;
        //
        topParagraph += frameParagraph.size.height+DistanceBetweenParagraph;
    }
    //
    CGRect frameSelf = self.frame;
    frameSelf.size.height = topParagraph;
    self.frame = frameSelf;
}

// 获取指定url图片的CGRect
- (CGRect)frameOfPictureWithUrl:(NSString *)url
{
    CGRect framePicture = CGRectZero;
    for (NSDictionary *dicParagraph in _marrParagraph) {
        //图片段落
        if (1 == [[dicParagraph objectForKey:@"type"] intValue]) {
            if ([url isEqualToString:[dicParagraph objectForKey:@"url"]]) {
                ArticlePicView *picView = [dicParagraph objectForKey:@"view"];
                framePicture = picView.frame;
                break;
            }
        }
    }
    return framePicture;
}


#pragma mark - ArticlePicViewDelegate

// 点击到图片
- (void)articlePicViewClickPic:(ArticlePicView *)articlePicView
{
    //图片已经下载成功则查看
    if (articlePicView.picture) {
        
    }
    else {
        //点击图片则强制下载
        if ([self.delegate respondsToSelector:@selector(articleView:forceDownloadArticlePic:withUrl:)]) {
            [self.delegate articleView:self
               forceDownloadArticlePic:YES withUrl:articlePicView.url];
        }
    }
}


#pragma mark - Private

@end
