//
//  RDRSourcesTableViewController.m
//  RssReader
//
//  Created by Ryan J Southwick on 4/25/14.
//  Copyright (c) 2014 Threadbare Games. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RDRSourcesTableViewController.h"

@interface RDRSourcesTableViewControllerTests : XCTestCase

@end

@implementation RDRSourcesTableViewControllerTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testTableOutletIsConnected
{
    // given
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    RDRSourcesTableViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"sourcesTableViewController"];
    
    // when
    [controller performSelectorOnMainThread:@selector(loadView) withObject:nil waitUntilDone:YES];

    // then
    XCTAssertNotNil(controller.tableView, @"table view");
}

@end
