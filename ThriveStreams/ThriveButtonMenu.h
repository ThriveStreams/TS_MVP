//
//  ThriveButtonMenu.h
//  ThriveStreamsTest
//
//  Created by Ryan Badilla on 9/9/13.
//  Copyright (c) 2013 ThriveStreams. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThriveButton.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define THRIVEMENU_DEFAULT_SUPERVIEW_CGRECT CGRectMake(([[UIScreen mainScreen] bounds].size.width/2) - 25, [[UIScreen mainScreen] bounds].size.height - 80, 50, 50)

// hasn't been tested on views that are not full screen view controllers
//#define THRIVEMENU_DEFAULT_SUPERVIEW_CGECT (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") ? CGRectMake(CGRectGetMidX(self.view.bounds) - 25, self.view.bounds.size.height - 100 , 50, 50) : CGRectMake(CGRectGetMidX(self.view.bounds) - 25, self.view.bounds.size.height - 120 , 50, 50))

@interface ThriveButtonMenu : UIView <UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSMutableArray *subButtons;
@property (nonatomic, strong) ThriveButton *mainButton;
@property (retain, nonatomic) UIViewController *parent;

//- (id)initWithFrame:(CGRect)frame parent:(UIViewController *)parentView mainButton:(ThriveButton *)mainButton subButtons:(NSMutableArray *)subButtons;

- (id)initWithFrame:(CGRect)frame parent:(UIViewController *)parentView mainButton:(ThriveButton *)mainButton subButtons:(id)arg1,...;


- (id)initWithFrame:(CGRect)frame mainButtonMainIcon:(UIImage *)mainButtonMainIcon mainButtonSubIcon:(UIImage *)MainButtonSubIcon mainButtonBorderColor:(UIColor *)mainButtonBorderColor mainButtonFillColor:(UIColor *)mainButtonFillColor subButtonIcons:(NSArray *)subButtonIcons subButtonBorderColors:(NSArray *)subButtonBorderColors subButtonFillColors:(NSArray *)subButtonFillColors parentView:(UIViewController *)parentView withViewControllers:(NSArray *)viewControllers;

-(void)setUpSubMenuPositions;

@end
