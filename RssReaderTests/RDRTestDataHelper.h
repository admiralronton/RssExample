//
//  RDRTestDataHelper.h
//  RssReader
//
//  Created by Ryan J Southwick on 4/28/14.
//  Copyright (c) 2014 Threadbare Games. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RDRDataSource;

@interface RDRTestDataHelper : NSObject

@property RDRDataSource *dataSource;

- (void) clearData;

@end
