//
//  ArticleDetailView.m
//  testFSM
//
//  Created by yangjh on 13-7-11.
//  Copyright (c) 2013年 yjh4866. All rights reserved.
//

#import "ArticleDetailView.h"
#import "ScrollLabelView.h"
#import "ParagraphTextCell.h"
#import "ParagraphPicCell.h"
#import "UIView+MBProgressHUD.h"
#import "UIMacro.h"

#import "ArticleDetail.h"
#import "ArticleParagraph.h"

#define Height_ArticleDetailTitle        50.0f

@interface ArticleDetailView () <UITableViewDataSource, UITableViewDelegate, ParagraphPicCellDelegate>
@property (nonatomic, strong) UIImageView *imageViewBG;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ScrollLabelView *scrollTitleView;
@property (nonatomic, strong) UILabel *labelTime;
@property (nonatomic, strong) UIImageView *imageViewTitleShade;

@property (nonatomic, strong) ArticleDetail *articleDetail;
@property (nonatomic, strong) NSArray *paragraphs;
@property (nonatomic, assign) BOOL reloading;
@end

@implementation ArticleDetailView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.reloading = NO;
        self.fontSize = 16.0f;
        self.articleDetail = [[ArticleDetail alloc] init];
        //
        self.imageViewBG = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imageViewBG.image = [UIImage imageNamed:@"detail_back"];
        self.imageViewBG.frame = CGRectMake((self.bounds.size.width-self.imageViewBG.image.size.width)/2, (self.bounds.size.height-self.imageViewBG.image.size.height)/2, self.imageViewBG.image.size.width, self.imageViewBG.image.size.height);
        [self addSubview:self.imageViewBG];
        //文章内容
        self.tableView = [[UITableView alloc] initWithFrame:self.bounds
                                                      style:UITableViewStylePlain];
        [self.tableView registerClass:[ParagraphTextCell class] forCellReuseIdentifier:@"ParagraphTextCell"];
        [self.tableView registerClass:[ParagraphPicCell class] forCellReuseIdentifier:@"ParagraphPicCell"];
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self addSubview:self.tableView];
        //文章标题下的阴影
        CGRect frameTitleShade = CGRectMake(0.0f, Height_ArticleDetailTitle,
                                            CGRectGetWidth(self.bounds), 5.0f);
        self.imageViewTitleShade = [[UIImageView alloc] initWithFrame:frameTitleShade];
        self.imageViewTitleShade.image = [UIImage imageNamed:@"article_titleshade"];
        [self addSubview:self.imageViewTitleShade];
        self.imageViewTitleShade.hidden = YES;
        self.tableView.hidden = YES;
        
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

- (void)layoutSubviews
{
    [super layoutSubviews];
    // 背景
    self.imageViewBG.frame = CGRectMake((CGRectGetWidth(self.bounds)-self.imageViewBG.image.size.width)/2, (self.bounds.size.height-self.imageViewBG.image.size.height)/2, self.imageViewBG.image.size.width, self.imageViewBG.image.size.height);
    // 文章表格
    self.tableView.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.bounds),
                                  CGRectGetHeight(self.bounds));
    {
        // 标题
        CGFloat heightTitle = 30.0f;
        self.scrollTitleView.frame = CGRectMake(10.0f, 0.0f,
                                            CGRectGetWidth(self.tableView.bounds)-20.0f,
                                            heightTitle);
        // 发布时间
        self.labelTime.frame = CGRectMake(10.0f, heightTitle,
                                      CGRectGetWidth(self.tableView.bounds)-20.0f,
                                      Height_ArticleDetailTitle-heightTitle);
        self.imageViewTitleShade.frame = CGRectMake(0.0f, Height_ArticleDetailTitle,
                                                CGRectGetWidth(self.bounds), 5.0f);
    }
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"self.articleID"];
}


#pragma mark - Property

- (NSString *)authorID
{
    return self.articleDetail.authorID;
}

- (NSString *)articleUrl
{
    return self.articleDetail.articleUrl;
}


#pragma mark - NSKeyValueObserving

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"self.articleID"]) {
        if (self.articleID.length > 0 &&
            [self.articleDetail.articleID isEqualToString:self.articleID]) {
            return;
        }
        self.articleDetail.articleID = self.articleID;
        [self hideActivity];
        //
        //加载本地已有文章详情
        {
            [self.dataSource articleDetailView:self
                             loadArticleDetail:self.articleDetail];
            //
            if (self.articleDetail.body.length > 0) {
                self.scrollTitleView.labelText.text = self.articleDetail.title;
                self.labelTime.text = [NSString stringWithFormat:@"发布时间：%@",
                                   self.articleDetail.publishTime];
                // 解析文件段落
                [self parseArticle:self.articleDetail.body];
                //
                [self.tableView setContentOffset:CGPointZero animated:NO];
            }
            self.tableView.hidden = !self.articleDetail.body.length>0;
        }
        //本地文章详情存在则产生阅读纪录
        if (self.articleDetail.body.length > 0) {
            [self.delegate articleDetailView:self
                         saveRecordWithTitle:self.articleDetail.title];
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
    if (self.articleDetail.articleUrl.length > 0) {
        [self.delegate articleDetailView:self
                          showWebWithUrl:self.articleDetail.articleUrl];
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
    self.reloading = NO;
}

// 获取文章详情成功
- (void)articleDetailSuccess
{
    [self hideActivity];
    //
    self.reloading = NO;
    //加载本地数据
    {
        [self.dataSource articleDetailView:self
                         loadArticleDetail:self.articleDetail];
        //
        self.scrollTitleView.labelText.text = self.articleDetail.title;
        self.labelTime.text = [NSString stringWithFormat:@"发布时间：%@",
                           self.articleDetail.publishTime];
    }
    self.tableView.hidden = !self.articleDetail.body.length>0;
    //本地文章详情存在则产生阅读纪录
    if (self.articleDetail.body.length > 0) {
        [self.delegate articleDetailView:self
                     saveRecordWithTitle:self.articleDetail.title];
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.paragraphs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.paragraphs.count) {
        ParagraphElement *pEle = self.paragraphs[indexPath.row];
        if (ParagraphElementType_Text == pEle.eleType) {
            ParagraphTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ParagraphTextCell"];
            cell.fontSize = self.fontSize;
            cell.paragraphElement = pEle;
            return cell;
        }
        else if (ParagraphElementType_Picture == pEle.eleType) {
            ParagraphPicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ParagraphPicCell"];
            cell.paragraphElement = pEle;
            cell.row = indexPath.row;
            cell.delegate = self;
            return cell;
        }
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.paragraphs.count) {
        ParagraphElement *pEle = self.paragraphs[indexPath.row];
        if (ParagraphElementType_Text == pEle.eleType) {
            return [ParagraphTextCell cellHeightWith:pEle fontSize:self.fontSize
                                        andCellWidth:tableView.bounds.size.width];
        }
        else if (ParagraphElementType_Picture == pEle.eleType) {
            return [ParagraphPicCell cellHeightWith:pEle andCellWidth:tableView.bounds.size.width];
        }
    }
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return Height_ArticleDetailTitle;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect frameHeader = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds),
                                    Height_ArticleDetailTitle);
    UIControl *headerView = [[UIControl alloc] initWithFrame:frameHeader];
    headerView.backgroundColor = [UIColor colorWithWhite:236.0f/255.0f alpha:1.0f];
    //标题
    CGFloat heightTitle = 30.0f;
    if (nil == self.scrollTitleView) {
        CGRect frameTitle = CGRectMake(20.0f, 0.0f,
                                       CGRectGetWidth(self.tableView.bounds)-40.0f,
                                       heightTitle);
        self.scrollTitleView = [[ScrollLabelView alloc] initWithFrame:frameTitle];
        self.scrollTitleView.backgroundColor = [UIColor clearColor];
        self.scrollTitleView.labelText.font = [UIFont systemFontOfSize:18.0f];
        self.scrollTitleView.labelText.text = self.articleDetail.title;
        self.scrollTitleView.userInteractionEnabled = NO;
    }
    [headerView addSubview:self.scrollTitleView];
    //时间
    if (nil == self.labelTime) {
        CGRect frameTime = CGRectMake(10.0f, heightTitle,
                                      CGRectGetWidth(tableView.bounds)-20.0f,
                                      Height_ArticleDetailTitle-heightTitle);
        self.labelTime = [[UILabel alloc] initWithFrame:frameTime];
        self.labelTime.backgroundColor = [UIColor clearColor];
        self.labelTime.textAlignment = NSTextAlignmentCenter;
        self.labelTime.font = [UIFont systemFontOfSize:12.0f];
        self.labelTime.text = [NSString stringWithFormat:@"发布时间：%@",
                           self.articleDetail.publishTime];
        self.labelTime.userInteractionEnabled = NO;
    }
    [headerView addSubview:self.labelTime];
    //点击文章标题可以在Safri中查看
    [headerView addTarget:self action:@selector(clickShowInSafri:)
         forControlEvents:UIControlEventTouchUpInside];
    return headerView;
}


#pragma mark - ParagraphPicCellDelegate

// 图片下载成功，高度会发生变更
- (void)paragraphPicCellDownloadPictureSuccess:(ParagraphPicCell *)cell
{
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:cell.row inSection:0]]
                          withRowAnimation:UITableViewRowAnimationNone];
}


#pragma mark - Private

// 解析文件段落
- (void)parseArticle:(NSString *)article
{
    NSMutableArray *marrParagraph = [NSMutableArray array];
    // 解析段落
    NSArray *arrParagraph = [ArticleParagraph parseParagraphFromArticle:article];
    // 遍历段落
    for (NSArray *arrParagraphElement in arrParagraph) {
        for (ParagraphElement *pElement in arrParagraphElement) {
            [marrParagraph addObject:pElement];
        }
    }
    self.paragraphs = marrParagraph;
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
