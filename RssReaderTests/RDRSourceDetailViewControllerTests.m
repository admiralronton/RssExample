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
    [controller performSelectorOnMainThread:@selector(loadView) withObject:nil waitUntilDone:YES];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
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
    // Mock our data source
    RDRDataSource *dataSource = mock([RDRDataSource class]);
    sut.dataSource = dataSource;
    
    // when
    [sut prepareForSegue:nil sender:sut.doneButton];
    
    // then
    [verify(dataSource) saveContext];
    XCTAssertNotNil(sut.sourceItem, @"Source item nil");
    XCTAssertEqualObjects(@"someTitle", sut.sourceItem.title, @"Source title");
    XCTAssertEqualObjects(@"http://blah", sut.sourceItem.url, @"Source URL");
}

- (void)testEditSource
{
    // given
    RDRSourceDetailViewController *sut = controller;
    RssSource* source = [self getNewSource];
    source.title = @"someTitle";
    source.url = @"http://nowhere.com";
    [self.managedObjectContext save:nil];
    NSManagedObjectID * expectedID = [source.objectID copy];
    
    sut.sourceItem = source;

    sut.txtTitle.text = @"someTitleEdited";
    sut.txtURL.text = @"http://blahEdited";
    
    // Mock our data source
    RDRDataSource *dataSource = mock([RDRDataSource class]);
    sut.dataSource = dataSource;
    
    
    // when
    [sut prepareForSegue:nil sender:sut.doneButton];
    
    
    // then
    [verify(dataSource) saveContext];
    XCTAssertNotNil(sut.sourceItem, @"Source item nil");
    XCTAssertEqualObjects(@"someTitleEdited", sut.sourceItem.title, @"Source title");
    XCTAssertEqualObjects(@"http://blahEdited", sut.sourceItem.url, @"Source URL");
    XCTAssertEqualObjects(expectedID, sut.sourceItem.objectID, @"ObjectID");
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
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"EmptyAppExample01" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"EmptyAppExample01_tests.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
