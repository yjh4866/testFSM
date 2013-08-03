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

#define	SetImageForImageView(_imageView_, _imageName_)	\
            {UIImage *image = [[UIImage alloc] initWithContentsOfFile:PathOfResource(_imageName_, @"png")];\
            _imageView_.image = image;\
            [image release];}
#define	SetStretchableImageForImageView(_imageView_, _imageName_)	\
            {UIImage *image = [[UIImage alloc] initWithContentsOfFile:PathOfResource(_imageName_, @"png")];\
            if ([UIDevice systemVersionID] < __IPHONE_5_0) {\
                _imageView_.image = [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];\
            } else {\
                _imageView_.image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height/3, image.size.width/3, image.size.height*2/3, image.size.width*2/3)];\
            }\
            [image release];}
#define	SetStretchableImageForImageViewWithCap(_imageView_, _imageName_, _leftCapWidth_, _topCapHeight_)	\
            {UIImage *image = [[UIImage alloc] initWithContentsOfFile:PathOfResource(_imageName_, @"png")];\
            if ([UIDevice systemVersionID] < __IPHONE_5_0) {\
                _imageView_.image = [image stretchableImageWithLeftCapWidth:_leftCapWidth_ topCapHeight:_topCapHeight_];\
            } else {\
                _imageView_.image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(_topCapHeight_, _leftCapWidth_, image.size.height-_topCapHeight_, image.size.width-_leftCapWidth_)];\
            }\
            [image release];}
#define	SetImageForButton(_button_, _imageName_, _buttonState_)		\
            {UIImage *image = [[UIImage alloc] initWithContentsOfFile:PathOfResource(_imageName_, @"png")];\
            [_button_ setImage:image forState:_buttonState_];\
            [image release];}
#define	SetImageForButtonBack(_button_, _imageName_, _buttonState_)		\
            {UIImage *image = [[UIImage alloc] initWithContentsOfFile:PathOfResource(_imageName_, @"png")];\
            [_button_ setBackgroundImage:image forState:_buttonState_];\
            [image release];}
#define	SetStretchableImageForButtonBack(_button_, _imageName_, _buttonState_)	\
            {UIImage *image = [[UIImage alloc] initWithContentsOfFile:PathOfResource(_imageName_, @"png")];\
            UIImage *imageStretch = nil;\
            if ([UIDevice systemVersionID] < __IPHONE_5_0) {\
                imageStretch = [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];\
            } else {\
                imageStretch = [image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height/3, image.size.width/3, image.size.height*2/3, image.size.width*2/3)];\
            }\
            [_button_ setBackgroundImage:imageStretch forState:_buttonState_];\
            [image release];}
#define	SetStretchableImageForButtonBackWithCap(_imageView_, _imageName_, _buttonState_, _leftCapWidth_, _topCapHeight_)	\
            {UIImage *image = [[UIImage alloc] initWithContentsOfFile:PathOfResource(_imageName_, @"png")];\
            UIImage *imageStretch = nil;\
            if ([UIDevice systemVersionID] < __IPHONE_5_0) {\
                imageStretch = [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];\
            } else {\
                imageStretch = [image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height/3, image.size.width/3, image.size.height*2/3, image.size.width*2/3)];\
            }\
            [_button_ setBackgroundImage:imageStretch forState:_buttonState_];\
            [image release];}



#ifdef DEBUG
#define UILog(fmt,...)   NSLog((@"UI->%s(%d):" fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define UILog(fmt,...)   
#endif


