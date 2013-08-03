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

@interface ArticleDetailVC () <ArticleDetailViewDataSource,
ArticleDetailViewDelegate> {
    
    ArticleDetailView *_articleDetailView;
}

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
    
    //文章内容
    if (nil == _articleDetailView) {
        _articleDetailView = [[ArticleDetailView alloc] initWithFrame:self.view.bounds];
        _articleDetailView.fontSize = 14.0f;
        _articleDetailView.dataSource = self;
        _articleDetailView.delegate = self;
    }
    [self.view addSubview:_articleDetailView];
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter removeObserver:self];
    [defaultCenter addObserver:self selector:@selector(notifPictureFileSize:)
                          name:NetDownloadPicFileSize object:nil];
    [defaultCenter addObserver:self selector:@selector(notifPictureReceivedSize:)
                          name:NetDownloadPicReceivedSize object:nil];
    [defaultCenter addObserver:self selector:@selector(notifDownloadPictureSuccess:)
                          name:NetDownloadPictureSuccess object:nil];
    
    //
    _articleDetailView.articleID = self.articleID;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _articleDetailView.frame = self.view.bounds;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //
    [_articleDetailView release];
    //
    self.articleID = nil;
    
    [super dealloc];
}


#pragma mark - ClickEvent


#pragma mark - Notification

- (void)notifArticleDetailFailure:(NSNotification *)notif
{
    NSString *articleID = [notif.userInfo objectForKey:@"articleid"];
    if (![articleID isEqualToString:self.articleID]) {
        return;
    }
    //提示错误
    NSString *msg = [notif.userInfo objectForKey:@"msg"];
    [_articleDetailView articleDetailFailureWithMsg:msg];
}

- (void)notifArticleDetailSuccess:(NSNotification *)notif
{
    NSString *articleID = [notif.userInfo objectForKey:@"articleid"];
    if (![articleID isEqualToString:self.articleID]) {
        return;
    }
    //
    [_articleDetailView articleDetailSuccess];
}

- (void)notifPictureFileSize:(NSNotification *)notif
{
    NSString *url = [notif.userInfo objectForKey:@"url"];
    NSUInteger fileSize = [[notif.userInfo objectForKey:@"filesize"] intValue];
    //
    [_articleDetailView setPictureSize:fileSize withUrl:url];
}

- (void)notifPictureReceivedSize:(NSNotification *)notif
{
    NSString *url = [notif.userInfo objectForKey:@"url"];
    NSUInteger receivedSize = [[notif.userInfo objectForKey:@"receivedsize"] intValue];
    //
    [_articleDetailView receivePartPicture:receivedSize withUrl:url];
}

- (void)notifDownloadPictureSuccess:(NSNotification *)notif
{
    NSString *url = [notif.userInfo objectForKey:@"url"];
    //
    [_articleDetailView downloadPictureSuccessWithUrl:url];
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

// 获取指定url的图片
- (UIImage *)articleDetailView:(ArticleDetailView *)articleDetailView
          getArticlePicWithUrl:(NSString *)url
{
    if ([self.dataSource respondsToSelector:@selector(articleDetailVC:getArticlePicWithUrl:)]) {
        return [self.dataSource articleDetailVC:self getArticlePicWithUrl:url];
    }
    return nil;
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

// 下载图片
- (void)articleDetailView:(ArticleDetailView *)articleDetailView
  forceDownloadArticlePic:(BOOL)force withUrl:(NSString *)url
{
    if ([self.delegate respondsToSelector:@selector(articleDetailVC:forceDownloadArticlePic:withUrl:)]) {
        [self.delegate articleDetailVC:self forceDownloadArticlePic:force
                               withUrl:url];
    }
}

// 显示指定url的Web页面
- (void)articleDetailView:(ArticleDetailView *)articleDetailView
           showWebWithUrl:(NSString *)url
{
}


#pragma mark - Private

@end
