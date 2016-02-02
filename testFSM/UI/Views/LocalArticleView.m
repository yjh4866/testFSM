//
//  LocalArticleView.m
//  testFSM
//
//  Created by yangjh on 13-7-17.
//  Copyright (c) 2013年 yjh4866. All rights reserved.
//

#import "LocalArticleView.h"

@interface LocalArticleView () <UITableViewDataSource, UITableViewDelegate> {
    
    NSMutableDictionary *_mdicArticleGroup;
    NSMutableArray *_marrDate;
}
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation LocalArticleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _mdicArticleGroup = [[NSMutableDictionary alloc] init];
        _marrDate = [[NSMutableArray alloc] init];
        //
        self.tableView = [[UITableView alloc] initWithFrame:self.bounds
                                                      style:UITableViewStylePlain];
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"LocalArticleItmeCell"];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self addSubview:self.tableView];
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
    
    self.tableView.frame = self.bounds;
}

- (void)dealloc
{
}


#pragma mark - Public

// 显示本地文章列表
- (void)showLocalArticleList
{
    [_mdicArticleGroup removeAllObjects];
    NSMutableArray *marrArticleItem = [NSMutableArray array];
    [self.dataSource localArticleView:self loadLocalArticleList:marrArticleItem];
    //遍历以分组
    for (NSDictionary *dicItem in marrArticleItem) {
        NSString *strDate = dicItem[@"date"];
        //找到该日期所属的
        NSMutableArray *marrArticle = _mdicArticleGroup[strDate];
        if (nil == marrArticle) {
            marrArticle = [NSMutableArray array];
            [_mdicArticleGroup setObject:marrArticle forKey:strDate];
        }
        [marrArticle addObject:dicItem];
    }
    //
    [_marrDate setArray:_mdicArticleGroup.allKeys];
    [_marrDate sortUsingComparator:^NSComparisonResult(id obj1, id obj2){if ([obj1 compare:obj2]==NSOrderedAscending) return YES; else return NO;}];
    [self.tableView reloadData];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _marrDate.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_marrDate objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *strDate = _marrDate[section];
    NSArray *arrArticle = _mdicArticleGroup[strDate];
    return arrArticle.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LocalArticleItmeCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    if (indexPath.row%2 > 0) {
        cell.contentView.backgroundColor = Color_OddRowCell;
    }
    else {
        cell.contentView.backgroundColor = Color_EvenRowCell;
    }
    //
    NSString *strDate = _marrDate[indexPath.section];
    NSArray *arrArticle = _mdicArticleGroup[strDate];
    NSDictionary *dicItem = [arrArticle objectAtIndex:indexPath.row];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = dicItem[@"title"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //
    NSString *strDate = _marrDate[indexPath.section];
    NSMutableArray *marrArticle = _mdicArticleGroup[strDate];
    NSDictionary *dicItem = marrArticle[indexPath.row];
    NSString *articleID = dicItem[@"id"];
    [self.delegate localArticleView:self removeArticleOf:articleID];
    //从数据源中删除
    [marrArticle removeObjectAtIndex:indexPath.row];
    //删除Cell的动画
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                          withRowAnimation:UITableViewRowAnimationTop];
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //
    NSString *strDate = _marrDate[indexPath.section];
    NSArray *arrArticle = _mdicArticleGroup[strDate];
    NSDictionary *dicItem = [arrArticle objectAtIndex:indexPath.row];
    NSString *articleID = dicItem[@"id"];
    [self.delegate localArticleView:self showArticleOf:articleID];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

@end
