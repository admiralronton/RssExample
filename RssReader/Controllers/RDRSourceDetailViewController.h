//
//  SourceDetailViewController.h
//  RssReader
//
//  Created by Ryan J Southwick on 4/22/14.
//  Copyright (c) 2014 Threadbare Games. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SourceItem.h"
#import "RssSource.h"

@interface RDRSourceDetailViewController : UIViewController

@property RssSource* sourceItem;
@property (weak, nonatomic) IBOutlet UITextField *txtTitle;
@property (weak, nonatomic) IBOutlet UITextField *txtURL;

@end
