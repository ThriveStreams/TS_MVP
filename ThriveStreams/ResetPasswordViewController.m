//
//  ResetPasswordViewController.m
//  Uptimal
//
//  Created by Ryan Badilla on 11/19/13.
//  Copyright (c) 2013 ThriveStreams. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import <Parse/Parse.h>

@interface ResetPasswordViewController ()

@end

@implementation ResetPasswordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //set up navigation bar
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithWhite:0.6 alpha:0.9]];
    self.navigationItem.title = @"Reset Password";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    
    // setup the background color for the view
    [self.view setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:240.0/255.0 blue:241.0/255.0 alpha:1.0]];
    
    // setup Email field 
    self.emailField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    self.emailField.layer.cornerRadius = 3.0f;
    self.emailField.placeholder = @"Email Address";
    self.emailField.leftViewMode = UITextFieldViewModeAlways;
    self.emailField.font = [UIFont fontWithName:@"OpenSans-Light" size:14.0f];
    UIView* leftView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    self.emailField.leftView = leftView1;
    self.emailField.delegate = self;

}

-(IBAction)done:(id)sender
{
    if (_emailField.text.length <= 0)
    {
        UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"No Email"
                                                       message:@"Please enter in your email."delegate:self
                                             cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [view show];
        return;
    }
    else
    {
        [PFUser requestPasswordResetForEmailInBackground:_emailField.text];
        UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"Request Sent"
                                                       message:@"Please enter in your email."delegate:self
                                             cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [view show];
    }
}

-(IBAction)cancel:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.title isEqualToString:@"Request Sent"])
    {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
