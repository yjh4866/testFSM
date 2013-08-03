//
//  ArticleDetailView.h
//  testFSM
//
//  Created by yangjh on 13-7-11.
//  Copyright (c) 2013年 yjh4866. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ArticleDetail;

@protocol ArticleDetailViewDataSource;
@protocol ArticleDetailViewDelegate;

@interface ArticleDetailView : UIView

@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, copy) NSString *articleID;
@property (nonatomic, readonly) NSString *authorID;
@property (nonatomic, readonly) NSString *articleUrl;
@property (nonatomic, assign) id <ArticleDetailViewDataSource> dataSource;
@property (nonatomic, assign) id <ArticleDetailViewDelegate> delegate;

// 获取文章详情失败
- (void)articleDetailFailureWithMsg:(NSString *)msg;

// 获取文章详情成功
- (void)articleDetailSuccess;

// 设置指定url的图片大小
- (void)setPictureSize:(NSUInteger)picSize withUrl:(NSString *)url;

// 设置下载到指定url的图片的大小
- (void)receivePartPicture:(NSUInteger)picPartSize withUrl:(NSString *)url;

// 指定的url图片下载成功
- (void)downloadPictureSuccessWithUrl:(NSString *)url;

@end


@protocol ArticleDetailViewDataSource <NSObject>

// 加载文章详情
- (void)articleDetailView:(ArticleDetailView *)articleDetailView
        loadArticleDetail:(ArticleDetail *)articleDetail;

// 获取指定url的图片
- (UIImage *)articleDetailView:(ArticleDetailView *)articleDetailView
          getArticlePicWithUrl:(NSString *)url;

@end


@protocol ArticleDetailViewDelegate <NSObject>

// 保存阅读纪录
- (void)articleDetailView:(ArticleDetailView *)articleDetailView
      saveRecordWithTitle:(NSString *)title;

// 获取文章详情
- (void)articleDetailViewGetDetail:(ArticleDetailView *)articleDetailView;

// 下载图片
- (void)articleDetailView:(ArticleDetailView *)articleDetailView
  forceDownloadArticlePic:(BOOL)force withUrl:(NSString *)url;

// 显示指定url的Web页面
- (void)articleDetailView:(ArticleDetailView *)articleDetailView
           showWebWithUrl:(NSString *)url;

@end
