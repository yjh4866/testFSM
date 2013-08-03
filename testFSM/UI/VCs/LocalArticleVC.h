//
//  LocalArticleVC.h
//  testFSM
//
//  Created by yangjh on 13-6-19.
//  Copyright (c) 2013年 yjh4866. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LocalArticleVCDataSource;
@protocol LocalArticleVCDelegate;

@interface LocalArticleVC : UIViewController

@property (nonatomic, assign) id <LocalArticleVCDataSource> dataSource;
@property (nonatomic, assign) id <LocalArticleVCDelegate> delegate;

@end


@protocol LocalArticleVCDataSource <NSObject>

@optional

// 加载本地文章
- (void)localArticleVC:(LocalArticleVC *)localArticleVC
 loadLocalArticleItems:(NSMutableArray *)marrArticleItem;

@end


@protocol LocalArticleVCDelegate <NSObject>

@optional

// 查看文章详情
- (void)localArticleVC:(LocalArticleVC *)localArticleVC
         showArticleOf:(NSString *)articleID;

// 删除本地文章
- (void)localArticleVC:(LocalArticleVC *)localArticleVC
       removeArticleOf:(NSString *)articleID;

@end
