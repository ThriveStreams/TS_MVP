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
@property UITapGestureRecognizer *tapGestureRecognizer;

@end

@implementation FundamentalGoalCell



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _goalLabel = [[UILabel alloc] initWithFrame:CGRectMake(52, 12, 224, 21)];
        [_goalLabel setFont:[UIFont systemFontOfSize:14.0f]];
        
        // set up
        _isChecked = NO;
        _checkbox = [[M13Checkbox alloc] initWithFrame:CGRectMake(284, 11, 28, 22)];
        _checkbox.flat = YES;

        _thriveImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        
        [self.contentView addSubview:_goalLabel];
        [self.contentView addSubview:_checkbox];
        [self.contentView addSubview:_thriveImage];
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

-(void)setImageForThrive:(UIImage *)image
{
    [_thriveImage setImage:image];
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
