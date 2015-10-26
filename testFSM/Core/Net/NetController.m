//
//  NetController.m
//  testFSM
//
//  Created by yangjh on 13-8-3.
//  Copyright (c) 2013年 yjh4866. All rights reserved.
//

#import "NetController.h"
#import "HTTPConnection.h"
#import "HTTPFile.h"


#ifdef DEBUG
#define HOST_Interface     @"http://dp.sina.cn/interface/"
#else
#define HOST_Interface     @"http://dp.sina.cn/interface/"
#endif


#define ArticleUrl        HOST_Interface @"article_read.php?articleid=%@"


typedef NS_ENUM(unsigned int, NetRequestType) {
    NetRequestType_None,
};
typedef NS_ENUM(unsigned int, DownloadFileType) {
    DownloadFileType_None,
    DownloadFileType_Avatar,
    DownloadFileType_Picture,
};

@interface NetController () <HTTPConnectionDelegate, HTTPFileDelegate> {
    
    HTTPConnection *_httpConnection;
    HTTPFile *_fileConnection;
}

@end


@implementation NetController

- (id)init
{
    self = [super init];
    if (self) {
        //
        _httpConnection = [[HTTPConnection alloc] init];
        _httpConnection.delegate = self;
        _fileConnection = [[HTTPFile alloc] init];
        _fileConnection.delegate = self;
    }
    return self;
}

- (void)dealloc
{
    _httpConnection.delegate = nil;
    [_httpConnection release];
    _fileConnection.delegate = nil;
    [_fileConnection release];
    
    [super dealloc];
}


#pragma mark - Public

/**
 *	@brief	下载图片
 *
 *	@param 	picPath 	图片保存路径
 *	@param 	picUrl 	图片url
 */
- (void)downloadPicture:(NSString *)picPath withUrl:(NSString *)picUrl
{
    NSDictionary *dicParam = @{@"type": [NSNumber numberWithInt:DownloadFileType_Picture]};
    [_fileConnection downloadFile:picPath from:picUrl withParam:dicParam];
}


#pragma mark - HTTPConnectionDelegate

// 网络数据下载失败
- (void)httpConnect:(HTTPConnection *)httpConnect error:(NSError *)error with:(NSDictionary *)dicParam
{
    //网络请求类型
    NetRequestType requestType = [dicParam[@"type"] intValue];
    //
    switch (requestType) {
        default:
            break;
    }
}

// 服务器返回的HTTP信息头
- (void)httpConnect:(HTTPConnection *)httpConnect receiveResponseWithStatusCode:(NSInteger)statusCode
 andAllHeaderFields:(NSDictionary *)dicAllHeaderFields with:(NSDictionary *)dicParam
{
    //网络请求类型
    NetRequestType requestType = [dicParam[@"type"] intValue];
    //
    switch (requestType) {
        default:
            break;
    }
}

// 接收到部分数据
- (void)httpConnect:(HTTPConnection *)httpConnect receivePartData:(NSData *)partData with:(NSDictionary *)dicParam
{
    //网络请求类型
    NetRequestType requestType = [dicParam[@"type"] intValue];
    //
    switch (requestType) {
        default:
            break;
    }
}

// 网络数据下载完成
- (void)httpConnect:(HTTPConnection *)httpConnect finish:(NSData *)data with:(NSDictionary *)dicParam
{
    //网络请求类型
    NetRequestType requestType = [dicParam[@"type"] intValue];
    //
    switch (requestType) {
        default:
            break;
    }
}


#pragma mark - HTTPFileDelegate

// 下载失败
- (void)httpFile:(HTTPFile *)httpFile downloadFailure:(NSError *)error
            from:(NSString *)url withPath:(NSString *)filePath
        andParam:(NSDictionary *)param
{
    DownloadFileType type = [param[@"type"] intValue];
    if (DownloadFileType_Avatar == type) {
    }
    else if (DownloadFileType_Picture == type) {
        if ([self.delegate respondsToSelector:@selector(netController:downloadPictureError:withUrl:)]) {
            [self.delegate netController:self
                    downloadPictureError:error withUrl:url];
        }
    }
}

// 得到文件实际大小
- (void)httpFile:(HTTPFile *)httpFile fileSize:(unsigned long)fileSize
            from:(NSString *)url withPath:(NSString *)filePath
        andParam:(NSDictionary *)param
{
    DownloadFileType type = [param[@"type"] intValue];
    if (DownloadFileType_Picture == type) {
        if ([self.delegate respondsToSelector:@selector(netController:fileSize:withUrl:)]) {
            [self.delegate netController:self fileSize:fileSize withUrl:url];
        }
    }
}

// 收到的数据发生变化
- (void)httpFile:(HTTPFile *)httpFile progressChanged:(float)progress
            from:(NSString *)url withPath:(NSString *)filePath
        andParam:(NSDictionary *)param
{
    DownloadFileType type = [param[@"type"] intValue];
    if (DownloadFileType_Picture == type) {
        if ([self.delegate respondsToSelector:@selector(netController:receivedSize:withUrl:)]) {
            [self.delegate netController:self progressChanged:progress
                                 withUrl:url];
        }
    }
}

// 下载完成
- (void)httpFile:(HTTPFile *)httpFile downloadSuccess:(BOOL)success
            from:(NSString *)url withPath:(NSString *)filePath
        andParam:(NSDictionary *)param
{
    DownloadFileType type = [param[@"type"] intValue];
    if (DownloadFileType_Avatar == type) {
    }
    else if (DownloadFileType_Picture == type) {
        if ([self.delegate respondsToSelector:@selector(netController:downloadPictureWithUrl:)]) {
            [self.delegate netController:self downloadPictureWithUrl:url];
        }
    }
}


#pragma mark - ()

@end
