//
//  LoginViewController.m
//  Uptimal
//
//  Created by Ryan Badilla on 10/4/13.
//  Copyright (c) 2013 ThriveStreams. All rights reserved.
//

#import "LoginViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "FlatUIHelper.h"
#import <Parse/Parse.h>
#import "AppDelegate.h"
#import "MainViewController.h"
#import "MBProgressHUD.h"

@interface LoginViewController ()
{
    UITapGestureRecognizer *tapOutsideKeyboard;
}

@end

@implementation LoginViewController

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
    
    // set up core data and stackmob
 //   self.managedObjectContext = [[self.appDelegate coreDataStore] contextForCurrentThread];
 //   self.client = [SMClient defaultClient];
    
    // Set up colors
    //   NSString *fontName = @"OpenSans-Light";
    UIColor *greyColor = [UIColor colorWithRed:149.0/255 green:165.0/255 blue:166.0/255 alpha:1.0f];
 //   UIColor *navigationBarColor = [UIColor colorWithRed:189.0/255 green:195.0/255 blue:199.0/255 alpha:1.0];
    
    // setup the background color for the view
    [self.view setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:240.0/255.0 blue:241.0/255.0 alpha:1.0]];

    // Configure the navigation bar to a flat grey design and other stuff
  //  [self.navigationController.navigationBar setBackgroundImage:[FlatUIHelper imageWithColor:navigationBarColor cornerRadius:0] forBarMetrics:0];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:22.0/255.0 green:160.0/255.0 blue:133.0/255.0 alpha:1.0]];
    
    self.navigationController.navigationBar.topItem.title = @"Login";
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor colorWithWhite:0.4 alpha:1.0],
      UITextAttributeTextColor,
      [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0],
      UITextAttributeTextShadowColor,
      [NSValue valueWithUIOffset:UIOffsetMake(0, 0)],
      UITextAttributeTextShadowOffset,
      [UIFont fontWithName:@"OpenSans-Light" size:0.0],
      UITextAttributeFont,
      nil]];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Let's Do It!"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(loginUser:)];

    NSDictionary* rightBarButtonDictionaryDisabled = [NSDictionary dictionaryWithObjectsAndKeys: [UIColor colorWithRed:22.0/255.0 green:160.0/255.0 blue:133.0/255.0 alpha:0.3], UITextAttributeTextColor,
                                             [UIColor colorWithRed:149.0/255.0 green:165.0/255.0 blue:166.0/255.0 alpha:0.0], UITextAttributeTextShadowColor,
                                             [NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset,
                                             [UIFont fontWithName:@"OpenSans-Light" size:16.0], UITextAttributeFont,
                                             nil];
    NSDictionary* rightBarButtonDictionaryNormal = [NSDictionary dictionaryWithObjectsAndKeys: [UIColor colorWithRed:22.0/255.0 green:160.0/255.0 blue:133.0/255.0 alpha:1.0], UITextAttributeTextColor,
                                              [UIColor colorWithRed:149.0/255.0 green:165.0/255.0 blue:166.0/255.0 alpha:0.0], UITextAttributeTextShadowColor,
                                              [NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset,
                                              [UIFont fontWithName:@"OpenSans-Light" size:16.0], UITextAttributeFont,
                                              nil];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:rightBarButtonDictionaryNormal forState:UIControlStateNormal];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:rightBarButtonDictionaryDisabled forState:UIControlStateDisabled];
    
  //  [FlatUIHelper configureItemOrProxy:self.navigationItem.rightBarButtonItem forFlatButtonWithColor:navigationBarColor highlightedColor:greyColor cornerRadius:3];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(cancel:)];
    
    NSDictionary* leftBarButtonDictionary = [NSDictionary dictionaryWithObjectsAndKeys: [UIColor colorWithRed:149.0/255.0 green:165.0/255.0 blue:166.0/255.0 alpha:1.0], UITextAttributeTextColor,
     [UIColor colorWithRed:149.0/255.0 green:165.0/255.0 blue:166.0/255.0 alpha:0.0], UITextAttributeTextShadowColor,
     [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeTextShadowOffset,
     [UIFont fontWithName:@"OpenSans-Light" size:16.0], UITextAttributeFont,
     nil];
    
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:leftBarButtonDictionary forState:UIControlStateNormal];
    
  // [FlatUIHelper configureItemOrProxy:self.navigationItem.leftBarButtonItem forFlatButtonWithColor:navigationBarColor highlightedColor:greyColor cornerRadius:3];
    
    [self enableLoginButton];
    
    // Configure the text fields to make them look pretty
    self.emailField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    self.emailField.layer.cornerRadius = 3.0f;
    self.emailField.placeholder = @"Email Address";
    self.emailField.leftViewMode = UITextFieldViewModeAlways;
    self.emailField.font = [UIFont fontWithName:@"OpenSans-Light" size:14.0f];
    UIView* leftView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    self.emailField.leftView = leftView1;
    self.emailField.delegate = self;
    
    self.passwordField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    self.passwordField.layer.cornerRadius = 3.0f;
    self.passwordField.placeholder = @"Password";
    self.passwordField.font = [UIFont fontWithName:@"OpenSans-Light" size:14.0f];
    self.passwordField.leftViewMode = UITextFieldViewModeAlways;
    UIView* leftView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    self.passwordField.leftView = leftView2;
    self.passwordField.delegate = self;
    
    // Configure the forgotbutton to look like normal text
    self.forgotButton.backgroundColor = [UIColor clearColor];
    [self.forgotButton setTitle:@"Forgot Your Details?" forState:UIControlStateNormal];
    [self.forgotButton.titleLabel setFont:[UIFont fontWithName:@"OpenSans-Light" size:11.0f]];
    [self.forgotButton setTitleColor:greyColor forState:UIControlStateNormal];
    [self.forgotButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    
    //initialize tap gesture to remove keyboard
    tapOutsideKeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapRemoveKeyboard:)];
    tapOutsideKeyboard.cancelsTouchesInView = FALSE;
    [self.view addGestureRecognizer:tapOutsideKeyboard];
}

#pragma mark - removeKeyboard method
-(void)singleTapRemoveKeyboard:(UITapGestureRecognizer *)sender
{
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegates

-(void)enableLoginButton
{
    if ((self.passwordField.text.length > 0) &&
        (self.emailField.text.length > 0))
    {
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    }
    else
    {
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    }
}


-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    //check if all fields having something and set bar button to enabled
    if (![self.passwordField.text isEqualToString:@""] &&
        ![self.emailField.text isEqualToString:@""])
    {
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    }
    
    // last text field to be edited is password field
    else if ((_emailField.text.length > 0) &&
        (_passwordField.text.length <= 0))
    {
        [_emailField setReturnKeyType:UIReturnKeyNext];
        [_passwordField setReturnKeyType:UIReturnKeyDone];
    }
    
    // last text field to be edited is the email field
    else if ((_emailField.text.length <= 0) &&
             (_passwordField.text.length > 0))
    {
        [_emailField setReturnKeyType:UIReturnKeyDone];
        [_passwordField setReturnKeyType:UIReturnKeyNext];
    }
    
    [self enableLoginButton];
    
    return YES;
}

// Delegate for text to set up done button
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.returnKeyType == UIReturnKeyDone)
    {
        [self.view endEditing:YES];
    }
    else if (textField == _emailField && textField.returnKeyType != UIReturnKeyDone)
    {
        [_passwordField becomeFirstResponder];
    }
    else if (textField == _passwordField && textField.returnKeyType != UIReturnKeyDone)
    {
        [_emailField becomeFirstResponder];
    }
    
    return YES;
}


#pragma mark - IBActions for Navigation Bar

- (IBAction)loginUser:(id)sender
{
    [PFUser logInWithUsernameInBackground:_emailField.text password:_passwordField.text
                                    block:^(PFUser *user, NSError *error) {
            if (user) {
            // Do stuff after successful login.
            [self performSegueWithIdentifier:@"toMainSegueFromLogin" sender:self];
            } else {
            // The login failed. Check error to see why.
                NSString *errorString = [error userInfo][@"error"];
                UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Oh no!" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [errorAlertView show];
            }
            }];
}

// Cancel the current view
- (IBAction)cancel:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - IBActions for forgotPassword

-(IBAction)forgotPassword:(id)sender
{
    [self performSegueWithIdentifier:@"toMainSegueFromLogin" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - prepare for Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *firstname = [[PFUser currentUser] objectForKey:@"firstName"];
    NSString *lastname = [[PFUser currentUser] objectForKey:@"lastName"];
    PFFile *image = [[PFUser currentUser] objectForKey:@"profileImage"];
    UIImage *profileImage = [UIImage imageWithData:[image getData]];
    
    UINavigationController *navigationController = segue.destinationViewController;
    MainViewController *controller =(MainViewController *)navigationController.topViewController;
    controller.firstname = firstname;
    controller.lastname = lastname;
    controller.profileImage = profileImage;
}

@end
