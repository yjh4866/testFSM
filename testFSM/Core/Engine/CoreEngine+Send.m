//
//  CoreEngine+Send.m
//  testFSM
//
//  Created by yangjh on 13-8-3.
//  Copyright (c) 2013年 yjh4866. All rights reserved.
//

#import "CoreEngine+Send.h"
#import "Reachability.h"
#import "FileManager+Picture.h"

@implementation CoreEngine (Send)

// 下载指定url的图片
- (void)forceDownloadPicture:(BOOL)force withUrl:(NSString *)picUrl
{
    NetworkStatus netState = [[Reachability reachabilityForLocalWiFi] currentReachabilityStatus];
    //不是WiFi网络，且非强制，则不处理
    if ((ReachableViaWiFi != netState) && !force) {
        return;
    }
    NSString *filePath = [FileManager picturePathOfUrl:picUrl];
    [_netController downloadPicture:filePath withUrl:picUrl];
}

@end
