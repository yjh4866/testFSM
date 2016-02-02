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

@interface UIEngine ()
@property (nonatomic, strong) RootViewController *rootVC;
@end

@implementation UIEngine

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        //
        self.rootVC = [[RootViewController alloc] init];
        self.rootVC.delegate = self;
    }
    return self;
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
        [self.rootVC presentViewController:nav animated:NO completion:nil];
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


#pragma mark - ArticleDetailVCDelegate

@end
