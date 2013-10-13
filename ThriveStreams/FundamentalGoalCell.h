//
//  FundamentalGoalCell.h
//  ThriveStreams
//
//  Created by Ryan Badilla on 10/4/13.
//  Copyright (c) 2013 ThriveStreams. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "M13Checkbox.h"

@interface FundamentalGoalCell : UITableViewCell

@property (nonatomic, strong) UILabel *goalLabel;
@property (nonatomic, strong) M13Checkbox *checkbox;
@property (nonatomic, strong) UIImageView *thriveImage;
@property (nonatomic, strong) NSString *parseObjectID;

-(void)setParseObjectID:(NSString *)parseObjectID;
-(void)setImageForThrive:(UIImage *)image;
- (void)setGoalLabel:(UILabel *)goalLabel;



@end
