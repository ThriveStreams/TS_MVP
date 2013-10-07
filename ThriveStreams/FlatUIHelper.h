//
//  FlatUIHelper.h
//  ThriveStreamsTest
//
//  Created by Ryan Badilla on 9/3/13.
//  Copyright (c) 2013 ThriveStreams. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlatUIHelper : NSObject

//
// Methods provided by
//https://github.com/Grouper/FlatUIKit
//
+ (UIImage *)imageWithColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadius;

+ (UIImage *) buttonImageWithColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadius shadowColor:(UIColor *)shadowColor shadowInsets:(UIEdgeInsets)shadowInsets;

+ (UIImage *) backButtonImageWithColor:(UIColor *)color barMetrics:(UIBarMetrics) metrics cornerRadius:(CGFloat)cornerRadius;

+ (UIBezierPath *) bezierPathForBackButtonInRect:(CGRect)rect cornerRadius:(CGFloat)radius;

+ (void) configureItemOrProxy:(id)appearance forFlatButtonWithColor:(UIColor *)color highlightedColor:(UIColor *)highlightedColor cornerRadius:(CGFloat) cornerRadius;



@end
