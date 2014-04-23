//
//  SourceItem.h
//  RssReader
//
//  Created by Ryan J Southwick on 4/22/14.
//  Copyright (c) 2014 Threadbare Games. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SourceItem : NSObject

@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSString* url;
@property (nonatomic) BOOL isEnabled;
@property (strong, nonatomic) NSDate* creationDate;

@end
