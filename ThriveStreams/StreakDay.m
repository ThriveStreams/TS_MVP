//
//  StreakDay.m
//  ThriveStreams
//
//  Created by Ryan Badilla on 10/25/13.
//  Copyright (c) 2013 ThriveStreams. All rights reserved.
//

#import "StreakDay.h"
#import <QuartzCore/QuartzCore.h>

@implementation StreakDay

//
// Normal initialization
//
- (id)initWithFrame:(CGRect)frame
     highlightColor:(UIColor *)highlightColor
       defaultColor:(UIColor *)defaultColor
        borderColor:(UIColor *)borderColor
      isHighlighted:(BOOL)isHighlighted
            dayName:(NSString *)dayName
          textColor: (UIColor *)textColor
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // set up the label to be all extra cool (i.e. normal cool, i.e., regular cool, i.e. just regular, i.e. really not that impressive)
        _nameLabel = [[UILabel alloc] initWithFrame:frame];
        _nameLabel.text = dayName;
        _nameLabel.textColor = textColor;
        [_nameLabel sizeToFit];
        
        if (isHighlighted)
            self.backgroundColor = highlightColor;
        else
            self.backgroundColor = defaultColor;
        
        self.layer.borderColor = [borderColor CGColor];
    }
    
    return self;
}



-(void)setHighlight:(BOOL)willHighlight
{
    if (willHighlight)
        self.backgroundColor = _highlightColor;
    else
        self.backgroundColor = _defaultColor;
}

-(void)changeBorderColor:(UIColor *)newBorderColor
{
    self.layer.borderColor = [newBorderColor CGColor];
}

-(void)changeColor:(UIColor *)color
{
    self.backgroundColor = color;
}

//
// Default frame initialization
//
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}


@end
