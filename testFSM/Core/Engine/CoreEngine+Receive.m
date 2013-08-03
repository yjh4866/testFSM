//
//  CoreEngine+Receive.m
//  testFSM
//
//  Created by yangjh on 13-8-3.
//  Copyright (c) 2013年 yjh4866. All rights reserved.
//

#import "CoreEngine+Receive.h"
#import "JSONKit.h"

@implementation CoreEngine (Receive)

// 下载图片时的网络错误
- (void)netController:(NetController *)netController downloadPictureError:(NSError *)error withUrl:(NSString *)picUrl
{
    NSDictionary *dicUserInfo = @{@"url": picUrl, @"error": error};
    [[NSNotificationCenter defaultCenter] postNotificationName:NetDownloadPictureFailure object:nil userInfo:dicUserInfo];
}

// 得到文件实际大小
- (void)netController:(NetController *)netController fileSize:(NSUInteger)fileSize withUrl:(NSString *)picUrl
{
    NSDictionary *dicUserInfo = @{@"url": picUrl, @"filesize": [NSNumber numberWithInt:fileSize]};
    [[NSNotificationCenter defaultCenter] postNotificationName:NetDownloadPicFileSize object:nil userInfo:dicUserInfo];
}

// 收到的数据发生变化
- (void)netController:(NetController *)netController receivedSize:(NSUInteger)receivedSize withUrl:(NSString *)picUrl
{
    NSDictionary *dicUserInfo = @{@"url": picUrl, @"receivedsize": [NSNumber numberWithInt:receivedSize]};
    [[NSNotificationCenter defaultCenter] postNotificationName:NetDownloadPicReceivedSize object:nil userInfo:dicUserInfo];
}

// 下载图片返回数据
- (void)netController:(NetController *)netController downloadPictureWithUrl:(NSString *)picUrl
{
    NSDictionary *dicUserInfo = @{@"url": picUrl};
    [[NSNotificationCenter defaultCenter] postNotificationName:NetDownloadPictureSuccess object:nil userInfo:dicUserInfo];
}

@end
