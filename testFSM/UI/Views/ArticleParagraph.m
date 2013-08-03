//
//  ArticleParagraph.m
//  testFSM
//
//  Created by yangjh on 13-6-25.
//  Copyright (c) 2013年 yjh4866. All rights reserved.
//

#import "ArticleParagraph.h"

@implementation ParagraphElement

- (NSString *)description
{
    NSMutableString *mstrDescrip = [NSMutableString string];
    [mstrDescrip appendFormat:@"{\n\ttype:%i\n", self.eleType];
    [mstrDescrip appendFormat:@"\ttext:%@\n}", self.sourceText];
    return mstrDescrip;
}

- (void)dealloc
{
    [_sourceText release];
    
    [super dealloc];
}

@end

@implementation ArticleParagraph

// 解析器分析见《parser.doc》
+ (NSArray *)parseParagraphFromArticle:(NSString *)article
{
    //
    NSMutableArray *marrParagraph = [NSMutableArray array];
    NSMutableArray *marrCurParagraph = [[NSMutableArray alloc] init];
    //
    NSRange rangeEle = NSMakeRange(0, 0);
    NSUInteger status = 0;
    for (int i = 0; i < article.length; i++) {
        unichar ch = [article characterAtIndex:i];
        rangeEle.length++;
        switch (ch) {
            case '<':
            {
                if (0 == status || 1 == status) {
                    status = 2;
                    //...<
                    if (rangeEle.length > 1) {
                        rangeEle.length -= 1;
                        //
                        ParagraphElement *pEle = [[ParagraphElement alloc] init];
                        pEle.sourceText = [article substringWithRange:rangeEle];
                        pEle.eleType = ParagraphElementType_Text;
                        [marrCurParagraph addObject:pEle];
                        [pEle release];
                        //
                        rangeEle.location += rangeEle.length;
                        rangeEle.length = 1;
                    }
                }
                else if (13 == status || 26 == status) {
                    status = 14;
                    //<p x>...<
                    if (rangeEle.length > 1) {
                        rangeEle.length -= 1;
                        //
                        ParagraphElement *pEle = [[ParagraphElement alloc] init];
                        pEle.sourceText = [article substringWithRange:rangeEle];
                        pEle.eleType = ParagraphElementType_Text;
                        [marrCurParagraph addObject:pEle];
                        [pEle release];
                        //
                        rangeEle.location += rangeEle.length;
                        rangeEle.length = 1;
                    }
                }
                else {
                    ParagraphElement *pEle = [[ParagraphElement alloc] init];
                    pEle.eleType = ParagraphElementType_Error;
                    [marrCurParagraph addObject:pEle];
                    [pEle release];
                }
            }
                break;
            case '>':
            {
                if (status >= 10 && status <= 12) {
                    status = 13;
                    //<p x>
                    ParagraphElement *pEle = [[ParagraphElement alloc] init];
                    pEle.sourceText = [article substringWithRange:rangeEle];
                    pEle.eleType = ParagraphElementType_Tag_startp;
                    [marrCurParagraph addObject:pEle];
                    [pEle release];
                    //
                    rangeEle.location += rangeEle.length;
                    rangeEle.length = 0;
                }
                else if (16 == status) {
                    status = 1;
                    //</p>
                    ParagraphElement *pEle = [[ParagraphElement alloc] init];
                    pEle.sourceText = [article substringWithRange:rangeEle];
                    pEle.eleType = ParagraphElementType_Tag_endp;
                    [marrCurParagraph addObject:pEle];
                    [pEle release];
                    //保存当前段
                    [marrParagraph addObject:marrCurParagraph];
                    [marrCurParagraph release];
                    //开始新段
                    marrCurParagraph = [[NSMutableArray alloc] init];
                }
                else if (25 == status) {
                    status = 26;
                    //<p x>x<img .../>
                    ParagraphElement *pEle = [[ParagraphElement alloc] init];
                    pEle.sourceText = [article substringWithRange:rangeEle];
                    pEle.eleType = ParagraphElementType_Picture;
                    [marrCurParagraph addObject:pEle];
                    [pEle release];
                    //
                    rangeEle.location += rangeEle.length;
                    rangeEle.length = 0;
                }
                else if (105 == status) {
                    status = 1;
                    //<img .../>
                    ParagraphElement *pEle = [[ParagraphElement alloc] init];
                    pEle.sourceText = [article substringWithRange:rangeEle];
                    pEle.eleType = ParagraphElementType_Picture;
                    [marrCurParagraph addObject:pEle];
                    [pEle release];
                    //
                    rangeEle.location += rangeEle.length;
                    rangeEle.length = 0;
                }
                else if (201 == status || 202 == status) {
                    status = 1;
                    //<br/>
                    ParagraphElement *pEle = [[ParagraphElement alloc] init];
                    pEle.sourceText = [article substringWithRange:rangeEle];
                    pEle.eleType = ParagraphElementType_Tag_br;
                    [marrCurParagraph addObject:pEle];
                    [pEle release];
                    //
                    rangeEle.location += rangeEle.length;
                    rangeEle.length = 0;
                    //保存当前段
                    [marrParagraph addObject:marrCurParagraph];
                    [marrCurParagraph release];
                    //开始新段
                    marrCurParagraph = [[NSMutableArray alloc] init];
                }
                else {
                    ParagraphElement *pEle = [[ParagraphElement alloc] init];
                    pEle.eleType = ParagraphElementType_Error;
                    [marrCurParagraph addObject:pEle];
                    [pEle release];
                }
            }
                break;
            case '/':
            {
                if (0 == status || 1 == status) {
                    status = 1;
                }
                else if (14 == status) {
                    status = 15;
                }
                else if (24 == status) {
                    status = 25;
                }
                else if (104 == status) {
                    status = 105;
                }
                else if (105 == status) {
                    status = 104;
                }
                else if (201 == status) {
                    status = 202;
                }
                else {
                    ParagraphElement *pEle = [[ParagraphElement alloc] init];
                    pEle.eleType = ParagraphElementType_Error;
                    [marrCurParagraph addObject:pEle];
                    [pEle release];
                }
            }
                break;
            case ' ':
            {
                if (0 == status || 1 == status) {
                    status = 1;
                }
                else if (10 == status || 11 == status) {
                    status = 11;
                }
                else if (12 == status) {
                    status = 12;
                }
                else if (13 == status) {
                    status = 13;
                }
                else if (22 == status || 23 == status) {
                    status = 23;
                }
                else if (24 == status) {
                    status = 24;
                }
                else if (26 == status) {
                    status = 26;
                }
                else if (102 == status || 103 == status) {
                    status = 103;
                }
                else if (104 == status || 105 == status) {
                    status = 104;
                }
                else if (201 == status) {
                    status = 201;
                }
                else {
                    ParagraphElement *pEle = [[ParagraphElement alloc] init];
                    pEle.eleType = ParagraphElementType_Error;
                    [marrCurParagraph addObject:pEle];
                    [pEle release];
                }
            }
                break;
            case 'p':
            {
                if (0 == status || 1 == status) {
                    status = 1;
                }
                else if (2 == status) {
                    status = 10;
                }
                else if (11 == status || 12 == status) {
                    status = 12;
                }
                else if (13 == status) {
                    status = 13;
                }
                else if (15 == status) {
                    status = 16;
                }
                else if (23 == status || 24 == status) {
                    status = 24;
                }
                else if (26 == status) {
                    status = 26;
                }
                else if (status >= 103 && status <= 105) {
                    status = 104;
                }
                else {
                    ParagraphElement *pEle = [[ParagraphElement alloc] init];
                    pEle.eleType = ParagraphElementType_Error;
                    [marrCurParagraph addObject:pEle];
                    [pEle release];
                }
            }
                break;
            case 'i':
            {
                if (0 == status || 1 == status) {
                    status = 1;
                }
                else if (2 == status) {
                    status = 100;
                }
                else if (11 == status || 12 == status) {
                    status = 12;
                }
                else if (13 == status) {
                    status = 13;
                }
                else if (14 == status) {
                    status = 20;
                }
                else if (23 == status || 24 == status) {
                    status = 24;
                }
                else if (26 == status) {
                    status = 26;
                }
                else if (status >= 103 && status <= 105) {
                    status = 104;
                }
                else {
                    ParagraphElement *pEle = [[ParagraphElement alloc] init];
                    pEle.eleType = ParagraphElementType_Error;
                    [marrCurParagraph addObject:pEle];
                    [pEle release];
                }
            }
                break;
            case 'm':
            {
                if (0 == status || 1 == status) {
                    status = 1;
                }
                else if (11 == status || 12 == status) {
                    status = 12;
                }
                else if (13 == status) {
                    status = 13;
                }
                else if (20 == status) {
                    status = 21;
                }
                else if (23 == status || 24 == status) {
                    status = 24;
                }
                else if (26 == status) {
                    status = 26;
                }
                else if (100 == status) {
                    status = 101;
                }
                else if (status >= 103 && status <= 105) {
                    status = 104;
                }
                else {
                    ParagraphElement *pEle = [[ParagraphElement alloc] init];
                    pEle.eleType = ParagraphElementType_Error;
                    [marrCurParagraph addObject:pEle];
                    [pEle release];
                }
            }
                break;
            case 'g':
            {
                if (0 == status || 1 == status) {
                    status = 1;
                }
                else if (11 == status || 12 == status) {
                    status = 12;
                }
                else if (13 == status) {
                    status = 13;
                }
                else if (21 == status) {
                    status = 22;
                }
                else if (23 == status || 24 == status) {
                    status = 24;
                }
                else if (26 == status) {
                    status = 26;
                }
                else if (101 == status) {
                    status = 102;
                }
                else if (status >= 103 && status <= 105) {
                    status = 104;
                }
                else {
                    ParagraphElement *pEle = [[ParagraphElement alloc] init];
                    pEle.eleType = ParagraphElementType_Error;
                    [marrCurParagraph addObject:pEle];
                    [pEle release];
                }
            }
                break;
            case 'b':
            {
                if (0 == status || 1 == status) {
                    status = 1;
                }
                else if (2 == status) {
                    status = 200;
                }
                else if (11 == status || 12 == status) {
                    status = 12;
                }
                else if (13 == status) {
                    status = 13;
                }
                else if (23 == status || 24 == status) {
                    status = 24;
                }
                else if (26 == status) {
                    status = 26;
                }
                else if (status >= 103 && status <= 105) {
                    status = 104;
                }
                else {
                    ParagraphElement *pEle = [[ParagraphElement alloc] init];
                    pEle.eleType = ParagraphElementType_Error;
                    [marrCurParagraph addObject:pEle];
                    [pEle release];
                }
            }
                break;
            case 'r':
            {
                if (0 == status || 1 == status) {
                    status = 1;
                }
                else if (11 == status || 12 == status) {
                    status = 12;
                }
                else if (13 == status) {
                    status = 13;
                }
                else if (23 == status || 24 == status) {
                    status = 24;
                }
                else if (26 == status) {
                    status = 26;
                }
                else if (status >= 103 && status <= 105) {
                    status = 104;
                }
                else if (200 == status) {
                    status = 201;
                }
                else {
                    ParagraphElement *pEle = [[ParagraphElement alloc] init];
                    pEle.eleType = ParagraphElementType_Error;
                    [marrCurParagraph addObject:pEle];
                    [pEle release];
                }
            }
                break;
            default:
            {
                if (0 == status || 1 == status) {
                    status = 1;
                }
                else if (11 == status || 12 == status) {
                    status = 12;
                }
                else if (13 == status) {
                    status = 13;
                }
                else if (23 == status || 24 == status) {
                    status = 24;
                }
                else if (26 == status) {
                    status = 26;
                }
                else if (status >= 103 && status <= 105) {
                    status = 104;
                }
                else {
                    ParagraphElement *pEle = [[ParagraphElement alloc] init];
                    pEle.eleType = ParagraphElementType_Error;
                    [marrCurParagraph addObject:pEle];
                    [pEle release];
                }
            }
                break;
        }
    }
    //
    if (rangeEle.length > 0) {
        ParagraphElement *pEle = [[ParagraphElement alloc] init];
        pEle.sourceText = [article substringWithRange:rangeEle];
        pEle.eleType = ParagraphElementType_Text;
        [marrCurParagraph addObject:pEle];
        [pEle release];
        //
        [marrParagraph addObject:marrCurParagraph];
    }
    [marrCurParagraph release];
    
    //文本转义
    for (NSArray *arrParagraphElement in marrParagraph) {
        for (ParagraphElement *pEle in arrParagraphElement) {
            //非文本类型不转义
            if (pEle.eleType != ParagraphElementType_Text) {
                continue;
            }
            //
            pEle.sourceText = [pEle.sourceText stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
            pEle.sourceText = [pEle.sourceText stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
            pEle.sourceText = [pEle.sourceText stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
            pEle.sourceText = [pEle.sourceText stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
            pEle.sourceText = [pEle.sourceText stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
            pEle.sourceText = [pEle.sourceText stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
        }
    }
    return marrParagraph;
}

@end
