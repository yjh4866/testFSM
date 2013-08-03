//
//  LocalArticleView.m
//  testFSM
//
//  Created by yangjh on 13-7-17.
//  Copyright (c) 2013年 yjh4866. All rights reserved.
//

#import "LocalArticleView.h"

@interface LocalArticleView () <UITableViewDataSource, UITableViewDelegate> {
    
    UITableView *_tableView;
    
    NSMutableDictionary *_mdicArticleGroup;
    NSMutableArray *_marrDate;
}

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
        _tableView = [[UITableView alloc] initWithFrame:self.bounds
                                                  style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [self addSubview:_tableView];
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
    
    _tableView.frame = self.bounds;
}

- (void)dealloc
{
    [_tableView release];
    //
    [_mdicArticleGroup release];
    [_marrDate release];
    
    [super dealloc];
}


#pragma mark - Public

// 显示本地文章列表
- (void)showLocalArticleList
{
    [_mdicArticleGroup removeAllObjects];
    NSMutableArray *marrArticleItem = [[NSMutableArray alloc] init];
    [self.dataSource localArticleView:self loadLocalArticleList:marrArticleItem];
    //遍历以分组
    for (NSDictionary *dicItem in marrArticleItem) {
        NSString *strDate = [dicItem objectForKey:@"date"];
        //找到该日期所属的
        NSMutableArray *marrArticle = [_mdicArticleGroup objectForKey:strDate];
        if (nil == marrArticle) {
            marrArticle = [[NSMutableArray alloc] init];
            [_mdicArticleGroup setObject:marrArticle forKey:strDate];
            [marrArticle release];
        }
        [marrArticle addObject:dicItem];
    }
    [marrArticleItem release];
    //
    [_marrDate setArray:_mdicArticleGroup.allKeys];
    [_marrDate sortUsingComparator:^NSComparisonResult(id obj1, id obj2){if ([obj1 compare:obj2]==NSOrderedAscending) return YES; else return NO;}];
    [_tableView reloadData];
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
    NSString *strDate = [_marrDate objectAtIndex:section];
    NSArray *arrArticle = [_mdicArticleGroup objectForKey:strDate];
    return arrArticle.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellId = @"LocalArticleItmeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId];
    if (nil == cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellId] autorelease];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    if (indexPath.row%2 > 0) {
        cell.contentView.backgroundColor = Color_OddRowCell;
    }
    else {
        cell.contentView.backgroundColor = Color_EvenRowCell;
    }
    //
    NSString *strDate = [_marrDate objectAtIndex:indexPath.section];
    NSArray *arrArticle = [_mdicArticleGroup objectForKey:strDate];
    NSDictionary *dicItem = [arrArticle objectAtIndex:indexPath.row];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = [dicItem objectForKey:@"title"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //
    NSString *strDate = [_marrDate objectAtIndex:indexPath.section];
    NSMutableArray *marrArticle = [_mdicArticleGroup objectForKey:strDate];
    NSDictionary *dicItem = [marrArticle objectAtIndex:indexPath.row];
    NSString *articleID = [dicItem objectForKey:@"id"];
    [self.delegate localArticleView:self removeArticleOf:articleID];
    //从数据源中删除
    [marrArticle removeObjectAtIndex:indexPath.row];
    //删除Cell的动画
    [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                      withRowAnimation:UITableViewRowAnimationTop];
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //
    NSString *strDate = [_marrDate objectAtIndex:indexPath.section];
    NSArray *arrArticle = [_mdicArticleGroup objectForKey:strDate];
    NSDictionary *dicItem = [arrArticle objectAtIndex:indexPath.row];
    NSString *articleID = [dicItem objectForKey:@"id"];
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
