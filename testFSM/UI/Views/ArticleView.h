//
//  ArticleView.h
//  testFSM
//
//  Created by yangjh on 13-6-13.
//  Copyright (c) 2013年 yjh4866. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ArticleViewDataSource;
@protocol ArticleViewDelegate;

@interface ArticleView : UIView

@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, retain) NSString *article;
@property (nonatomic, assign) id <ArticleViewDataSource> dataSource;
@property (nonatomic, assign) id <ArticleViewDelegate> delegate;

// 设置显示区域以计算是否需要下载图片
- (void)showRect:(CGRect)frameShow;

// 设置指定url的图片大小
- (void)setPictureSize:(NSUInteger)picSize withUrl:(NSString *)url;

// 设置下载到指定url的图片的大小
- (void)receivePartPicture:(NSUInteger)picPartSize withUrl:(NSString *)url;

// 设置指定url的图片
- (void)setPicture:(UIImage *)picture withUrl:(NSString *)url;

// 获取指定url图片的CGRect
- (CGRect)frameOfPictureWithUrl:(NSString *)url;

@end


@protocol ArticleViewDataSource <NSObject>

// 获取指定url的图片
- (UIImage *)articleView:(ArticleView *)articleView
    getArticlePicWithUrl:(NSString *)url;

@end


@protocol ArticleViewDelegate <NSObject>

// 下载图片
- (void)articleView:(ArticleView *)articleView forceDownloadArticlePic:(BOOL)force
            withUrl:(NSString *)url;

@end
