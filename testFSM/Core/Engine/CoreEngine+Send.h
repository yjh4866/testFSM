//
//  CoreEngine+Send.h
//  testFSM
//
//  Created by yangjh on 13-8-3.
//  Copyright (c) 2013年 yjh4866. All rights reserved.
//

#import "CoreEngine.h"

@interface CoreEngine (Send)

// 下载指定url的图片
- (void)forceDownloadPicture:(BOOL)force withUrl:(NSString *)picUrl;

@end
