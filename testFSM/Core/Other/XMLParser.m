//
//  XMLParser.m
//
//
//  Created by yangjianhong-MAC on 11-12-31.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//  QQ:18222469
//

#import "XMLParser.h"

#pragma mark - XMLNode

@interface XMLNode () {
    
    NSMutableArray *_marrChild;
}
@property (nonatomic, strong) NSString *nodeName;               // 结点名称
@property (nonatomic, strong) NSDictionary *nodeAttributesDict; // 结点属性
@property (nonatomic, strong) NSArray *children;                // 子结点
@property (nonatomic, strong) NSString *nodeValue;              // 结点值
@property (nonatomic, assign) NSUInteger nodeDepth;
@property (nonatomic, strong) XMLNode *nodeParent;              // 父结点
@end

@implementation XMLNode

#pragma mark Override

- (NSString *)description
{
    if (self.nodeName.length == 0) {
        return @"";
    }
    
    NSMutableString *mstrDescription = [NSMutableString string];
    // 表示深度的空格字符
    NSMutableString *mstrSpace = [NSMutableString string];
    for (int i = 0; i < self.nodeDepth; i++) {
        [mstrSpace appendString:@" "];
    }
    [mstrDescription appendString:mstrSpace];
    // 结点的名称
    [mstrDescription appendFormat:@"\r\n%@<%@", mstrSpace, self.nodeName];
    // 结点的属性
    NSArray *arrayKeys = [self.nodeAttributesDict allKeys];
    for (NSString *strKey in arrayKeys) {
        [mstrDescription appendFormat:@" \"%@\"=\"%@\"", strKey, self.nodeAttributesDict[strKey]];
    }
    [mstrDescription appendString:@">"];
    // 结点的值
    if (self.nodeValue.length > 0) {
        [mstrDescription appendFormat:@"%@", self.nodeValue];
    }
    // 子结点部分
    if (_marrChild.count > 0) {
        // 遍历所有子结点
        for (XMLNode *nodeChild in _marrChild) {
            // 子结点描述串
            [mstrDescription appendFormat:@"%@", nodeChild];
        }
        [mstrDescription appendFormat:@"\r\n%@", mstrSpace];
    }
    // 结点的结束
    [mstrDescription appendFormat:@"</%@>", self.nodeName];
    //
    return mstrDescription;
}

#pragma mark Property

- (NSArray *)children
{
    if (_marrChild.count > 0) {
        return [NSArray arrayWithArray:_marrChild];
    }
    else {
        return nil;
    }
}

- (void)setNodeParent:(XMLNode *)nodeParent
{
    _nodeParent = nodeParent;
    // 计算本结点的深度
    if (nil == nodeParent) {
        // 父结点为nil，当前结点深度为0
        self.nodeDepth = 0;
    }
    else {
        // 当前结点深度为父结点深度+1
        self.nodeDepth = nodeParent.nodeDepth + 1;
    }
    // 更新子结点的深度
    for (XMLNode *nodeChild in _marrChild) {
        // 通过设置父结点的方式更新子结点深度
        nodeChild.nodeParent = self;
    }
}

#pragma mark Public

// 查询指定名称的结点
- (NSArray *)findNodesWithNodeName:(NSString *)nodeName
{
    NSMutableArray *marray = [NSMutableArray array];
    //
    NSMutableArray *marrNode = [NSMutableArray arrayWithObject:self];
    while (marrNode.count > 0) {
        // 取首结点
        XMLNode *node = marrNode[0];
        [marrNode removeObjectAtIndex:0];
        //
        if ([node.nodeName isEqualToString:nodeName]) {
            [marray addObject:node];
        }
        //
        NSArray *arrayChild = node.children;
        for (XMLNode *childNode in arrayChild) {
            [marrNode addObject:childNode];
        }
    }
    
    return marray;
}

// 清空结点
- (void)clear
{
    // 遍历所有子结点
    NSArray *arrayChild = [self children];
    for (XMLNode *node in arrayChild) {
        // 清空子结点的数据
        [node clear];
    }
    // 清空当前结点数据
    self.nodeDepth = 0;
    self.nodeName = nil;
    self.nodeValue = nil;
    self.nodeAttributesDict = nil;
    self.nodeParent = nil;
    // 清空子结点表
    [_marrChild removeAllObjects];
}

#pragma mark Private

- (void)addChildNode:(XMLNode *)childNode
{
    if (nil == _marrChild) {
        _marrChild = [NSMutableArray arrayWithCapacity:5];
    }
    //
    [_marrChild addObject:childNode];
}

@end


#pragma mark - Interface XMLParser

@interface XMLParser : NSObject <NSXMLParserDelegate> {
    NSMutableArray *_marrNode;
}

@property (nonatomic, retain) NSString *nodeName;

@property (nonatomic, strong) XMLNode *rootNode;
@property (nonatomic, strong) XMLNode *currentNode;

- (XMLNode *)parse:(NSData *)dataXML;

- (NSArray *)findXMLNodesWithNodeName:(NSString *)nodeName from:(NSData *)dataXML;

@end



#pragma mark Implementation XMLParser

@implementation XMLParser

- (id)init
{
    self = [super init];
    if (self) {
        _marrNode = [[NSMutableArray alloc] init];
    }
    return self;
}

- (XMLNode *)parse:(NSData *)dataXML
{
    self.rootNode = nil;
    self.currentNode = nil;
    self.nodeName = nil;
    //
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:dataXML]; // 设置XML数据
    [parser setShouldProcessNamespaces:NO];
    [parser setShouldReportNamespacePrefixes:NO];
    [parser setShouldResolveExternalEntities:NO];
    [parser setDelegate:self];
    [parser parse];
    
    return self.rootNode;
}

- (NSArray *)findXMLNodesWithNodeName:(NSString *)nodeName from:(NSData *)dataXML
{
    [_marrNode removeAllObjects];
    self.nodeName = nodeName;
    //
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:dataXML]; // 设置XML数据
    [parser setShouldProcessNamespaces:NO];
    [parser setShouldReportNamespacePrefixes:NO];
    [parser setShouldResolveExternalEntities:NO];
    [parser setDelegate:self];
    [parser parse];
    
    return [NSArray arrayWithArray:_marrNode];
}

#pragma mark NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
#ifdef DEBUG
    NSLog(@"element start:%@",elementName);
#endif
    //
    if (nil == self.rootNode) {
        // 创建根结点
        self.rootNode = [[XMLNode alloc] init];
        self.rootNode.nodeName = elementName;
        self.rootNode.nodeAttributesDict = attributeDict;
        self.rootNode.nodeParent = nil;
        //
        self.currentNode = self.rootNode;
    }
    else {
        //
        XMLNode *nodeChild = [[XMLNode alloc] init];
        nodeChild.nodeName = elementName;
        nodeChild.nodeAttributesDict = attributeDict;
        nodeChild.nodeParent = self.currentNode;
        //
        [self.currentNode addChildNode:nodeChild];
        self.currentNode = nodeChild;
    }
    
    if (self.nodeName.length > 0 && [self.nodeName isEqualToString:elementName]) {
        [_marrNode addObject:self.currentNode];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    //去掉字符串首尾的空字符
    NSString *strValidValue = [string stringByTrimmingCharactersInSet:
                               [NSCharacterSet controlCharacterSet]];
#ifdef DEBUG
    NSLog(@"element value:%@",strValidValue);
#endif
    if (nil == self.currentNode.nodeValue) {
        self.currentNode.nodeValue = strValidValue;
    }
    else {
        self.currentNode.nodeValue = [NSString stringWithFormat:@"%@%@",
                                      self.currentNode.nodeValue, strValidValue];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
#ifdef DEBUG
    NSLog(@"element end.");
#endif
    //
    self.currentNode = self.currentNode.nodeParent;
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
#ifdef DEBUG
    NSLog(@"parse error:%@", parseError);
#endif
}

@end


#pragma mark - NSData(XMLParser)

@implementation NSData (XMLParser)

- (XMLNode *)xmlNode
{
    XMLParser *parser = [[XMLParser alloc] init];
    XMLNode *node = [parser parse:self];
    return node;
}

- (NSArray *)findXMLNodesWithNodeName:(NSString *)nodeName
{
    XMLParser *parser = [[XMLParser alloc] init];
    NSArray *xmlNodes = [parser findXMLNodesWithNodeName:nodeName from:self];
    return xmlNodes;
}

@end


#pragma mark - NSString(XMLParser)

@implementation NSString (XMLParser)

- (XMLNode *)xmlNodeWithEncoding:(NSStringEncoding)encoding
{
    return [[self dataUsingEncoding:encoding] xmlNode];
}

- (NSArray *)findXMLNodesWithNodeName:(NSString *)nodeName encoding:(NSStringEncoding)encoding
{
    return [[self dataUsingEncoding:encoding] findXMLNodesWithNodeName:nodeName];
}

@end
