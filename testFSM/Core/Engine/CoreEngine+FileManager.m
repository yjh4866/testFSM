//
//  CoreEngine+FileManager.m
//  testFSM
//
//  Created by yangjh on 13-8-3.
//  Copyright (c) 2013年 yjh4866. All rights reserved.
//

#import "CoreEngine+FileManager.h"
#import "FileManager.h"
#import "FileManager+Picture.h"

@implementation CoreEngine (FileManager)

// 获取指定url的图片
- (UIImage *)pictureWithUrl:(NSString *)url
{
    return [FileManager pictureOfUrl:url];
}

@end
