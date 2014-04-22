//
//  NewsCell.h
//  EmptyAppExample01
//
//  Created by Randall Nickerson on 3/5/14.
//  Copyright (c) 2014 Threadbare Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsCell : UITableViewCell
{
    bool wasRead;
}

@property (strong, nonatomic) IBOutlet UILabel* lblTitle;
@property (strong, nonatomic) IBOutlet UILabel* lblDate;
@property (strong, nonatomic) IBOutlet UIImageView* imgDot;

@end
