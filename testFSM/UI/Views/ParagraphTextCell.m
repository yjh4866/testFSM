//
//  ParagraphTextCell.m
//  testFSM
//
//  Created by CocoaChina_yangjh on 16/2/1.
//  Copyright © 2016年 yjh4866. All rights reserved.
//

#import "ParagraphTextCell.h"

@interface ParagraphTextCell ()
@property (nonatomic, strong) UILabel *labelText;
@end

@implementation ParagraphTextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.labelText = [[UILabel alloc] initWithFrame:CGRectZero];
        self.labelText.backgroundColor = [UIColor clearColor];
        self.labelText.numberOfLines = 0;
        [self addSubview:self.labelText];
        // KVO
        [self addObserver:self forKeyPath:@"fontSize" options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:@"paragraphElement" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.labelText.frame = CGRectMake(10, 5, self.bounds.size.width-20, self.bounds.size.height-10);
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"fontSize"];
    [self removeObserver:self forKeyPath:@"paragraphElement"];
}

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSString*, id> *)change context:(nullable void *)context
{
    if ([keyPath isEqualToString:@"fontSize"]) {
        self.labelText.font = [UIFont systemFontOfSize:self.fontSize];
    }
    else if ([keyPath isEqualToString:@"paragraphElement"]) {
        self.labelText.text = self.paragraphElement.sourceText;
    }
}

+ (CGFloat)cellHeightWith:(ParagraphElement *)paragraphElement fontSize:(CGFloat)fontSize
             andCellWidth:(CGFloat)cellWidth
{
    CGFloat heightText = [paragraphElement.sourceText boundingRectWithSize:CGSizeMake(cellWidth-20, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]} context:nil].size.height;
    return 5+heightText+5;
}

@end
