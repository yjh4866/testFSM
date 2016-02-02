//
//  UIMacro.h
//  
//
//  Created by yangjianhong-MAC on 11-9-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import "UIDevice+Custom.h"

#define IsIphone5()  (568.0f==[UIScreen mainScreen].bounds.size.height)
#define IsPad()      (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
#define PathOfResource(name, type)  [[NSBundle mainBundle] pathForResource:name ofType:type]
#define CurrentVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

#define ScoreUrl(appleID) [NSString stringWithFormat:\
                @"itms-apps://ax.itunes.apple.com/"\
                "WebObjects/MZStore.woa/wa/viewContentsUserReviews?"\
                "type=Purple+Software&id=%i", appleID]



#ifdef DEBUG
#define UILog(fmt,...)   NSLog((@"UI->%s(%d):" fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define UILog(fmt,...)   
#endif


