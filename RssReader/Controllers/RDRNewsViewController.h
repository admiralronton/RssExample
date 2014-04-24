//
//  NewsViewController.h
//  EmptyAppExample01
//
//  Created by Randall Nickerson on 3/4/14.
//  Copyright (c) 2014 Threadbare Games. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RDRNewsListTableView.h"

@interface RDRNewsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSArray* newsData;
    NSString* newsSource;
    NSInteger storyCountMax;
}


@property (strong, nonatomic) IBOutlet RDRNewsListTableView* newsListTableView;
@property (strong, nonatomic) IBOutlet UILabel* lblStoryCount;
@property (strong, nonatomic) IBOutlet UILabel* lblStorySource;

@end
