//
//  UIEngine.h
//  testFSM
//
//  Created by yangjh on 13-8-3.
//  Copyright (c) 2013年 yjh4866. All rights reserved.
//

#import <Foundation/Foundation.h>


//Root
#import "RootViewController.h"
//
#import "LocalArticleVC.h"
#import "ArticleDetailVC.h"


@class CoreEngine;

@interface UIEngine : NSObject <RootVCDelegate,
LocalArticleVCDataSource, LocalArticleVCDelegate,
ArticleDetailVCDataSource, ArticleDetailVCDelegate>

@property (nonatomic, readonly) UIViewController *rootViewController;
@property (nonatomic, retain) CoreEngine *coreEngine;

@end
