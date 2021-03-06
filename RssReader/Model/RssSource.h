//
//  RssSource.h
//  RssReader
//
//  Created by Ryan J Southwick on 4/24/14.
//  Copyright (c) 2014 Threadbare Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface RssSource : NSManagedObject

@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSNumber * isEnabled;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * unreadCount;
@property (nonatomic, retain) NSString * url;

@end
