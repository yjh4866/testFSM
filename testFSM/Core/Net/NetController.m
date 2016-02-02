//
//  NetController.m
//  testFSM
//
//  Created by yangjh on 13-8-3.
//  Copyright (c) 2013年 yjh4866. All rights reserved.
//

#import "NetController.h"
#import "NBLHTTPManager.h"
#import "NBLHTTPFileManager.h"


#ifdef DEBUG
#define HOST_Interface     @"http://dp.sina.cn/interface/"
#else
#define HOST_Interface     @"http://dp.sina.cn/interface/"
#endif


#define ArticleUrl        HOST_Interface @"article_read.php?articleid=%@"


@interface NetController ()
@end


@implementation NetController


#pragma mark - Public

+ (NetController *)sharedInstance
{
    static NetController *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[NetController alloc] init];
    });
    return sharedInstance;
}


#pragma mark - ()

@end
