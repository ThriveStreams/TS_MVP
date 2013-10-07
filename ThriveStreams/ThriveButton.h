//
//  ThriveButton.h
//  ThriveStreamsTest
//
//  Created by Ryan Badilla on 9/8/13.
//  Copyright (c) 2013 ThriveStreams. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


// predefined colors and rect
#define THRIVE_BUTTON_RECT_DEFAULT CGRectMake(0, 0, 50, 50)
#define BUTTON_GOAL_RED [UIColor colorWithRed:231.0/255 green:76.0/255 blue:60.0/255 alpha:1.0]
#define BUTTON_STEP_GREEN [UIColor colorWithRed:46.0/255 green:204.0/255 blue:113.0/255 alpha:1.0]
#define BUTTON_THRIVE_FILL [UIColor colorWithRed:236.0/255 green:240.0/255 blue:241.0/255 alpha:1.0]
#define BUTTON_THRIVE_BORDER [UIColor colorWithRed:149.0/255 green:165.0/255 blue:166.0/255 alpha:1.0]


@interface ThriveButton : UIView <UIGestureRecognizerDelegate>

typedef void(^CustomCode)(void);

typedef NS_ENUM(NSInteger, ThriveButtonState) {
    ThriveButtonStateEngaged,
    ThriveButtonStateDisengaged
};

typedef NS_ENUM(NSInteger, ThriveButtonType) {
    ThriveButtonMain,
    ThriveButtonSub
};

typedef NS_ENUM(NSInteger, Rotation) {
    clockwise,
    counterclockwise
};

@property BOOL *isEnabled;
@property ThriveButtonState state;
@property (nonatomic, strong) UIImage *thriveButtonIcon;
@property (nonatomic, strong) UIColor *fillColor;
@property (nonatomic, strong) UIColor *borderColor;

@property (nonatomic, strong) UIImage *mainIcon;
@property (nonatomic, strong) UIImage *subIcon;
@property UIViewController *viewController;

@property CGPoint originalPosition;
@property CGPoint moveToPosition;
@property Rotation rotationDirection;


- (id)initAsMainButtonWithFrame:(CGRect)frame iconImage:(UIImage *)image subIconImage:(UIImage *)subImage borderColor:(UIColor *)border fillColor:(UIColor *)fill;

//- (id)initAsSubButtonWithFrame:(CGRect)frame iconImage:(UIImage *)image borderColor:(UIColor *)border fillColor:(UIColor *)fill;

- (id)initAsSubButtonWithFrame:(CGRect)frame iconImage:(UIImage *)image borderColor:(UIColor *)border fillColor:(UIColor *)fill withBlock:(CustomCode)blockCode;

- (id)initAsSubButtonWithFrame:(CGRect)frame iconImage:(UIImage *)image borderColor:(UIColor *)border fillColor:(UIColor *)fill withView:(UIViewController *)viewController;

- (void)handleTapGesture:(UITapGestureRecognizer *)gesture;
- (void)handleTapGestureWithLocation:(UITapGestureRecognizer *)gesture withLocation:(CGPoint)touchLocation;
- (void)handleTapGestureSubButton:(UITapGestureRecognizer *)gesture;
-(BOOL)setEnabled:(BOOL)enable;
-(void)setState:(ThriveButtonState)state;
-(void)setThriveIcon:(UIImage *)icon;
-(void)setFillColor:(UIColor *)fillColor;
-(void)setBorderColor:(UIColor *)fillColor;
-(void)setSubIconImage:(UIImage *)subIconImage;
-(BOOL)isInMoveToAreaSquare:(CGPoint)point;
-(BOOL)isInViewCircle:(CGPoint)point;
-(BOOL)isInMoveToAreaCircle:(CGPoint)point;
-(UIViewController *)returnViewController;
- (CustomCode)returnBlockCode;
- (void)executeBlockCode;
-(void)reset;

//animation functions
-(void)rotate:(Rotation)rotation forDuration:(float)duration option:(UIViewAnimationOptions)option;
-(void)moveTo:(CGPoint)destination forDuration:(NSInteger)duration option:(UIViewAnimationOptions)option;

@end
