//
//  FundamentalGoalCell.m
//  ThriveStreams
//
//  Created by Ryan Badilla on 10/4/13.
//  Copyright (c) 2013 ThriveStreams. All rights reserved.
//

#import "FundamentalGoalCell.h"


@interface FundamentalGoalCell ()

@property BOOL isChecked;

@end

@implementation FundamentalGoalCell



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _goalLabel = [[UILabel alloc] initWithFrame:CGRectMake(44, 11, 256, 21)];
        [_goalLabel setFont:[UIFont systemFontOfSize:14.0f]];
        
        // set up
        _isChecked = NO;
        _checkbox = [[M13Checkbox alloc] initWithFrame:CGRectMake(8, 11, 28, 22)];
        _checkbox.flat = YES;

        [self.contentView addSubview:_goalLabel];
        [self.contentView addSubview:_checkbox];
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}


- (void)setGoalLabel:(UILabel *)goalLabel
{
    _goalLabel = goalLabel;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
