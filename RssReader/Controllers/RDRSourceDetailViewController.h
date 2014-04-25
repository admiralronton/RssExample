//
//  SourceDetailViewController.h
//  RssReader
//
//  Created by Ryan J Southwick on 4/22/14.
//  Copyright (c) 2014 Threadbare Games. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RDRDataSource.h"
#import "SourceItem.h"
#import "RssSource.h"

@interface RDRSourceDetailViewController : UIViewController

#pragma mark - Properties

@property (strong, nonatomic) RDRDataSource *dataSource;

@property (strong, nonatomic) RssSource *sourceItem;

@property (weak, nonatomic) IBOutlet UITextField *txtTitle;
@property (weak, nonatomic) IBOutlet UITextField *txtURL;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@end
