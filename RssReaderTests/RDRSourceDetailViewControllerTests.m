//
//  RDRSourceDetailViewControllerTests.m
//  RssReader
//
//  Created by Ryan J Southwick on 4/24/14.
//  Copyright (c) 2014 Threadbare Games. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RDRSourceDetailViewController.h"

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

#define MOCKITO_SHORTHAND
#import <OCMockitoIOS/OCMockitoIOS.h>

@interface RDRSourceDetailViewControllerTests : XCTestCase

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation RDRSourceDetailViewControllerTests

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

RDRSourceDetailViewController *controller;

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    // Set up the controller.  The controller will be loaded, but key methods, like viewDidLoad, need to be called explicitly
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    controller = [storyboard instantiateViewControllerWithIdentifier:@"sourceDetailViewController"];

    // Mock our data source
    RDRDataSource *dataSource = mock([RDRDataSource class]);
    controller.dataSource = dataSource;

    [controller performSelectorOnMainThread:@selector(loadView) withObject:nil waitUntilDone:YES];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [[self managedObjectContext] save:nil];
    controller = nil;
    [super tearDown];
}

- (void)testTitleFieldShouldBeConnected
{
    // given
    RDRSourceDetailViewController *sut = controller;
    
    // then
    XCTAssertNotNil(sut.txtTitle, @"Title field not connected");
}

- (void)testURLFieldShouldBeConnected
{
    // given
    RDRSourceDetailViewController *sut = controller;
    
    // then
    XCTAssertNotNil(sut.txtURL, @"URL field not connected");
}

- (void)testNoSourceShouldShowBlanksFields
{
    // given
    RDRSourceDetailViewController *sut = controller;

    // when
    [sut viewDidLoad];

    // then
    XCTAssertEqualObjects(@"", sut.txtTitle.text, @"Title");
    XCTAssertEqualObjects(@"", sut.txtURL.text, @"URL");
}

- (void)testNoSourceItemShouldHaveAddTitle
{
    // given
    RDRSourceDetailViewController *sut = controller;
    
    // when
    [sut viewDidLoad];
    
    // then
    XCTAssertEqualObjects(@"Create Source", sut.title, @"Title");
}

- (void)testExistingSourceShouldHaveEditTitle
{
    // given
    RDRSourceDetailViewController *sut = controller;
    sut.sourceItem = [self getNewSource];
    
    // when
    [sut viewDidLoad];
    
    // then
    XCTAssertEqualObjects(@"Source Details", sut.title, @"Title");
}

- (void)testExistingSourceShouldPopulateTextFields
{
    // given
    RDRSourceDetailViewController *sut = controller;

    RssSource* source = [self getNewSource];
    
    sut.sourceItem = source;
    
    // when
    [sut viewDidLoad];
    
    // then
    XCTAssertEqualObjects(@"someTitle", sut.txtTitle.text, @"Title");
    XCTAssertEqualObjects(@"http://nowhere.com", sut.txtURL.text, @"URL");
}

- (void)testAddNewSource
{
    // given
    RDRSourceDetailViewController *sut = controller;
    sut.txtTitle.text = @"someTitle";
    sut.txtURL.text = @"http://blah";
    
    // when
    [sut prepareForSegue:nil sender:sut.doneButton];
    
    // then
    [verify(sut.dataSource) saveContext];
    XCTAssertNotNil(sut.sourceItem, @"Source item nil");
    XCTAssertEqualObjects(@"someTitle", sut.sourceItem.title, @"Source title");
    XCTAssertEqualObjects(@"http://blah", sut.sourceItem.url, @"Source URL");
}

- (void)testEditSource
{
    // given
    RDRSourceDetailViewController *sut = controller;
    RssSource* source = [self getNewSource];
    [self.managedObjectContext save:nil];
    NSManagedObjectID * expectedID = [source.objectID copy];
    
    sut.sourceItem = source;

    sut.txtTitle.text = @"someTitleEdited";
    sut.txtURL.text = @"http://blahEdited";
    
    // when
    [sut prepareForSegue:nil sender:sut.doneButton];
    
    
    // then
    [verify(sut.dataSource) saveContext];
    XCTAssertNotNil(sut.sourceItem, @"Source item nil");
    XCTAssertEqualObjects(@"someTitleEdited", sut.sourceItem.title, @"Source title");
    XCTAssertEqualObjects(@"http://blahEdited", sut.sourceItem.url, @"Source URL");
    XCTAssertEqualObjects(expectedID, sut.sourceItem.objectID, @"ObjectID");
}

- (void)testEditCancel
{
    // given
    RDRSourceDetailViewController *sut = controller;
    RssSource* source = [self getNewSource];
    [self.managedObjectContext save:nil];
    NSManagedObjectID *expectedID = [source.objectID copy];
    
    sut.sourceItem = source;
    
    sut.txtTitle.text = @"someTitleEdited";
    sut.txtURL.text = @"http://blahEdited";
    
    
    // when
    [sut prepareForSegue:nil sender:nil];
    
    
    // then
    [verifyCount(sut.dataSource, never()) saveContext];
    XCTAssertNil(sut.sourceItem, @"Source item nil");
}

- (void)testAddCancel
{
    // given
    RDRSourceDetailViewController *sut = controller;
    sut.txtTitle.text = @"someTitleEdited";
    sut.txtURL.text = @"http://blahEdited";
    
    
    // when
    [sut prepareForSegue:nil sender:nil];
    
    
    // then
    [verifyCount(sut.dataSource, never()) saveContext];
    XCTAssertNil(sut.sourceItem, @"Source item nil");
}

- (void)testDataSourceAutoSet
{
    // given
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    RDRSourceDetailViewController *sut = [storyboard instantiateViewControllerWithIdentifier:@"sourceDetailViewController"];
    
    [sut performSelectorOnMainThread:@selector(loadView) withObject:nil waitUntilDone:YES];

    // when
    [sut viewDidLoad];
    
    // then
    XCTAssertNotNil(sut.dataSource, @"Data source is nil");
}


#pragma mark Utility functions
// Returns a new RssSource object that is not associated with a context.
- (RssSource *)getNewSource
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"RssSource" inManagedObjectContext:self.managedObjectContext];
    RssSource* source = (RssSource*)[[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
    source.title = @"someTitle";
    source.url = @"http://nowhere.com";

    return source;
}

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    return [[RDRDataSource sharedInstance] managedObjectContext];
}
@end
