//
//  ScrollLabelView.m
//
//
//  Created by yjh4866 on 13-1-29.
//  Copyright (c) 2013年 yjh4866. All rights reserved.
//

#import "ScrollLabelView.h"
#import <QuartzCore/QuartzCore.h>

@interface ScrollLabelView () {
    
    CGFloat _widthText;
    NSUInteger _scrollState;
}
@property (nonatomic, strong) UILabel *labelText;
@end

@implementation ScrollLabelView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.clipsToBounds = YES;
        //
        self.labelText = [[UILabel alloc] initWithFrame:self.bounds];
        self.labelText.backgroundColor = [UIColor clearColor];
        self.labelText.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        [self addSubview:self.labelText];
        //
        [self addObserver:self forKeyPath:@"self.labelText.text"
                  options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"self.labelText.text"];
    // 删除动画
    [self.labelText.layer removeAllAnimations];
}


#pragma mark - NSKeyValueObserving

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"self.labelText.text"]) {
        _widthText = [self.labelText.text sizeWithFont:self.labelText.font].width;
        CGRect frameLabel = self.bounds;
        frameLabel.size.width = _widthText;
        self.labelText.frame = frameLabel;
        //
        _scrollState = 0;
        if (_widthText > self.bounds.size.width) {
            [self animationDidStop:nil finished:YES];
        }
    }
}


#pragma mark - NSObject (CAAnimationDelegate)

- (void)animationDidStart:(CAAnimation *)anim
{
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    //删除原有动画
    [self.labelText.layer removeAllAnimations];
    if (NO == flag) {
        return;
    }
    //
    NSNumber *NSPos0 = [NSNumber numberWithFloat:0.0f];
    NSNumber *NSPos1 = [NSNumber numberWithFloat:self.bounds.size.width-_widthText];
    CGFloat during = ([NSPos0 intValue]-[NSPos1 intValue])/100.0f;
    switch (_scrollState) {
        case 0:
        {
            CABasicAnimation *animationSleepAtHead = [self moveFrom:NSPos0 to:NSPos0 during:2.0f];
            animationSleepAtHead.delegate = self;
            [self.labelText.layer addAnimation:animationSleepAtHead forKey:@"sleepAtHead"];
            _scrollState = 1;
        }
            break;
        case 1:
        {
            CABasicAnimation *animationScrollToTail = [self moveFrom:NSPos0 to:NSPos1 during:during];
            animationScrollToTail.delegate = self;
            [self.labelText.layer addAnimation:animationScrollToTail forKey:@"scrollToTail"];
            _scrollState = 2;
        }
            break;
        case 2:
        {
            CABasicAnimation *animationSleepAtTail = [self moveFrom:NSPos1 to:NSPos1 during:2.0f];
            animationSleepAtTail.delegate = self;
            [self.labelText.layer addAnimation:animationSleepAtTail forKey:@"sleepAtTail"];
            _scrollState = 3;
        }
            break;
        case 3:
        {
            CABasicAnimation *animationScrollToHead = [self moveFrom:NSPos1 to:NSPos0 during:during];
            animationScrollToHead.delegate = self;
            [self.labelText.layer addAnimation:animationScrollToHead forKey:@"scrollToHead"];
            _scrollState = 0;
        }
            break;
        default:
            break;
    }
}


#pragma mark - Private

- (CABasicAnimation *)moveFrom:(NSNumber *)from to:(NSNumber *)to during:(float)time //横向移动
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    animation.fromValue = from;
    animation.toValue = to;
    animation.duration = time;
    animation.removedOnCompletion = NO;
    animation.fillMode=kCAFillModeForwards;
    return animation;
}

@end
