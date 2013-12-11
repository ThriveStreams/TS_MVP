//
//  ArrowView.h
//  Uptimal
//
//  Created by Ryan Badilla on 11/12/13.
//  Copyright (c) 2013 ThriveStreams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArrowView : UIView

- (void)setEndPoint:(CGPoint)point;
- (CGPoint)startPoint;
- (CGPoint)endPoint;

@end
