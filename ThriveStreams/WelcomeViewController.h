//
//  SplashViewController.h
//  ThriveStreams
//
//  Created by Ryan Badilla on 10/4/13.
//  Copyright (c) 2013 ThriveStreams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WelcomeViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *joinButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;

@property (nonatomic, strong) IBOutlet UITextView* testLabel;
@property (nonatomic, strong) IBOutlet UITextView* test2Label;

- (IBAction)loginWithFacebook:(id)sender;

@property (nonatomic, strong) IBOutlet UIButton *deployButton;
- (IBAction)deployStuff:(id)sender;

@end
