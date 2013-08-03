//
//  ArticleDetailVC.h
//  testFSM
//
//  Created by yangjh on 13-6-12.
//  Copyright (c) 2013年 yjh4866. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ArticleDetail;

@protocol ArticleDetailVCDataSource;
@protocol ArticleDetailVCDelegate;

@interface ArticleDetailVC : UIViewController

@property (nonatomic, copy) NSString *articleID;
@property (nonatomic, assign) id <ArticleDetailVCDataSource> dataSource;
@property (nonatomic, assign) id <ArticleDetailVCDelegate> delegate;

@end


@protocol ArticleDetailVCDataSource <NSObject>

@optional

// 加载文章详情
- (void)articleDetailVC:(ArticleDetailVC *)articleVC
      loadArticleDetail:(ArticleDetail *)articleDetail;

// 获取指定url的图片
- (UIImage *)articleDetailVC:(ArticleDetailVC *)articleVC
        getArticlePicWithUrl:(NSString *)url;

@end


@protocol ArticleDetailVCDelegate <NSObject>

@optional

// 下载图片
- (void)articleDetailVC:(ArticleDetailVC *)articleVC
forceDownloadArticlePic:(BOOL)force withUrl:(NSString *)url;

@end
