//
//  FundamentalGoalCell.h
//  ThriveStreams
//
//  Created by Ryan Badilla on 10/4/13.
//  Copyright (c) 2013 ThriveStreams. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "M13Checkbox.h"

@class FundamentalGoalCell;
@protocol FundamentalGoalCellDelegate <NSObject>
- (void) fundamentalGoalCellAt: (FundamentalGoalCell *) sender;  //define delegate method to be implemented within another class
@end //end protocol


@interface FundamentalGoalCell : UITableViewCell

@property (nonatomic, strong) UILabel *goalLabel;
@property (nonatomic, strong) M13Checkbox *checkbox;
@property (nonatomic, strong) UIImageView *thriveImage;
@property (nonatomic, strong) NSString *parseObjectID;
@property (nonatomic, weak) id <FundamentalGoalCellDelegate> delegate;

-(void)setParseObjectID:(NSString *)parseObjectID;
-(void)setImageForThrive:(UIImage *)image;
- (void)setGoalLabel:(UILabel *)goalLabel;

@end
