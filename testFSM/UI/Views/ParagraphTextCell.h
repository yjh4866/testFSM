//
//  ParagraphTextCell.h
//  testFSM
//
//  Created by CocoaChina_yangjh on 16/2/1.
//  Copyright © 2016年 yjh4866. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleParagraph.h"

@interface ParagraphTextCell : UITableViewCell

@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, strong) ParagraphElement *paragraphElement;

+ (CGFloat)cellHeightWith:(ParagraphElement *)paragraphElement fontSize:(CGFloat)fontSize
             andCellWidth:(CGFloat)cellWidth;

@end
