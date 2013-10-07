//
//  ThriveButtonMenu.m
//  ThriveStreamsTest
//
//  Created by Ryan Badilla on 9/9/13.
//  Copyright (c) 2013 ThriveStreams. All rights reserved.
//

#import "ThriveButtonMenu.h"
#import "ThriveButton.h"
#import <QuartzCore/QuartzCore.h>



@interface ThriveButtonMenu ()

@property CGPoint touchedPoint;

@end


@implementation ThriveButtonMenu


#pragma mark - initialization

// inits with default ThriveButton main and thats it
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIColor *fillColor = [UIColor colorWithRed:236.0/255 green:240.0/255 blue:241.0/255 alpha:1.0];
        UIColor *borderColor = [UIColor colorWithRed:149.0/255 green:165.0/255 blue:166.0/255 alpha:1.0];
        UIImage *icon = [UIImage imageNamed:@"thriveButtonIcon.png"];
        UIImage *iconSub = [UIImage imageNamed:@"Xbutton.png"];
        
        
        _mainButton = [[ThriveButton alloc] initAsMainButtonWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) iconImage:icon subIconImage:iconSub borderColor:borderColor fillColor:fillColor];

        _subButtons = [[NSMutableArray alloc] init];
        
        //add gesture recognizer
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        tapGesture.delegate = self;
        
        
        [self addGestureRecognizer:tapGesture];
        [self addSubview:_mainButton];
        
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame parent:(UIViewController *)parentView mainButton:(ThriveButton *)mainButton subButtons:(id)arg1,...
{
    if (self = [super initWithFrame:frame])
    {
        //auto set original positions to 0 and whatevs
        _mainButton = mainButton;
        _subButtons = [[NSMutableArray alloc] initWithArray:nil];

        //setup subButtons
        id eachObject;
        va_list argumentList;
        if (arg1)
        {
            [self.subButtons addObject:arg1];
            va_start(argumentList, arg1);
            while ((eachObject = va_arg(argumentList, id)))
            {
                [self.subButtons addObject:eachObject];
                [(ThriveButton *)eachObject setOriginalPosition:CGPointMake(0, 0)];
            }
            va_end(argumentList);
        }
        //setup mainButton
        _mainButton.originalPosition = CGPointMake(0, 0);
        [_mainButton reset];
        [self setUpSubMenuPositions];
        [self addSubview:_mainButton];
        
        for (int index = 0; index < [_subButtons count]; index++)
        {
            
            [self addSubview:[_subButtons objectAtIndex:index]];
        }
        
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        tapGesture.delegate = self;
        
        self.parent = parentView;
        
        [self addGestureRecognizer:tapGesture];

    }
    return self;
}


- (id)initWithFrame:(CGRect)frame mainButtonMainIcon:(UIImage *)mainButtonMainIcon mainButtonSubIcon:(UIImage *)MainButtonSubIcon mainButtonBorderColor:(UIColor *)mainButtonBorderColor mainButtonFillColor:(UIColor *)mainButtonFillColor subButtonIcons:(NSArray *)subButtonIcons subButtonBorderColors:(NSArray *)subButtonBorderColors subButtonFillColors:(NSArray *)subButtonFillColors parentView:(UIViewController *)parentView withViewControllers:(NSArray *)viewControllers
{
    if (self = [super initWithFrame:frame])
    {
        _mainButton = [[ThriveButton alloc] initAsMainButtonWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) iconImage:mainButtonMainIcon subIconImage:MainButtonSubIcon borderColor:mainButtonBorderColor fillColor:mainButtonFillColor];
        
        
        _subButtons = [[NSMutableArray alloc] initWithCapacity:[subButtonBorderColors count]];
        
        // ensure that there are a same amount of subButtonBorderColors and subButtonFillColors
        if ([subButtonBorderColors count] == [subButtonFillColors count])
        {
            for (int index = 0; index < [subButtonFillColors count]; index++)
            {
                ThriveButton *btn = [[ThriveButton alloc] initAsSubButtonWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) iconImage:[subButtonIcons objectAtIndex:index] borderColor:[subButtonBorderColors objectAtIndex:index] fillColor:[subButtonFillColors objectAtIndex:index] withView:[viewControllers objectAtIndex:index]];
                
                [_subButtons addObject:btn];
            }
        }
        //add gesture recognizer
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        tapGesture.delegate = self;
        
        [self addGestureRecognizer:tapGesture];
        [self addSubview:_mainButton];
        [self setUpSubMenuPositions];
        
        self.parent = parentView;
        
        for (int index = 0; index < [_subButtons count]; index++)
            [self addSubview:[_subButtons objectAtIndex:index]];
    }
    
    return self;
}


#pragma mark - gesture recognizer

-(void)doAnimation:(UITapGestureRecognizer *)gesture
{
    [_mainButton handleTapGesture:gesture];
    
    for(int index = 0; index < [_subButtons count]; index++)
    {
        ThriveButton *btn = [_subButtons objectAtIndex:index];
        [btn handleTapGestureSubButton:gesture];
    }
}

-(void)handleTapGesture:(UITapGestureRecognizer *)gesture
{
    if ([_mainButton isInViewCircle:_touchedPoint])
    {
    /*    [_mainButton handleTapGesture:gesture];
    
        for(int index = 0; index < [_subButtons count]; index++)
        {
            ThriveButton *btn = [_subButtons objectAtIndex:index];
            [btn handleTapGestureSubButton:gesture];
        } */
        [self doAnimation:gesture];
    }
    for(int index = 0; index < [_subButtons count]; index++)
    {
       ThriveButton *btn = [_subButtons objectAtIndex:index];
      //  [btn handleTapGestureSubButton:gesture];
        
  //      NSLog(@"CGPointTouch: %f, %f", _touchedPoint.x, _touchedPoint.y);
        
        if ([btn isInMoveToAreaCircle:_touchedPoint])
        {
           /* [_mainButton handleTapGesture:gesture];
            
            //added stuff
            for(int index = 0; index < [_subButtons count]; index++)
            {
                ThriveButton *btn1 = [_subButtons objectAtIndex:index];
                [btn1 handleTapGestureSubButton:gesture];
            } */
            [self doAnimation:gesture];
            
            if ([btn returnViewController] != nil)
                [_parent presentViewController:[btn returnViewController] animated:YES completion:nil];
            else
            {
                [btn executeBlockCode];
            }
        }
    }
}

-(void) setUpSubMenuPositions
{
    if ([_subButtons count] == 1)
    {
        ThriveButton *btn = [_subButtons objectAtIndex:0];
        CGPoint point = CGPointMake(btn.frame.origin.x, btn.frame.origin.y - 75.0);
        [btn setMoveToPosition:point];
    }
    else if ([_subButtons count] == 2)
    {
        ThriveButton *btn1 = [_subButtons objectAtIndex:0];
        ThriveButton *btn2 = [_subButtons objectAtIndex:1];
        CGPoint point1 = CGPointMake(btn1.frame.origin.x - 50, btn1.frame.origin.y - 75.0);
        CGPoint point2 = CGPointMake(btn2.frame.origin.x + 50, btn2.frame.origin.y - 75.0);
            
        [btn1 setMoveToPosition:point1];
        [btn2 setMoveToPosition:point2];
            
    }
    else if ([_subButtons count] == 3)
    {
        ThriveButton *btn1 = [_subButtons objectAtIndex:0];
        ThriveButton *btn2 = [_subButtons objectAtIndex:1];
        ThriveButton *btn3 = [_subButtons objectAtIndex:2];
            
        CGPoint point1 = CGPointMake(btn1.frame.origin.x - 75.0, btn1.frame.origin.y - 55.0);
        CGPoint point2 = CGPointMake(btn2.frame.origin.x, btn2.frame.origin.y - 75.0);
        CGPoint point3 = CGPointMake(btn3.frame.origin.x + 75.0, btn3.frame.origin.y - 55.0);
            
        [btn1 setMoveToPosition:point1];
        [btn2 setMoveToPosition:point2];
        [btn3 setMoveToPosition:point3];
    }
    else if ([_subButtons count] == 4)
    {
        ThriveButton *btn1 = [_subButtons objectAtIndex:0];
        ThriveButton *btn2 = [_subButtons objectAtIndex:1];
        ThriveButton *btn3 = [_subButtons objectAtIndex:2];
        ThriveButton *btn4 = [_subButtons objectAtIndex:3];
            
        CGPoint point1 = CGPointMake(btn1.frame.origin.x - 100, btn1.frame.origin.y - 10.0);
        CGPoint point2 = CGPointMake(btn2.frame.origin.x - 50, btn2.frame.origin.y - 75.0);
        CGPoint point3 = CGPointMake(btn3.frame.origin.x + 50, btn3.frame.origin.y - 75.0);
        CGPoint point4 = CGPointMake(btn4.frame.origin.x + 100, btn4.frame.origin.y - 10.0);
            
        [btn1 setMoveToPosition:point1];
        [btn2 setMoveToPosition:point2];
        [btn3 setMoveToPosition:point3];
        [btn4 setMoveToPosition:point4];
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    NSEnumerator *reverseE = [self.subviews reverseObjectEnumerator];
    UIView *iSubView;
    
    while ((iSubView = [reverseE nextObject])) {
        
        UIView *viewWasHit = [iSubView hitTest:[self convertPoint:point toView:iSubView] withEvent:event];
        if(viewWasHit) {
      //      NSLog(@"hit test sub %@", viewWasHit);
            _touchedPoint = point;
            return viewWasHit;
        }
        
    }
    return [super hitTest:point withEvent:event];
} 


@end
