//
//  LocalArticleVC.m
//  testFSM
//
//  Created by yangjh on 13-6-19.
//  Copyright (c) 2013年 yjh4866. All rights reserved.
//

#import "LocalArticleVC.h"
#import "LocalArticleView.h"

@interface LocalArticleVC () <LocalArticleViewDataSource, LocalArticleViewDelegate>
@property (nonatomic, strong) LocalArticleView *localArticleView;
@end

@implementation LocalArticleVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"本地文章";
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
    
    if (nil == self.localArticleView) {
        self.localArticleView = [[LocalArticleView alloc] initWithFrame:self.view.bounds];
        self.localArticleView.dataSource = self;
        self.localArticleView.delegate = self;
    }
    [self.view addSubview:self.localArticleView];
    
    [self.localArticleView showLocalArticleList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.localArticleView.frame = self.view.bounds;
}

- (void)dealloc
{
}


#pragma mark - LocalArticleViewDataSource

// 加载本地文章列表
- (void)localArticleView:(LocalArticleView *)localArticleView
    loadLocalArticleList:(NSMutableArray *)marrArticleItem
{
    if ([self.dataSource respondsToSelector:@selector(localArticleVC:loadLocalArticleItems:)]) {
        [self.dataSource localArticleVC:self
                  loadLocalArticleItems:marrArticleItem];
    }
}


#pragma mark - LocalArticleViewDelegate

// 查看文章详情
- (void)localArticleView:(LocalArticleView *)localArticleView
           showArticleOf:(NSString *)articleID
{
    if ([self.delegate respondsToSelector:@selector(localArticleVC:showArticleOf:)]) {
        [self.delegate localArticleVC:self showArticleOf:articleID];
    }
}

// 删除本地文章
- (void)localArticleView:(LocalArticleView *)localArticleView
         removeArticleOf:(NSString *)articleID
{
    if ([self.delegate respondsToSelector:@selector(localArticleVC:removeArticleOf:)]) {
        [self.delegate localArticleVC:self removeArticleOf:articleID];
    }
}

@end
