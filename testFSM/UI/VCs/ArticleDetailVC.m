//
//  ArticleDetailVC.m
//  testFSM
//
//  Created by yangjh on 13-6-12.
//  Copyright (c) 2013年 yjh4866. All rights reserved.
//

#import "ArticleDetailVC.h"
#import "ArticleDetailView.h"
#import "UIView+MBProgressHUD.h"
#import "ArticleDetail.h"
#import "UIMacro.h"
#import "CoreEngine.h"

@interface ArticleDetailVC () <ArticleDetailViewDataSource, ArticleDetailViewDelegate>
@property (nonatomic, strong) ArticleDetailView *articleDetailView;
@end

@implementation ArticleDetailVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"博客正文";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    //文章内容
    if (nil == self.articleDetailView) {
        self.articleDetailView = [[ArticleDetailView alloc] initWithFrame:self.view.bounds];
        self.articleDetailView.fontSize = 14.0f;
        self.articleDetailView.dataSource = self;
        self.articleDetailView.delegate = self;
    }
    [self.view addSubview:self.articleDetailView];
    
    //
    self.articleDetailView.articleID = self.articleID;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.articleDetailView.frame = self.view.bounds;
}

- (void)dealloc
{
}


#pragma mark - ClickEvent


#pragma mark - Notification

- (void)notifArticleDetailFailure:(NSNotification *)notif
{
    NSString *articleID = notif.userInfo[@"articleid"];
    if (![articleID isEqualToString:self.articleID]) {
        return;
    }
    //提示错误
    NSString *msg = notif.userInfo[@"msg"];
    [self.articleDetailView articleDetailFailureWithMsg:msg];
}

- (void)notifArticleDetailSuccess:(NSNotification *)notif
{
    NSString *articleID = notif.userInfo[@"articleid"];
    if (![articleID isEqualToString:self.articleID]) {
        return;
    }
    //
    [self.articleDetailView articleDetailSuccess];
}


#pragma mark - ArticleDetailViewDataSource

// 加载文章详情
- (void)articleDetailView:(ArticleDetailView *)articleDetailView
        loadArticleDetail:(ArticleDetail *)articleDetail
{
    if ([self.dataSource respondsToSelector:@selector(articleDetailVC:loadArticleDetail:)]) {
        [self.dataSource articleDetailVC:self loadArticleDetail:articleDetail];
    }
}


#pragma mark - ArticleDetailViewDelegate

// 保存阅读纪录
- (void)articleDetailView:(ArticleDetailView *)articleDetailView
      saveRecordWithTitle:(NSString *)title
{
}

// 获取文章详情
- (void)articleDetailViewGetDetail:(ArticleDetailView *)articleDetailView
{
}

// 显示指定url的Web页面
- (void)articleDetailView:(ArticleDetailView *)articleDetailView
           showWebWithUrl:(NSString *)url
{
}


#pragma mark - Private

@end
