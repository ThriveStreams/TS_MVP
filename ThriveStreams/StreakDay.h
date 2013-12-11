//
//  StreakDay.h
//  ThriveStreams
//
//  Created by Ryan Badilla on 10/25/13.
//  Copyright (c) 2013 ThriveStreams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StreakDay : UIView

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UIColor *highlightColor;
@property (nonatomic, strong) UIColor *defaultColor;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, strong) NSString *dayName;
@property (nonatomic, strong) UIColor *textColor;
@property BOOL isHighlighted;


@end
