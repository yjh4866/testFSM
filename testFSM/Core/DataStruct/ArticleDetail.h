//
//  ArticleDetail.h
//  testFSM
//
//  Created by yangjh on 13-6-3.
//  Copyright (c) 2013年 yjh4866. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArticleDetail : NSObject

@property (nonatomic, copy) NSString *articleID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, copy) NSString *publishTime;
@property (nonatomic, copy) NSString *updateTime;
@property (nonatomic, copy) NSString *authorID;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSArray *tags;
@property (nonatomic, copy) NSString *articleUrl;
@property (nonatomic, copy) NSString *authorBlogUrl;
@property (nonatomic, copy) NSString *hits;
@property (nonatomic, assign) BOOL favorite;

@end
