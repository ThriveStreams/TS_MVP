//
//  ThriveButton.m
//  ThriveStreamsTest
//
//
//  Created by Ryan Badilla on 9/8/13.
//  Copyright (c) 2013 ThriveStreams. All rights reserved.
//

#import "ThriveButton.h"

@interface ThriveButton ()

@property (nonatomic, strong) UIImageView *imageView;
@property BOOL isAnimating;
@property ThriveButtonType type;
@property (nonatomic, strong) CustomCode customCode;
@end

@implementation ThriveButton

#pragma mark - Initializations

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //set view to rounded
        [self setViewToRounded:frame.size.width];
        
        //set colors to default ThriveColor
        _fillColor = [UIColor colorWithRed:236.0/255 green:240.0/255 blue:241.0/255 alpha:1.0];
        _borderColor = [UIColor colorWithRed:149.0/255 green:165.0/255 blue:166.0/255 alpha:1.0];        
        
        //add gesture recognizer
        UITapGestureRecognizer *singleFingerTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        [self addGestureRecognizer:singleFingerTap];
        
    }
    return self;
}

- (id)initAsMainButtonWithFrame:(CGRect)frame iconImage:(UIImage *)image subIconImage:(UIImage *)subImage borderColor:(UIColor *)border fillColor:(UIColor *)fill
{
    self = [super initWithFrame:frame];
    if (self) {
        //set view to rounded
        [self setViewToRounded:frame.size.width];
        
        // set variables
        _fillColor = fill;
        _borderColor = border;
        _state = ThriveButtonStateDisengaged;
        _isEnabled = NO;
        _isAnimating = NO;
        _mainIcon = image;
        _subIcon = subImage;
        _type = ThriveButtonMain;
        _originalPosition = CGPointMake(self.frame.origin.x, self.frame.origin.y);
        _moveToPosition = _originalPosition;
        
        //add an imageview that is .65 size of thriveButtonView and center it
        CGRect imageRect = CGRectMake(0, 0, frame.size.width *.65, frame.size.height *.65);
        _imageView = [[UIImageView alloc] initWithFrame:imageRect];
        [_imageView setImage:image];
        [_imageView setContentMode:UIViewContentModeScaleAspectFit];
        _imageView.center = CGPointMake(CGRectGetMidX([self bounds]), CGRectGetMidY([self bounds]));
        _imageView.alpha = 0.8;
        [self addSubview:_imageView];
        
        //default rotation is clockwise
        _rotationDirection = clockwise;
        _customCode = ^{ };
    
    }
    return self;
}

- (id)initAsSubButtonWithFrame:(CGRect)frame iconImage:(UIImage *)image borderColor:(UIColor *)border fillColor:(UIColor *)fill withView:(UIViewController *)viewController
{
    if (self = [self initAsMainButtonWithFrame:frame iconImage:image subIconImage:nil borderColor:border fillColor:fill])
    {
        _type = ThriveButtonSub;
        _rotationDirection = counterclockwise;
        self.hidden = YES;
        self.alpha = 0.0;
        _viewController = viewController;
    }
    return self;
}

- (id)initAsSubButtonWithFrame:(CGRect)frame iconImage:(UIImage *)image borderColor:(UIColor *)border fillColor:(UIColor *)fill withBlock:(CustomCode)blockCode
{
    if (self = [self initAsMainButtonWithFrame:frame iconImage:image subIconImage:nil borderColor:border fillColor:fill])
    {
        _type = ThriveButtonSub;
        _rotationDirection = counterclockwise;
        self.hidden = YES;
        self.alpha = 0.0;
   //     _viewController = viewController;
        _customCode = blockCode;
    }
    return self;
}

-(BOOL)isInViewCircle:(CGPoint)point
{
    // check if the user even touched the button in the circle area using complex mathematical craziness (just basic trig)
    CGFloat radiusX = powf((CGRectGetMidX([self bounds]) - (CGFloat)self.frame.size.width), 2);
    CGFloat radiusY = powf((CGRectGetMidY([self bounds]) - (CGFloat)self.frame.size.height/2), 2);
    CGFloat radius = sqrtf(radiusX + radiusY);
    
    CGFloat touchPointX = powf((CGRectGetMidX([self bounds]) - point.x), 2);
    CGFloat touchPointY = powf((CGRectGetMidY([self bounds]) - point.y), 2);
    CGFloat touchPoint = sqrtf(touchPointX + touchPointY);
    
    if (touchPoint <= radius)
        return YES;
    else
        return NO;
}

-(BOOL)isInMoveToAreaSquare:(CGPoint)point
{
    if (_type == ThriveButtonSub)
    {
        CGFloat moveAreaX = self.moveToPosition.x + self.frame.size.width;
        CGFloat moveAreaY = self.moveToPosition.y + self.frame.size.height;
        
        if (point.x <= moveAreaX && point.y <= moveAreaY)
            return YES;
        else
            return NO;
    }
    else
        return NO;
}

-(BOOL)isInMoveToAreaCircle:(CGPoint)point
{
    if (_type == ThriveButtonSub)
    {
        
        CGFloat radiusX = powf((CGRectGetMidX([self bounds]) - (CGFloat)self.frame.size.width), 2);
        CGFloat radiusY = powf((CGRectGetMidY([self bounds]) - (CGFloat)self.frame.size.height/2), 2);
        CGFloat radius = sqrtf(radiusX + radiusY);
        
        CGRect rect = CGRectMake(self.moveToPosition.x, self.moveToPosition.y, self.frame.size.width, self.frame.size.height);
        
        CGFloat touchPointX = powf((CGRectGetMidX(rect) - point.x), 2);
        CGFloat touchPointY = powf((CGRectGetMidY(rect) - point.y), 2);
        CGFloat touchPoint = sqrtf(touchPointX + touchPointY);
        
        if (touchPoint <= radius)
            return YES;
        else
            return NO;
        
    }
    else
        return NO;
}

#pragma mark - gesture recognizer for mainButton

-(void)handleTapGesture:(UITapGestureRecognizer *)gesture
{
    CGPoint touchLocation = [gesture locationInView:self];
    [self handleTapGestureWithLocation:gesture withLocation:touchLocation];
}

- (void)handleTapGestureWithLocation:(UITapGestureRecognizer *)gesture withLocation:(CGPoint)touchLocation
{
    // Its the main Thrive Button
    if (_type == ThriveButtonMain)
    {
        if (self.state == ThriveButtonStateDisengaged)
        {
            [self rotate:_rotationDirection forDuration:.4 option:UIViewAnimationOptionAllowAnimatedContent];
        }
        else if (self.state == ThriveButtonStateEngaged)
        {
            Rotation newDirection;
            
            if (_rotationDirection == clockwise)
                newDirection = counterclockwise;
            else
                newDirection = clockwise;
                
            [self rotate:counterclockwise forDuration:.4 option:UIViewAnimationOptionAllowAnimatedContent];
        }
    }
}

#pragma mark - gesture recognizers for subbutton
-(void)handleTapGestureSubButton:(UITapGestureRecognizer *)gesture
{
    if (_type == ThriveButtonSub)
    {
        if (self.state == ThriveButtonStateDisengaged)
        {
            self.hidden = NO;
            
            [self rotate:_rotationDirection forDuration:.4 option:UIViewAnimationOptionAllowAnimatedContent];
            
        }
        else if (self.state == ThriveButtonStateEngaged)
        {
            Rotation newDirection;
            
            if (_rotationDirection == clockwise)
                newDirection = counterclockwise;
            else
                newDirection = clockwise;
            
            [self rotate:newDirection forDuration:.4 option:UIViewAnimationOptionAllowAnimatedContent];
        }
    }
}


#pragma mark - ThriveButtonAnimations

-(void)rotate:(Rotation)rotation forDuration:(float)duration option:(UIViewAnimationOptions)option
{
    if (!_isAnimating)
    {
        CGFloat startTime = 0.0;
        CGFloat rotateDirection = 0.0;
        
        if (rotation == clockwise)
        {
            rotateDirection = M_PI / 2;
        }
        else
        {
            rotateDirection = -M_PI / 2;
        }
    
        // ----
        // Rotation animation
        // ----
        CABasicAnimation* rotateView =  [CABasicAnimation animationWithKeyPath: @"transform.rotation.z"];
        rotateView.removedOnCompletion = FALSE;
        rotateView.fillMode = kCAFillModeForwards;
    
        //Do a series of 4 quarter turns for a total of a 1 turn
        [rotateView setToValue: [NSNumber numberWithFloat: rotateDirection]];
        rotateView.repeatCount = 4;
    
        rotateView.duration = duration/4;
        rotateView.beginTime = startTime;
        rotateView.cumulative = TRUE;
        rotateView.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        [rotateView setDelegate:self];
        [rotateView setValue:@"rotateAnimation" forKey:@"animationName"];
    
        [self.layer addAnimation:rotateView forKey:nil];
    }
}

-(void)changeIconImage:(UIImage *)iconImage forDuration:(float)duration
{
    [UIView transitionWithView:self
                      duration:duration
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        self.imageView.image = iconImage;
                    } completion:nil];
}

-(void)moveTo:(CGPoint)destination forDuration:(NSInteger)duration option:(UIViewAnimationOptions)option
{
    [UIView animateWithDuration:.4 delay:0.0 options:option
                     animations:^{
                         self.frame = CGRectMake(destination.x,destination.y, self.frame.size.width, self.frame.size.height);
                         if (_state == ThriveButtonStateDisengaged)
                         {
                             self.alpha = .8;
                         }
                         else if (_state == ThriveButtonStateEngaged)
                         {
                             self.alpha = 0.0;
                         }
                     }
                     completion:nil];
}

-(void)setSubIconImage:(UIImage *)subIconImage
{
    _subIcon = subIconImage;
}

-(UIViewController *)returnViewController
{
    return _viewController;
}

#pragma mark - Animation delegates

-(void)animationDidStart:(CAAnimation *)anim
{
    _isAnimating = YES;
    if ([[anim valueForKey:@"animationName"] isEqualToString:@"rotateAnimation"] && _type == ThriveButtonMain)
    {
        if (_state == ThriveButtonStateEngaged)
        {
            [self changeIconImage:_mainIcon forDuration:0.4];
        }
        else if (_state == ThriveButtonStateDisengaged)
        {
            [self changeIconImage:_subIcon forDuration:0.4];
        }
    }
    else if ([[anim valueForKey:@"animationName"] isEqualToString:@"rotateAnimation"] && _type == ThriveButtonSub)
    {
     //   CGPoint point = CGPointMake(self.frame.origin.x, self.frame.origin.y - 75.0);
        if (_state == ThriveButtonStateDisengaged)
        {
            [self moveTo:_moveToPosition forDuration:0.4 option:UIViewAnimationOptionCurveLinear];
        }
        else if (_state == ThriveButtonStateEngaged)
        {
            [self moveTo:_originalPosition forDuration:0.4 option:UIViewAnimationOptionCurveLinear];
        }
    }
    
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag)
    {
        _isAnimating = NO;
        if (_state == ThriveButtonStateEngaged)
        {
            _state = ThriveButtonStateDisengaged;
            if (_type == ThriveButtonSub)
                self.hidden = YES;
        }
        else
            _state = ThriveButtonStateEngaged;
    }
}

#pragma mark - setVariables

-(void)setFillColor:(UIColor *)fillColor
{
    _fillColor = fillColor;
}

-(void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
}

-(void)setThriveIcon:(UIImage *)icon
{
    //safety check
    if (_imageView != NULL)
    {
        _thriveButtonIcon = icon;
    }
}

-(BOOL)setEnabled:(BOOL)enable
{
    _isEnabled = &enable;
    
    return *(_isEnabled);
}

-(void)setMoveToPos:(CGPoint)moveToPosition
{
    self.moveToPosition = moveToPosition;
}

- (void)setViewToRounded:(CGFloat)diameter
{
    [self.layer setCornerRadius:diameter/2];
    [self setAlpha:0.8];
    [self setClipsToBounds:YES];
    [self setBackgroundColor:[UIColor clearColor]];
}

// Set stuff to default
- (void)reset
{
    [self setNeedsDisplay];
    _isAnimating = NO;
    _state = ThriveButtonStateDisengaged;
}

#pragma mark - blockCode

-(void)setBlockCode:(CustomCode)code
{
    _customCode = code;
}

- (CustomCode)returnBlockCode
{
    return _customCode;
}

- (void)executeBlockCode
{
    _customCode();
}

#pragma mark - drawRect

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
//    NSLog(@"Rect Data for drawRect: %f %f %f %f", rect.origin.x, rect.origin.y, rect.size.height, rect.size.width);
    CGFloat lineWidth = 4.0;
    CGRect borderRect = CGRectInset(rect, lineWidth * 0.5, lineWidth * 0.5);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [_borderColor CGColor]);
    CGContextSetFillColorWithColor(context, [_fillColor CGColor]);
    CGContextSetLineWidth(context, 4.0);
    CGContextFillEllipseInRect (context, borderRect);
    CGContextStrokeEllipseInRect(context, borderRect);
    CGContextFillPath(context);
} 


@end
