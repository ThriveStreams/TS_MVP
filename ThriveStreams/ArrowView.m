//
//  ArrowView.m
//  Uptimal
//
//  Created by Ryan Badilla on 11/12/13.
//  Copyright (c) 2013 ThriveStreams. All rights reserved.
//

#import "ArrowView.h"
#import "UIBezierPath+dqd_arrowhead.h"

@implementation ArrowView
{
    CGPoint startPoint;
    CGPoint endPoint;
    CGFloat tailWidth;
    CGFloat headWidth;
    CGFloat headLength;
    UIBezierPath *path;
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        startPoint = CGPointMake(frame.size.width / 2, 0);
        endPoint = CGPointMake(frame.size.width / 2, frame.size.height);
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [[UIColor colorWithWhite:1.0 alpha:1.0] setStroke];
    tailWidth = 4;
    headWidth = 10;
    headLength = 8;
    path = [UIBezierPath dqd_bezierPathWithArrowFromPoint:(CGPoint)startPoint
                                                  toPoint:(CGPoint)endPoint
                                                tailWidth:(CGFloat)tailWidth
                                                headWidth:(CGFloat)headWidth
                                               headLength:(CGFloat)headLength];
    [path setLineWidth:1.0];
    [path stroke];
}

- (CGPoint)startPoint
{
    return startPoint;
}

- (CGPoint)endPoint
{
    return endPoint;
}

- (void)setEndPoint:(CGPoint)point
{
    endPoint = point;
    [self setNeedsDisplay];
}

/*
- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    UITouch* touchPoint = [touches anyObject];
    startPoint = [touchPoint locationInView:self];
    endPoint = [touchPoint locationInView:self];
    
    
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    endPoint=[touch locationInView:self];
    [self setNeedsDisplay];
}*/


@end
