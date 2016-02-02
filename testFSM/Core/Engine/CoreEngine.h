//
//  CoreEngine.h
//  testFSM
//
//  Created by yangjh on 13-8-3.
//  Copyright (c) 2013年 yjh4866. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetController.h"


@interface CoreEngine : NSObject <NetControllerDelegate>

- (void)applicationWillEnterForeground;

- (void)applicationDidEnterBackground;

- (void)applicationDidBecomeActive;

@end


#ifdef DEBUG

#define CORELOG(fmt,...)     NSLog((@"CORE->%s(%d):"fmt),__PRETTY_FUNCTION__,__LINE__,##__VA_ARGS__)

#else

#define CORELOG(fmt,...)     NSLog(fmt,##__VA_ARGS__)

#endif

