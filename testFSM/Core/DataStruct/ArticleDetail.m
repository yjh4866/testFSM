//
//  ArticleDetail.m
//  testFSM
//
//  Created by yangjh on 13-6-3.
//  Copyright (c) 2013年 yjh4866. All rights reserved.
//

#import "ArticleDetail.h"

@implementation ArticleDetail

- (id)init
{
    self = [super init];
    if (self) {
        self.articleID = @"";
        self.title = @"";
        self.body = @"";
        self.publishTime = @"";
        self.updateTime = @"";
        self.authorID = @"";
        self.author = @"";
        self.articleUrl = @"";
        self.authorBlogUrl = @"";
        self.hits = @"";
    }
    return self;
}

- (void)dealloc
{
}

@end
