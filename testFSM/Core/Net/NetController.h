//
//  NetController.h
//  testFSM
//
//  Created by yangjh on 13-8-3.
//  Copyright (c) 2013年 yjh4866. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NetControllerDelegate;

@interface NetController : NSObject

+ (NetController *)sharedInstance;

@end



@protocol NetControllerDelegate <NSObject>

@optional

@end


#ifdef DEBUG

#define NETLOG(fmt,...)     NSLog((@"NET->%s(%d):"fmt),__PRETTY_FUNCTION__,__LINE__,##__VA_ARGS__)

#else

#define NETLOG(fmt,...)     NSLog(fmt,##__VA_ARGS__)

#endif
