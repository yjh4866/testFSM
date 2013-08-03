//
//  DBController+Article.m
//  testFSM
//
//  Created by yangjh on 13-6-12.
//  Copyright (c) 2013年 yjh4866. All rights reserved.
//

#import "DBController+Article.h"
#import "ArticleDetail.h"
#import "JSONKit.h"

@implementation DBController (Article)

// 添加文章详情
+ (void)addArticleDetail:(ArticleDetail *)articleDetail
{
    if ([DBController existArticleDetailOf:articleDetail.articleID]) {
        [DBController deleteArticleDetailOf:articleDetail.articleID];
    }
    
    const char* sql = "INSERT INTO articledetail VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    DBStatement *stmt = [[DBStatement alloc] initWithSQL:sql];
    [stmt bindString:articleDetail.articleID forIndex:2];
    [stmt bindString:articleDetail.title forIndex:3];
    [stmt bindString:articleDetail.body forIndex:4];
    [stmt bindString:articleDetail.publishTime forIndex:5];
    [stmt bindString:articleDetail.updateTime forIndex:6];
    [stmt bindString:articleDetail.authorID forIndex:7];
    [stmt bindString:articleDetail.author forIndex:8];
    [stmt bindString:articleDetail.hits forIndex:9];
    [stmt bindString:@"" forIndex:10];
    [stmt bindInt32:0 forIndex:11];
    [stmt bindString:@"" forIndex:12];
    [stmt bindInt32:0 forIndex:13];
    [stmt bindInt32:0 forIndex:14];
    [stmt bindString:articleDetail.articleUrl forIndex:15];
    [stmt bindString:@"" forIndex:16];
    [stmt bindString:@"" forIndex:17];
    [stmt bindInt32:0 forIndex:18];
    [stmt bindBool:articleDetail.favorite forIndex:19];
    NSString *strTagsJSON = [articleDetail.tags JSONString];
    [stmt bindString:strTagsJSON forIndex:20];
    //添加日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY年MM月dd日"];
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
    [stmt bindString:strDate forIndex:21];
    [dateFormatter release];
    //
    if ([stmt step] == SQLITE_DONE) {
        
    }
    [stmt release];
}

// 加载本地文章列表
+ (void)loadLocalArticleItems:(NSMutableArray *)marrArticleItem
{
    const char* sql = "SELECT ad_blogid,ad_title,ad_adddate FROM articledetail ORDER BY id DESC";
    DBStatement *stmt = [[DBStatement alloc] initWithSQL:sql];
    //
    while ([stmt step] == SQLITE_ROW) {
        NSString *articleID = [stmt getString:0];
        NSString *title = [stmt getString:1];
        NSString *date = [stmt getString:2];
        //
        NSDictionary *dicItem = @{@"id": articleID, @"title": title,
                                  @"date": date};
        [marrArticleItem addObject:dicItem];
    }
    [stmt release];
}

// 加载文章详情
+ (void)loadArticleDetail:(ArticleDetail *)articleDetail of:(NSString *)articleID
{
    //清空原有数据
    articleDetail.title = @"";
    articleDetail.body = @"";
    articleDetail.publishTime = @"";
    articleDetail.updateTime = @"";
    articleDetail.authorID = @"";
    articleDetail.author = @"";
    
    const char* sql = "SELECT * FROM articledetail WHERE ad_blogid=?";
    DBStatement *stmt = [[DBStatement alloc] initWithSQL:sql];
    [stmt bindString:articleID forIndex:1];
    //
    BOOL exist = NO;
    if ([stmt step] == SQLITE_ROW) {
        articleDetail.articleID = [stmt getString:1];
        articleDetail.title = [stmt getString:2];
        articleDetail.body = [stmt getString:3];
        articleDetail.publishTime = [stmt getString:4];
        articleDetail.updateTime = [stmt getString:5];
        articleDetail.authorID = [stmt getString:6];
        articleDetail.author = [stmt getString:7];
        articleDetail.hits = [stmt getString:8];
        articleDetail.articleUrl = [stmt getString:14];
        articleDetail.favorite = [stmt getBool:18];
        NSString *strTagsJSON = [stmt getString:19];
        articleDetail.tags = [strTagsJSON objectFromJSONString];
        //
        exist = YES;
    }
    [stmt release];
    
    //博文数据不存在则从精选列表加载博文标题
    if (!exist) {
        const char* sql = "SELECT ec_title FROM excellchoice WHERE ec_id=?";
        DBStatement *stmt = [[DBStatement alloc] initWithSQL:sql];
        [stmt bindString:articleID forIndex:1];
        //
        if ([stmt step] == SQLITE_ROW) {
            articleDetail.title = [stmt getString:0];
        }
        [stmt release];
    }
}

// 是否存在指定文章详情
+ (BOOL)existArticleDetailOf:(NSString *)articleID
{
    const char* sql = "SELECT count(id) FROM articledetail WHERE ad_blogid=?";
    DBStatement *stmt = [[DBStatement alloc] initWithSQL:sql];
    [stmt bindString:articleID forIndex:1];
    //
    BOOL exist = NO;
    if ([stmt step] == SQLITE_ROW) {
        exist = [stmt getInt32:0] > 0;
    }
    [stmt release];
    return exist;
}

// 删除指定文章详情
+ (void)deleteArticleDetailOf:(NSString *)articleID
{
    const char* sql = "DELETE FROM articledetail WHERE ad_blogid=?";
    DBStatement *stmt = [[DBStatement alloc] initWithSQL:sql];
    [stmt bindString:articleID forIndex:1];
    //
    if ([stmt step] == SQLITE_DONE) {
    }
    [stmt release];
}

@end
