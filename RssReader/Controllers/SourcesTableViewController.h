//
//  SourcesTableViewController.h
//  RssReader
//
//  Created by Ryan J Southwick on 4/22/14.
//  Copyright (c) 2014 Threadbare Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SourcesTableViewController : UITableViewController

@property (nonatomic, strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

- (IBAction)unwindToList:(UIStoryboardSegue*)segue;

@end
