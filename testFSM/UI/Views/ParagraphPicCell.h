//
//  ParagraphPicCell.h
//  testFSM
//
//  Created by CocoaChina_yangjh on 16/2/1.
//  Copyright © 2016年 yjh4866. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleParagraph.h"

@protocol ParagraphPicCellDelegate;

@interface ParagraphPicCell : UITableViewCell

@property (nonatomic, strong) ParagraphElement *paragraphElement;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, weak) id <ParagraphPicCellDelegate> delegate;

+ (CGFloat)cellHeightWith:(ParagraphElement *)paragraphElement andCellWidth:(CGFloat)cellWidth;

@end


@protocol ParagraphPicCellDelegate <NSObject>

// 图片下载成功，高度会发生变更
- (void)paragraphPicCellDownloadPictureSuccess:(ParagraphPicCell *)cell;

@end
