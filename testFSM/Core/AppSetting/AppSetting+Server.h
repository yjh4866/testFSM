//
//  AppSetting+Server.h
//  testFSM
//
//  Created by yangjh on 13-8-3.
//  Copyright (c) 2013年 yjh4866. All rights reserved.
//

#import "AppSetting.h"

@interface AppSetting (Server)

//原版本
+ (void)oldVersion:(NSString *)oldVersion;
+ (NSString *)oldVersion;

//新版本
+ (void)newVersion:(NSString *)newVersion;
+ (NSString *)newVersion;

@end
