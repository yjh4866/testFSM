//
//  CoreEngine+DB.m
//  testFSM
//
//  Created by yangjh on 13-8-3.
//  Copyright (c) 2013年 yjh4866. All rights reserved.
//

#import "CoreEngine+DB.h"
#import "DBController+Article.h"

@implementation CoreEngine (DB)

// 加载本地文章项
- (void)loadLocalArticleItems:(NSMutableArray *)marrArticleItem
{
    [DBController loadLocalArticleItems:marrArticleItem];
}

// 加载文章详情
- (void)loadArticleDetail:(ArticleDetail *)articleDetail
                       of:(NSString *)articleID
{
    [DBController loadArticleDetail:articleDetail of:articleID];
}

// 删除指定文章详情
- (void)deleteArticleDetailOf:(NSString *)articleID
{
    [DBController deleteArticleDetailOf:articleID];
}

@end
