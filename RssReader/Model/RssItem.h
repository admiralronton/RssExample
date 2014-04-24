//
//  RssItem.h
//  RssReader
//
//  Created by Ryan J Southwick on 4/23/14.
//  Copyright (c) 2014 Threadbare Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RssSource;

@interface RssItem : NSManagedObject

@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSDate * publishedDate;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSDate * favoritedDate;
@property (nonatomic, retain) NSDate * readDate;
@property (nonatomic, retain) NSString * contentSnippet;
@property (nonatomic, retain) RssSource *source;

@end
