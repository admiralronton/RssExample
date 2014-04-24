//
//  SourceDetailViewController.m
//  RssReader
//
//  Created by Ryan J Southwick on 4/22/14.
//  Copyright (c) 2014 Threadbare Games. All rights reserved.
//

#import "SourceDetailViewController.h"
#import "com_cranestylelabsAppDelegate.h"

@interface SourceDetailViewController ()
@property (weak, nonatomic) IBOutlet UITextField *lblTitle;
@property (weak, nonatomic) IBOutlet UITextField *lblURL;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@end

@implementation SourceDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Set the fields
    if (self.sourceItem != nil) {
        self.lblTitle.text = self.sourceItem.title;
        self.lblURL.text = self.sourceItem.url;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if (sender != self.doneButton) {
        self.sourceItem = nil;
        return;
    }
    
    if (self.lblTitle.text.length > 0 && self.lblURL.text.length > 0) {
        com_cranestylelabsAppDelegate* delegate = (com_cranestylelabsAppDelegate*)[UIApplication sharedApplication].delegate;
        if (self.sourceItem == nil) {
            self.sourceItem = [NSEntityDescription insertNewObjectForEntityForName:@"RssSource" inManagedObjectContext:delegate.managedObjectContext];
            self.sourceItem.creationDate = [NSDate date];
        }
        self.sourceItem.title = self.lblTitle.text;
        self.sourceItem.url = self.lblURL.text;
        self.sourceItem.isEnabled = @1;
        self.sourceItem.unreadCount = @0;
        
        NSError* error;
        if (![delegate.managedObjectContext save:&error]) {
            NSLog(@"Unable to add RssSource: %@", [error localizedDescription]);
        }
    }
}

@end
