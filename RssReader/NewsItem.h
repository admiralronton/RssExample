//
//  NewsItem.h
//  EmptyAppExample01
//
//  Created by Randall Nickerson on 3/4/14.
//  Copyright (c) 2014 Threadbare Games. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsItem : NSObject

@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSString* contentSnippet;
@property (strong, nonatomic) NSString* author;
@property (strong, nonatomic) NSString* link;
@property (strong, nonatomic) NSString* publishedDate;
@property (strong, nonatomic) NSString* content;
@property (nonatomic) bool read;

@end