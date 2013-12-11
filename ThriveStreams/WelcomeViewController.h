//
//  WelcomeViewController.h
//  ThriveStreams
//
//  Created by Ryan Badilla on 10/4/13.
//  Copyright (c) 2013 ThriveStreams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WelcomeViewController : UIViewController <NSURLConnectionDataDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicatorFacebook;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicatorTwitter;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *joinButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIButton *twitterButton;

@property (weak, nonatomic) IBOutlet UILabel *steps;

@property (nonatomic, strong) NSMutableData *mutableData;

- (IBAction)loginWithFacebook:(id)sender;
- (IBAction)loginWithTwitter:(id)sender;

@end
