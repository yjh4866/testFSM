//
//  CoreEngine.h
//  testFSM
//
//  Created by yangjh on 13-8-3.
//  Copyright (c) 2013年 yjh4866. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetController.h"


@interface CoreEngine : NSObject <NetControllerDelegate> {
@private
    //
    NetController *_netController;
}

- (void)applicationWillEnterForeground;

- (void)applicationDidEnterBackground;

- (void)applicationDidBecomeActive;

@end


extern NSString *const NetDownloadPictureFailure;
extern NSString *const NetDownloadPictureSuccess;
extern NSString *const NetDownloadPicFileSize;
extern NSString *const NetDownloadPicReceivedSize;


#ifdef DEBUG

#define CORELOG(fmt,...)     NSLog((@"CORE->%s(%d):"fmt),__PRETTY_FUNCTION__,__LINE__,##__VA_ARGS__)

#else

#define CORELOG(fmt,...)     NSLog(fmt,##__VA_ARGS__)

#endif

