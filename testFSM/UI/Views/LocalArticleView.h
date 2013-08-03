//
//  LocalArticleView.h
//  testFSM
//
//  Created by yangjh on 13-7-17.
//  Copyright (c) 2013年 yjh4866. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LocalArticleViewDataSource;
@protocol LocalArticleViewDelegate;

@interface LocalArticleView : UIView

@property (nonatomic, assign) id <LocalArticleViewDataSource> dataSource;
@property (nonatomic, assign) id <LocalArticleViewDelegate> delegate;

// 显示本地文章列表
- (void)showLocalArticleList;

@end


@protocol LocalArticleViewDataSource <NSObject>

// 加载本地文章列表
- (void)localArticleView:(LocalArticleView *)localArticleView
    loadLocalArticleList:(NSMutableArray *)marrArticleItem;

@end


@protocol LocalArticleViewDelegate <NSObject>

// 查看文章详情
- (void)localArticleView:(LocalArticleView *)localArticleView
           showArticleOf:(NSString *)articleID;

// 删除本地文章
- (void)localArticleView:(LocalArticleView *)localArticleView
         removeArticleOf:(NSString *)articleID;

@end
