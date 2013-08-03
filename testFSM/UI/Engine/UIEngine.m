//
//  UIEngine.m
//  testFSM
//
//  Created by yangjh on 13-8-3.
//  Copyright (c) 2013年 yjh4866. All rights reserved.
//

#import "UIEngine.h"
#import "UIDevice+Custom.h"
#import "CoreEngine+DB.h"
#import "CoreEngine+FileManager.h"
#import "CoreEngine+Send.h"

@interface UIEngine () {
    
    RootViewController *_rootViewController;
}

@end

@implementation UIEngine

@synthesize rootViewController = _rootViewController;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        //
        _rootViewController = [[RootViewController alloc] init];
        _rootViewController.delegate = self;
        UILOG(@"创建UIEngine");
    }
    return self;
}

- (void)dealloc
{
    //
    [_rootViewController release];
    //
    self.coreEngine = nil;
    
    [super dealloc];
}


#pragma mark - RootVCDelegate

// 是否为第一次显示
- (void)rootVC:(RootViewController *)rootVC didFirstAppear:(BOOL)firstAppear
{
    if (firstAppear) {
        LocalArticleVC *articleListVC = [[LocalArticleVC alloc] init];
        articleListVC.dataSource = self;
        articleListVC.delegate = self;
        //
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:articleListVC];
        if ([UIDevice systemVersionID] < __IPHONE_5_0) {
            [_rootViewController presentModalViewController:nav animated:NO];
        }
        else {
            [_rootViewController presentViewController:nav animated:NO completion:nil];
        }
        [nav release];
        [articleListVC release];
    }
}


#pragma mark - LocalArticleVCDataSource

// 加载本地文章
- (void)localArticleVC:(LocalArticleVC *)localArticleVC
 loadLocalArticleItems:(NSMutableArray *)marrArticleItem
{
    [self.coreEngine loadLocalArticleItems:marrArticleItem];
}


#pragma mark - LocalArticleVCDelegate

// 查看文章详情
- (void)localArticleVC:(LocalArticleVC *)localArticleVC
         showArticleOf:(NSString *)articleID
{
    ArticleDetailVC *articleVC = [[ArticleDetailVC alloc] init];
    articleVC.articleID = articleID;
    articleVC.dataSource = self;
    articleVC.delegate = self;
    [localArticleVC.navigationController pushViewController:articleVC
                                                   animated:YES];
    [articleVC release];
}

// 删除本地文章
- (void)localArticleVC:(LocalArticleVC *)localArticleVC
       removeArticleOf:(NSString *)articleID
{
    [self.coreEngine deleteArticleDetailOf:articleID];
}


#pragma mark - ArticleDetailVCDataSource

// 加载文章详情
- (void)articleDetailVC:(ArticleDetailVC *)articleVC
      loadArticleDetail:(ArticleDetail *)articleDetail
{
    [self.coreEngine loadArticleDetail:articleDetail of:articleVC.articleID];
}

// 获取指定url的图片
- (UIImage *)articleDetailVC:(ArticleDetailVC *)articleVC
        getArticlePicWithUrl:(NSString *)url
{
    return [self.coreEngine pictureWithUrl:url];
}


#pragma mark - ArticleDetailVCDelegate

// 下载图片
- (void)articleDetailVC:(ArticleDetailVC *)articleVC
forceDownloadArticlePic:(BOOL)force withUrl:(NSString *)url
{
    [self.coreEngine forceDownloadPicture:force withUrl:url];
}

@end
