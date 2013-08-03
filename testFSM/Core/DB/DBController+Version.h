//
//  DBController+Version.h
//  testFSM
//
//  Created by yangjh on 13-8-3.
//  Copyright (c) 2013年 yjh4866. All rights reserved.
//

#import "DBController.h"

@interface DBController (Version)

//从数据库中获取数据库版本
+ (NSString*)getDBVersion;

//从数据库中获取数据库版本号放入可变字典中
+ (void)loadDBVersion:(NSMutableDictionary*)dicDBVersion;

//修改数据库版本
+ (void)modifyDBVersionWithString:(NSString *)strDBVersion;

//修改数据库版本
+ (void)modifyDBVersionWithDictionary:(NSDictionary *)dicDBVersion;

@end
