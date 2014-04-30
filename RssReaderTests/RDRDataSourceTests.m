//
//  RDRDataSourceTests.m
//  RssReader
//
//  Created by Ryan J Southwick on 4/25/14.
//  Copyright (c) 2014 Threadbare Games. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RDRDataSource.h"
#import "RssSource.h"

@interface RDRDataSourceTests : XCTestCase

@property RDRDataSource *dataSource;

@end

@implementation RDRDataSourceTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.dataSource = [RDRDataSource sharedInstance];
    // Clear out the data
    [self clearData];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [self clearData];
    [super tearDown];
}

- (void)clearData
{
    // Clear out the data
    NSManagedObjectContext *context = self.dataSource.managedObjectContext;
    
    [context reset];
    NSArray *result = [self getRssSourcesFromDatabase:self.dataSource.managedObjectContext];
    for (id source in result)
        [context deleteObject:source];
    [self.dataSource.managedObjectContext save:nil];
}

- (void)testGetSourcesShouldReturnArray
{
    // given
    RDRDataSource *sut = self.dataSource;
    
    // when
    NSArray *sources = [sut getAllSources];
    
    // then
    XCTAssertNotNil(sources, @"Source results nil");
}

- (void)testGetSourcesShouldReturnOneSource
{
    // given
    RDRDataSource *sut = self.dataSource;
    RssSource *expected = [self getNewRssSource];
    [self.dataSource.managedObjectContext save:nil];
    NSManagedObjectID *expectedID = [expected.objectID copy];
    
    // when
    NSArray *actuals = [sut getAllSources];
    
    // then
    XCTAssertTrue(actuals.count == 1, "Result count is %d", actuals.count);
    RssSource *actual = (RssSource *)actuals[0];
    XCTAssertEqualObjects(expectedID, actual.objectID, @"ObjectID");
}

- (void)testGetSourcesShouldReturnMultipleSources
{
    // given
    RDRDataSource *sut = self.dataSource;
    NSMutableArray *expecteds = [[NSMutableArray alloc]init];
    for(int i = 0; i < 3; i++) {
        RssSource *expected = [self getNewRssSource];
        expected.title = [NSString stringWithFormat:@"source%d", i];
        expected.url = [NSString stringWithFormat:@"http://url%d", i];
        [expecteds addObject:expected];
    }
    [self.dataSource.managedObjectContext save:nil];
    
    // when
    NSArray *actuals = [sut getAllSources];
    
    // then
    XCTAssertEqual(expecteds.count, actuals.count, "Result count is %d", actuals.count);
}


- (void)testSaveContextShouldPersistData
{
    // given
    RDRDataSource *sut = self.dataSource;
    [self getNewRssSource];

    // when
    [sut saveContext];
    
    // then
    NSArray *result = [self getRssSourcesFromDatabase:sut.managedObjectContext];
    XCTAssertEqual(1, result.count, @"Context save result count = 1");
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
