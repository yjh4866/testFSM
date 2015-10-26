//
//  ArticlePicView.h
//  testFSM
//
//  Created by yangjh on 13-6-13.
//  Copyright (c) 2013年 yjh4866. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ArticlePicViewDelegate;

@interface ArticlePicView : UIView

@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) UIImage *picture;
@property (nonatomic, assign) id <ArticlePicViewDelegate> delegate;

// 设置指定url的图片大小
- (void)setPictureSize:(NSUInteger)picSize;

// 设置下载指定url的图片的进度
- (void)setProgressOfDownloadPicture:(CGFloat)progress;

@end


@protocol ArticlePicViewDelegate <NSObject>

// 点击到图片
- (void)articlePicViewClickPic:(ArticlePicView *)articlePicView;

@end
