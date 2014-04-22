//
//  NewsCell.m
//  EmptyAppExample01
//
//  Created by Randall Nickerson on 3/5/14.
//  Copyright (c) 2014 Threadbare Games. All rights reserved.
//

#import "NewsCell.h"

@implementation NewsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        wasRead = NO;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

- (void)markAsRead:(BOOL)read
{
    wasRead = read;
    // TODO: change the imgDot
}

@end
