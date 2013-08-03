//
//  DBController+Article.h
//  testFSM
//
//  Created by yangjh on 13-6-12.
//  Copyright (c) 2013年 yjh4866. All rights reserved.
//

#import "DBController.h"

@class ArticleDetail;

@interface DBController (Article)

// 添加文章详情
+ (void)addArticleDetail:(ArticleDetail *)articleDetail;

// 加载本地文章列表
+ (void)loadLocalArticleItems:(NSMutableArray *)marrArticleItem;

// 加载文章详情
+ (void)loadArticleDetail:(ArticleDetail *)articleDetail of:(NSString *)articleID;

// 是否存在指定文章详情
+ (BOOL)existArticleDetailOf:(NSString *)articleID;

// 删除指定文章详情
+ (void)deleteArticleDetailOf:(NSString *)articleID;

@end
