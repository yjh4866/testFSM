//
//  NetController.h
//  testFSM
//
//  Created by yangjh on 13-8-3.
//  Copyright (c) 2013年 yjh4866. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NetControllerDelegate;

@interface NetController : NSObject

@property (nonatomic, assign) id <NetControllerDelegate> delegate;

/**
 *	@brief	下载图片
 *
 *	@param 	picPath 	图片保存路径
 *	@param 	picUrl 	图片url
 */
- (void)downloadPicture:(NSString *)picPath withUrl:(NSString *)picUrl;

@end



@protocol NetControllerDelegate <NSObject>

@optional

// 下载图片时的网络错误
- (void)netController:(NetController *)netController downloadPictureError:(NSError *)error withUrl:(NSString *)picUrl;

// 得到文件实际大小
- (void)netController:(NetController *)netController fileSize:(NSUInteger)fileSize withUrl:(NSString *)picUrl;

// 收到的数据发生变化
- (void)netController:(NetController *)netController receivedSize:(NSUInteger)receivedSize withUrl:(NSString *)picUrl;

// 下载图片返回数据
- (void)netController:(NetController *)netController downloadPictureWithUrl:(NSString *)picUrl;

@end


#ifdef DEBUG

#define NETLOG(fmt,...)     NSLog((@"NET->%s(%d):"fmt),__PRETTY_FUNCTION__,__LINE__,##__VA_ARGS__)

#else

#define NETLOG(fmt,...)     NSLog(fmt,##__VA_ARGS__)

#endif
