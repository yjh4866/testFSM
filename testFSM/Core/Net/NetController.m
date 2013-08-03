//
//  NetController.m
//  testFSM
//
//  Created by yangjh on 13-8-3.
//  Copyright (c) 2013年 yjh4866. All rights reserved.
//

#import "NetController.h"
#import "HTTPConnection.h"
#import "DLConnection.h"
#import "JSONKit.h"


#define LOCALNET
#undef LOCALNET

#ifdef LOCALNET
#define HOST_Interface     @"http://192.168.1.110/interface/"
#else
#define HOST_Interface     @"http://dp.sina.cn/interface/"
#endif


#define ArticleUrl        HOST_Interface @"article_read.php?articleid=%@"


typedef NS_ENUM(NSUInteger, NetRequestType) {
    NetRequestType_None,
};
typedef NS_ENUM(NSInteger, DownloadFileType) {
    DownloadFileType_None,
    DownloadFileType_Avatar,
    DownloadFileType_Picture,
};

@interface NetController () <HTTPConnectionDelegate, DLConnectionDelegate> {
    
    HTTPConnection *_httpConnection;
    DLConnection *_downloadConnection;
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
        _downloadConnection = [[DLConnection alloc] init];
        _downloadConnection.delegate = self;
    }
    return self;
}

- (void)dealloc
{
    [_httpConnection release];
    [_downloadConnection release];
    
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
    [_downloadConnection downloadFile:picPath from:picUrl withParam:dicParam];
}


#pragma mark - HTTPConnectionDelegate

// 网络数据下载失败
- (void)httpConnect:(HTTPConnection *)httpConnect error:(NSError *)error with:(NSDictionary *)dicParam
{
    //网络请求类型
    NetRequestType requestType = [[dicParam objectForKey:@"type"] intValue];
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
    NetRequestType requestType = [[dicParam objectForKey:@"type"] intValue];
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
    NetRequestType requestType = [[dicParam objectForKey:@"type"] intValue];
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
    NetRequestType requestType = [[dicParam objectForKey:@"type"] intValue];
    //
    switch (requestType) {
        default:
            break;
    }
}


#pragma mark - DLConnectionDelegate

// 下载失败
- (void)dlConnection:(DLConnection *)dlConnection downloadFailure:(NSError *)error
            withPath:(NSString *)filePath url:(NSString *)url
            andParam:(NSDictionary *)dicParam
{
    DownloadFileType type = [[dicParam objectForKey:@"type"] intValue];
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
- (void)dlConnection:(DLConnection *)dlConnection fileSize:(NSUInteger)fileSize
            withPath:(NSString *)filePath url:(NSString *)url
            andParam:(NSDictionary *)dicParam
{
    DownloadFileType type = [[dicParam objectForKey:@"type"] intValue];
    if (DownloadFileType_Picture == type) {
        if ([self.delegate respondsToSelector:@selector(netController:fileSize:withUrl:)]) {
            [self.delegate netController:self fileSize:fileSize withUrl:url];
        }
    }
}

// 收到的数据发生变化
- (void)dlConnection:(DLConnection *)dlConnection receivedSize:(NSUInteger)receivedSize
            withPath:(NSString *)filePath url:(NSString *)url
            andParam:(NSDictionary *)dicParam
{
    DownloadFileType type = [[dicParam objectForKey:@"type"] intValue];
    if (DownloadFileType_Picture == type) {
        if ([self.delegate respondsToSelector:@selector(netController:receivedSize:withUrl:)]) {
            [self.delegate netController:self receivedSize:receivedSize
                                 withUrl:url];
        }
    }
}

// 下载完成
- (void)dlConnection:(DLConnection *)dlConnection finishedWithPath:(NSString *)filePath
                 url:(NSString *)url andParam:(NSDictionary *)dicParam
{
    DownloadFileType type = [[dicParam objectForKey:@"type"] intValue];
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
