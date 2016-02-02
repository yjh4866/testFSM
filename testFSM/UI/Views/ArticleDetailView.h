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

@end


@protocol ArticleDetailViewDataSource <NSObject>

// 加载文章详情
- (void)articleDetailView:(ArticleDetailView *)articleDetailView
        loadArticleDetail:(ArticleDetail *)articleDetail;

@end


@protocol ArticleDetailViewDelegate <NSObject>

// 保存阅读纪录
- (void)articleDetailView:(ArticleDetailView *)articleDetailView
      saveRecordWithTitle:(NSString *)title;

// 获取文章详情
- (void)articleDetailViewGetDetail:(ArticleDetailView *)articleDetailView;

// 显示指定url的Web页面
- (void)articleDetailView:(ArticleDetailView *)articleDetailView
           showWebWithUrl:(NSString *)url;

@end
