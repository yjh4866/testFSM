//
//  CoreEngine.m
//  testFSM
//
//  Created by yangjh on 13-8-3.
//  Copyright (c) 2013年 yjh4866. All rights reserved.
//

#import "CoreEngine.h"
#import "DBConnection.h"
#import "DBController+Update.h"
#import "CoreEngine+Update.h"
#import "AppSetting+Server.h"

@implementation CoreEngine

- (id)init
{
    self = [super init];
    if (self) {
        //复制数据库文件
        [DBConnection createCopyOfDatabaseIfNeeded];
        //数据库升级
        [DBController update];
        //本地数据升级
        [self update];
        
        //网络
        _netController = [[NetController alloc] init];
        _netController.delegate = self;
    }
    return self;
}

- (void)dealloc
{
    //
    [_netController release];
    
    [super dealloc];
}


#pragma mark - Public

- (void)applicationWillEnterForeground
{
    //版本更新记录上传
    NSString *oldVersion = [AppSetting oldVersion];
    NSString *newVersion = [AppSetting newVersion];
    if (oldVersion.length > 0 && newVersion.length > 0) {
    }
}

- (void)applicationDidEnterBackground
{
}

- (void)applicationDidBecomeActive
{
    
}

@end


#pragma mark - Notification

