//
//  ArticleParagraph.h
//  testFSM
//
//  Created by yangjh on 13-6-25.
//  Copyright (c) 2013年 yjh4866. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(unsigned int, ParagraphElementType) {
    ParagraphElementType_None,
    ParagraphElementType_Picture,
    ParagraphElementType_Text,
    ParagraphElementType_Tag_startp,
    ParagraphElementType_Tag_endp,
    ParagraphElementType_Tag_br,
    ParagraphElementType_Error,
};

@interface ParagraphElement : NSObject

@property (nonatomic, assign) ParagraphElementType eleType;
@property (nonatomic, retain) NSString *sourceText;

@end

@interface ArticleParagraph : NSObject

+ (NSArray *)parseParagraphFromArticle:(NSString *)article;

@end
