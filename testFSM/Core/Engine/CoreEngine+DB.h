//
//  CoreEngine+DB.h
//  testFSM
//
//  Created by yangjh on 13-8-3.
//  Copyright (c) 2013年 yjh4866. All rights reserved.
//

#import "CoreEngine.h"

@class ArticleDetail;

@interface CoreEngine (DB)

// 加载本地文章项
- (void)loadLocalArticleItems:(NSMutableArray *)marrArticleItem;

// 加载文章详情
- (void)loadArticleDetail:(ArticleDetail *)articleDetail
                       of:(NSString *)articleID;

// 删除指定文章详情
- (void)deleteArticleDetailOf:(NSString *)articleID;

@end
