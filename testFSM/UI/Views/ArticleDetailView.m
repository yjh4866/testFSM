//
//  ArticleDetailView.m
//  testFSM
//
//  Created by yangjh on 13-7-11.
//  Copyright (c) 2013年 yjh4866. All rights reserved.
//

#import "ArticleDetailView.h"
#import "ArticleDetail.h"
#import "ScrollLabelView.h"
#import "ArticleView.h"
#import "UIView+MBProgressHUD.h"
#import "UIMacro.h"

#define Height_ArticleDetailTitle        50.0f

@interface ArticleDetailView () <UITableViewDataSource, UITableViewDelegate,
ArticleViewDataSource, ArticleViewDelegate> {
    
    UIImageView *_imageViewBG;
    
    UITableView *_tableView;
    ScrollLabelView *_scrollTitleView;
    UILabel *_labelTime;
    UIImageView *_imageViewTitleShade;
    ArticleView *_articleView;
    
    ArticleDetail *_articleDetail;
    BOOL _reloading;
}

@end

@implementation ArticleDetailView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _reloading = NO;
        self.fontSize = 16.0f;
        _articleDetail = [[ArticleDetail alloc] init];
        //
        {
            _imageViewBG = [[UIImageView alloc] initWithFrame:self.bounds];
            SetImageForImageView(_imageViewBG, @"detail_back");
            _imageViewBG.frame = CGRectMake((self.bounds.size.width-_imageViewBG.image.size.width)/2, (self.bounds.size.height-_imageViewBG.image.size.height)/2, _imageViewBG.image.size.width, _imageViewBG.image.size.height);
            [self addSubview:_imageViewBG];
        }
        //文章内容
        {
            _tableView = [[UITableView alloc] initWithFrame:self.bounds
                                                      style:UITableViewStylePlain];
            _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            _tableView.dataSource = self;
            _tableView.delegate = self;
            [self addSubview:_tableView];
        }
        //文章标题下的阴影
        {
            if (nil == _imageViewTitleShade) {
                CGRect frameTitleShade = CGRectMake(0.0f, Height_ArticleDetailTitle,
                                                    CGRectGetWidth(self.bounds), 5.0f);
                _imageViewTitleShade = [[UIImageView alloc] initWithFrame:frameTitleShade];
                SetImageForImageView(_imageViewTitleShade, @"article_titleshade");
            }
            [self addSubview:_imageViewTitleShade];
            _imageViewTitleShade.hidden = YES;
        }
        _tableView.hidden = YES;
        
        [self addObserver:self forKeyPath:@"self.articleID"
                  options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setFrame:(CGRect)frame
{
    super.frame = frame;
    
    //背景
    _imageViewBG.frame = CGRectMake((CGRectGetWidth(self.bounds)-_imageViewBG.image.size.width)/2, (self.bounds.size.height-_imageViewBG.image.size.height)/2, _imageViewBG.image.size.width, _imageViewBG.image.size.height);
    //文章表格
    _tableView.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.bounds),
                                  CGRectGetHeight(self.bounds));
    {
        //标题
        CGFloat heightTitle = 30.0f;
        _scrollTitleView.frame = CGRectMake(20.0f, 0.0f,
                                            CGRectGetWidth(_tableView.bounds)-40.0f,
                                            heightTitle);
        //发布时间
        _labelTime.frame = CGRectMake(10.0f, heightTitle,
                                      CGRectGetWidth(_tableView.bounds)-20.0f,
                                      Height_ArticleDetailTitle-heightTitle);
        _imageViewTitleShade.frame = CGRectMake(0.0f, Height_ArticleDetailTitle,
                                                CGRectGetWidth(self.bounds), 5.0f);
        //文章显示页宽度调整
        CGRect frameArticle = CGRectMake(0.0f, 0.0f,
                                         CGRectGetWidth(_tableView.bounds), 0.0f);
        if (frameArticle.size.width > 0 &&
            _articleView.frame.size.width != frameArticle.size.width) {
            _articleView.frame = frameArticle;
            _articleView.article = _articleDetail.body;
        }
        //刷新文章显示区
        [self updateArticleRect];
    }
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"self.articleID"];
    //
    [_imageViewBG release];
    [_tableView release];
    [_scrollTitleView release];
    [_labelTime release];
    [_imageViewTitleShade release];
    [_articleView release];
    //
    [_articleDetail release];
    self.articleID = nil;
    
    [super dealloc];
}


#pragma mark - Property

- (NSString *)authorID
{
    return _articleDetail.authorID;
}

- (NSString *)articleUrl
{
    return _articleDetail.articleUrl;
}


#pragma mark - NSKeyValueObserving

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"self.articleID"]) {
        if (self.articleID.length > 0 &&
            [_articleDetail.articleID isEqualToString:self.articleID]) {
            return;
        }
        _articleDetail.articleID = self.articleID;
        [self hideActivity];
        //
        //加载本地已有文章详情
        {
            [self.dataSource articleDetailView:self
                             loadArticleDetail:_articleDetail];
            //
            if (_articleDetail.body.length > 0) {
                _articleView.article = _articleDetail.body;
                _scrollTitleView.labelText.text = _articleDetail.title;
                _labelTime.text = [NSString stringWithFormat:@"发布时间：%@",
                                   _articleDetail.publishTime];
                //
                [_tableView setContentOffset:CGPointZero animated:NO];
                //刷新文章显示区
                [self updateArticleRect];
            }
            _tableView.hidden = !_articleDetail.body.length>0;
        }
        //本地文章详情存在则产生阅读纪录
        if (_articleDetail.body.length > 0) {
            [self.delegate articleDetailView:self
                         saveRecordWithTitle:_articleDetail.title];
        }
        //不存在则下载
        else {
            [self.delegate articleDetailViewGetDetail:self];
            [self showActivity];
        }
    }
}


#pragma mark - ClickEvent

- (void)clickShowInSafri:(id)sender
{
    if (_articleDetail.articleUrl.length > 0) {
        [self.delegate articleDetailView:self
                          showWebWithUrl:_articleDetail.articleUrl];
    }
}


#pragma mark - Public

// 获取文章详情失败
- (void)articleDetailFailureWithMsg:(NSString *)msg
{
    [self hideActivity];
    if (msg.length > 0) {
        [self showTextNoActivity:msg timeLength:1.0f];
    }
    //
    _reloading = NO;
}

// 获取文章详情成功
- (void)articleDetailSuccess
{
    [self hideActivity];
    //
    _reloading = NO;
    //加载本地数据
    {
        [self.dataSource articleDetailView:self
                         loadArticleDetail:_articleDetail];
        //
        _scrollTitleView.labelText.text = _articleDetail.title;
        _labelTime.text = [NSString stringWithFormat:@"发布时间：%@",
                           _articleDetail.publishTime];
        _articleView.article = _articleDetail.body;
        //刷新文章显示区
        [self updateArticleRect];
    }
    _tableView.hidden = !_articleDetail.body.length>0;
    //本地文章详情存在则产生阅读纪录
    if (_articleDetail.body.length > 0) {
        [self.delegate articleDetailView:self
                     saveRecordWithTitle:_articleDetail.title];
    }
}

// 设置指定url的图片大小
- (void)setPictureSize:(NSUInteger)picSize withUrl:(NSString *)url
{
    [_articleView setPictureSize:picSize withUrl:url];
}

// 设置下载指定url的图片的进度
- (void)setProgressOfDownloadPicture:(CGFloat)progress withUrl:(NSString *)url
{
    [_articleView setProgressOfDownloadPicture:progress withUrl:url];
}

// 指定的url图片下载成功
- (void)downloadPictureSuccessWithUrl:(NSString *)url
{
    //
    @autoreleasepool {
        UIImage *picture = [self.dataSource articleDetailView:self
                                         getArticlePicWithUrl:url];
        [_articleView setPicture:picture withUrl:url];
    }
    //更新显示
    [_tableView reloadData];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (0 == indexPath.row) {
        NSString *CellId = @"ArticleBodyCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellId];
        if (nil == cell) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellId] autorelease];
        }
        while (cell.subviews.count > 0) {
            [[cell.subviews lastObject] removeFromSuperview];
        }
        //
        [cell addSubview:_articleView];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row) {
        if (nil == _articleView) {
            CGRect frameArticle = CGRectMake(0.0f, 0.0f, CGRectGetWidth(_tableView.bounds), self.bounds.size.height-Height_ArticleDetailTitle);
            _articleView = [[ArticleView alloc] initWithFrame:frameArticle];
            _articleView.fontSize = self.fontSize;
            _articleView.dataSource = self;
            _articleView.delegate = self;
            _articleView.article = _articleDetail.body;
        }
        return _articleView.bounds.size.height;
    }
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return Height_ArticleDetailTitle;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect frameHeader = CGRectMake(0.0f, 0.0f,
                                    CGRectGetWidth(tableView.bounds),
                                    Height_ArticleDetailTitle);
    UIControl *headerView = [[[UIControl alloc] initWithFrame:frameHeader] autorelease];
    headerView.backgroundColor = [UIColor colorWithWhite:236.0f/255.0f alpha:1.0f];
    //标题
    CGFloat heightTitle = 30.0f;
    if (nil == _scrollTitleView) {
        CGRect frameTitle = CGRectMake(20.0f, 0.0f,
                                       CGRectGetWidth(_tableView.bounds)-40.0f,
                                       heightTitle);
        _scrollTitleView = [[ScrollLabelView alloc] initWithFrame:frameTitle];
        _scrollTitleView.backgroundColor = [UIColor clearColor];
        _scrollTitleView.labelText.font = [UIFont systemFontOfSize:18.0f];
        _scrollTitleView.labelText.text = _articleDetail.title;
        _scrollTitleView.userInteractionEnabled = NO;
    }
    [headerView addSubview:_scrollTitleView];
    //时间
    if (nil == _labelTime) {
        CGRect frameTime = CGRectMake(10.0f, heightTitle,
                                      CGRectGetWidth(tableView.bounds)-20.0f,
                                      Height_ArticleDetailTitle-heightTitle);
        _labelTime = [[UILabel alloc] initWithFrame:frameTime];
        _labelTime.backgroundColor = [UIColor clearColor];
        _labelTime.textAlignment = UITextAlignmentCenter;
        _labelTime.font = [UIFont systemFontOfSize:12.0f];
        _labelTime.text = [NSString stringWithFormat:@"发布时间：%@",
                           _articleDetail.publishTime];
        _labelTime.userInteractionEnabled = NO;
    }
    [headerView addSubview:_labelTime];
    //点击文章标题可以在Safri中查看
    [headerView addTarget:self action:@selector(clickShowInSafri:)
         forControlEvents:UIControlEventTouchUpInside];
    return headerView;
}


#pragma mark - ArticleViewDataSource

// 获取指定url的图片
- (UIImage *)articleView:(ArticleView *)articleView
    getArticlePicWithUrl:(NSString *)url
{
    return [self.dataSource articleDetailView:self getArticlePicWithUrl:url];
}


#pragma mark - ArticleViewDelegate

// 下载图片
- (void)articleView:(ArticleView *)articleView forceDownloadArticlePic:(BOOL)force
            withUrl:(NSString *)url
{
    [self.delegate articleDetailView:self
             forceDownloadArticlePic:force withUrl:url];
}


#pragma mark - Private

// 刷新文章显示区
- (void)updateArticleRect
{
    //计算文章内容的显示区域
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    CGRect frameShow = [_tableView rectForRowAtIndexPath:indexPath];
    if (_tableView.contentOffset.y > frameShow.origin.y) {
        frameShow.origin.y = _tableView.contentOffset.y - frameShow.origin.y;
        frameShow.size.height = _tableView.bounds.size.height;
    }
    else {
        frameShow.size.height = _tableView.bounds.size.height-(frameShow.origin.y-_tableView.contentOffset.y);
        frameShow.origin.y = 0.0f;
    }
    [_articleView showRect:frameShow];
    //
    [_tableView reloadData];
}

// 显示工具栏
- (void)showToolbar
{
}

// 隐藏工具栏
- (void)hideToolbar
{
}

@end
