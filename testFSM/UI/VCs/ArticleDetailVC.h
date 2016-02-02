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

@end


@protocol ArticleDetailVCDelegate <NSObject>

@optional

@end
