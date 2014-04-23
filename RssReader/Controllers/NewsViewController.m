//
//  NewsViewController.m
//  EmptyAppExample01
//
//  Created by Randall Nickerson on 3/4/14.
//  Copyright (c) 2014 Threadbare Games. All rights reserved.
//

#import "NewsViewController.h"

#import <RestKit/RestKit.h>
#import "NSString+URLEncoding.h"
#import "NewsItem.h"
#import "NewsCell.h"

@interface NewsViewController ()

@end

@implementation NewsViewController

static const bool SHOW_NAV_BAR = YES;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    self.newsListTableView.delegate = self;
    self.newsListTableView.dataSource = self;
    
    [self.navigationController setNavigationBarHidden:SHOW_NAV_BAR];
    
    newsSource = @"http://phys.org/rss-feed/";
    storyCountMax = 50;
    
    
    
    // https://ajax.googleapis.com/ajax/services/feed/find?v=1.0&q=News
    // https://ajax.googleapis.com/ajax/services/feed/load
    NSURL* baseURL = [NSURL URLWithString:@"https://ajax.googleapis.com/ajax/services/feed"];
    AFHTTPClient * client = [AFHTTPClient clientWithBaseURL:baseURL];
    [client setDefaultHeader:@"Accept" value:RKMIMETypeJSON];
    
    
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/javascript"];
    
    RKObjectMapping* newsItemMapping = [RKObjectMapping mappingForClass:[NewsItem class]];
    [newsItemMapping addAttributeMappingsFromDictionary:
     @{ @"link"          : @"link",
        @"title"         : @"title",
        @"author"        : @"author",
        @"publishedDate" : @"publishedDate",
        @"contentSnippet": @"contentSnippet",
        @"content"       : @"content" }
    ];
    
    RKResponseDescriptor* responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:newsItemMapping
                                                                                            method:RKRequestMethodGET
                                                                                       pathPattern:nil
                                                                                           keyPath:@"responseData.feed.entries"
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];

    
    [objectManager addResponseDescriptor:responseDescriptor];
    
    NSLog(@"responseDescriptors.count = %lu", (unsigned long)objectManager.responseDescriptors.count);
    
    [self sendRequest:objectManager];
	
}

- (void) sendRequest:(RKObjectManager*) objectManager
{
    NSString* version = @"2.0";
    NSString* num     = [NSString stringWithFormat:@"%i", (int)storyCountMax];
    NSString* raw     = newsSource;
    NSString* query   = raw;
    NSString* url     = [NSString stringWithFormat:@"%@%@", [[objectManager baseURL] absoluteString], @"load"];
    
    NSDictionary* queryParams = [NSDictionary dictionaryWithObjectsAndKeys:version, @"v", num, @"num", query, @"q", nil];
    
    [objectManager getObjectsAtPath:url
                         parameters:queryParams
                            success:^(RKObjectRequestOperation * operaton, RKMappingResult *mappingResult)
                             {
                                 newsData = [mappingResult array];
                                 [self.newsListTableView reloadData];
                                 [self updateStoryListLabelsCount:newsData.count from:newsSource];
//                                 for (NewsItem *item in newsData)
//                                 {
//                                     NSLog(@"title = %@",item.title);
//                                 }
                             }
                            failure:^(RKObjectRequestOperation * operaton, NSError * error)
                             {
                                 NSLog(@"\n\n");
                                 NSLog(@"Response Data:\n");
                                 NSLog(@"%@", operaton.HTTPRequestOperation.responseString);
                                 NSLog (@"\n\nfailure: operation: %@ \n\nerror: %@", operaton, error);
                             }
     ];
}

- (NSDictionary*) elementToPropertyMappings
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"url",            @"url",
            @"title",          @"title",
            @"contentSnippet", @"contentSnippet",
            @"link",           @"link",
            nil];
}

- (void) updateStoryListLabelsCount:(NSInteger) count from:(NSString*) addr
{
    [self updateStoryCountLabel:count];
    [self updateStorySourceLabel:addr];
}

- (void) updateStoryCountLabel:(NSInteger) count
{
    self.lblStoryCount.text = [NSString stringWithFormat:@"%i news stories found at", (int)count];
}

- (void) updateStorySourceLabel:(NSString*) addr
{
    self.lblStorySource.text = addr;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark --- TABLEVIEW STUFF ---

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return newsData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NewsCell* cell = [tableView dequeueReusableCellWithIdentifier:@"NewsCell"];
    NewsItem* newsItem = [newsData objectAtIndex:indexPath.row];
    
    NSDateFormatter* dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss zzzz"];
    
    NSDateFormatter* dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"yyyy-MM-dd hh:mm aaa"];
    //[dateFormatter2 setTimeStyle:NSDateFormatterNoStyle];
    
    NSDate* pubDate = [dateFormatter1 dateFromString:newsItem.publishedDate];
    
    NSInteger charLimit = 50;
    cell.lblTitle.text = [newsItem.title length] > charLimit ? [[newsItem.title substringToIndex:charLimit] stringByAppendingString:@"..."] : newsItem.title;
    cell.lblDate.text  = [dateFormatter2 stringFromDate:pubDate];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"Preparing for segue [%@]", segue.identifier);
    //    if ([[segue identifier] isEqualToString:@"showDetail"]) {
    //        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    //        NSDate *object = [_objects objectAtIndex:indexPath.row];
    //        [[segue destinationViewController] setDetailItem:object];
    //    }
}

@end
