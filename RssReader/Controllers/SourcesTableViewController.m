//
//  SourcesTableViewController.m
//  RssReader
//
//  Created by Ryan J Southwick on 4/22/14.
//  Copyright (c) 2014 Threadbare Games. All rights reserved.
//

#import "SourcesTableViewController.h"
#import "SourceItem.h"
#import "SourceDetailViewController.h"

@interface SourcesTableViewController ()

@property NSMutableArray* sources;

@end

@implementation SourcesTableViewController

- (IBAction)unwindToList:(UIStoryboardSegue*)segue
{
    SourceDetailViewController* source = [segue sourceViewController];
    SourceItem* item = source.sourceItem;
    
    if (item != nil) {
        if (![self.sources containsObject:item]) {
            [self.sources addObject:item];
        }
        [self.tableView reloadData];
    }
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.sources = [[NSMutableArray alloc] init];
    [self loadInitialData];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)loadInitialData
{
    SourceItem* item = [[SourceItem alloc] init];
    item.title = @"PhysOrg";
    item.url = @"http://phys.org/rss";
    item.creationDate = nil;
    item.isEnabled = YES;
    [self.sources addObject:item];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.sources count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sourceCellPrototype" forIndexPath:indexPath];
    
    // Configure the cell...
    SourceItem* item = [self.sources objectAtIndex:indexPath.row];
    cell.textLabel.text = item.title;
    cell.detailTextLabel.text = item.url;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"ShowDetails"]) {
        // The destination controller is the Navigation controller.  We need the SourceDetailViewController, which is a child of the navigation controller.
        SourceDetailViewController* detailViewController = [[[segue destinationViewController] viewControllers] objectAtIndex:0];
        NSIndexPath* indexPath = [self.tableView indexPathForSelectedRow];
        
        // Set the source item for the destination controller
        detailViewController.sourceItem = [self.sources objectAtIndex:indexPath.row];
    }
}

@end
