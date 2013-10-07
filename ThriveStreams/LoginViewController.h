//
//  LoginViewController.h
//  ThriveStreams
//
//  Created by Ryan Badilla on 10/4/13.
//  Copyright (c) 2013 ThriveStreams. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SMClient;

@interface LoginViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, weak) IBOutlet UITextField *emailField;
@property (nonatomic, weak) IBOutlet UITextField *passwordField;
@property (nonatomic, weak) IBOutlet UIButton *forgotButton;

@property (strong, nonatomic) SMClient *client;

-(IBAction)loginUser:(id)sender;
-(IBAction)cancel:(id)sender;

@end
