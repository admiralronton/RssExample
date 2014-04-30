//
//  RDRTestDataHelper.m
//  RssReader
//
//  Created by Ryan J Southwick on 4/28/14.
//  Copyright (c) 2014 Threadbare Games. All rights reserved.
//

#import "RDRTestDataHelper.h"
#import "RDRDataSource.h"
#import "RssSource.h"

@implementation RDRTestDataHelper

@synthesize dataSource;

- (RDRDataSource *)dataSource
{
    return [RDRDataSource sharedInstance];
}

- (void)clearData
{
    // Clear out the data
    NSManagedObjectContext *context = [RDRDataSource sharedInstance].managedObjectContext;
    
    [context reset];
    NSArray *result = [self getRssSourcesFromDatabase:[RDRDataSource sharedInstance].managedObjectContext];
    for (id source in result)
        [context deleteObject:source];
    [self.dataSource.managedObjectContext save:nil];
}

// Returns a new RssSource object that is not associated with a context.
- (RssSource *)getNewRssSource
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"RssSource" inManagedObjectContext:self.dataSource.managedObjectContext];
    RssSource* source = (RssSource*)[[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:self.dataSource.managedObjectContext];
    source.title = @"source1";
    source.url = @"http://url1";
    source.creationDate = [NSDate date];
    
    return source;
}

- (NSArray *)getRssSourcesFromDatabase:(NSManagedObjectContext *)context
{
    [context reset];
    NSFetchRequest * fetch = [[NSFetchRequest alloc] init];
    [fetch setEntity:[NSEntityDescription entityForName:@"RssSource" inManagedObjectContext:context]];
    return [context executeFetchRequest:fetch error:nil];
}

@end
