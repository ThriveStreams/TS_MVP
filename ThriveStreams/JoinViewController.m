//
//  JoinViewController.m
//  Uptimal
//
//  Created by Ryan Badilla on 10/4/13.
//  Copyright (c) 2013 ThriveStreams. All rights reserved.
//

#import "JoinViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "FlatUIHelper.h"
#import <Parse/Parse.h>
#import "MBProgressHUD.h"
#import "MainViewController.h"

@interface JoinViewController ()
{
    UITapGestureRecognizer *tapOutsideKeyboard;
}

@end

@implementation JoinViewController

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
    
    // Setup stackmob and core data
//    self.managedObjectContext = [[self.appDelegate coreDataStore] contextForCurrentThread];
//    self.client = [SMClient defaultClient];
    
    // setup the background color for the view
    [self.view setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:240.0/255.0 blue:241.0/255.0 alpha:1.0]];
    
    // Color and font stuff
  //  UIColor *greyColor = [UIColor colorWithRed:149.0/255 green:165.0/255 blue:166.0/255 alpha:1.0f];
 //   UIColor *navigationBarColor = [UIColor colorWithRed:189.0/255 green:195.0/255 blue:199.0/255 alpha:1.0];
    
    // Configure the navigation bar to a flat grey design and other stuff
  //  [self.navigationController.navigationBar setBackgroundImage:[FlatUIHelper imageWithColor:navigationBarColor cornerRadius:0] forBarMetrics:UIBarMetricsDefault];
    
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
    
    
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:22.0/255.0 green:160.0/255.0 blue:133.0/255.0 alpha:1.0]];

    self.navigationController.navigationBar.topItem.title = @"Join";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Let's Do It!"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(addUser:)];
    
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
    
    //[FlatUIHelper configureItemOrProxy:self.navigationItem.rightBarButtonItem forFlatButtonWithColor:navigationBarColor highlightedColor:greyColor cornerRadius:3];
    
    //disable rightbarbutton
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    
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
    
    // set up textView
    self.policyTextView.backgroundColor = [UIColor clearColor];
    self.policyTextView.font = [UIFont italicSystemFontOfSize:11.0f];
    self.policyTextView.editable = NO;
    self.policyTextView.text = @"By proceeding, you are agreeing to the Uptimal Terms of Service and Privacy Policy.";
    
    // set up the text fields
    self.firstNameField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    self.firstNameField.layer.cornerRadius = 3.0f;
    self.firstNameField.placeholder = @"First Name";
    self.firstNameField.leftViewMode = UITextFieldViewModeAlways;
    UIView* leftView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    self.firstNameField.leftView = leftView1;
    self.firstNameField.font = [UIFont fontWithName:@"OpenSans-Light" size:14.0f];
    self.firstNameField.returnKeyType = UIReturnKeyNext;
    
    self.lastNameField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    self.lastNameField.layer.cornerRadius = 3.0f;
    self.lastNameField.placeholder = @"Last Name";
    self.lastNameField.leftViewMode = UITextFieldViewModeAlways;
    UIView* leftView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    self.lastNameField.leftView = leftView2;
    self.lastNameField.font = [UIFont fontWithName:@"OpenSans-Light" size:14.0f];
    self.lastNameField.returnKeyType = UIReturnKeyNext;
    
    self.emailField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    self.emailField.layer.cornerRadius = 3.0f;
    self.emailField.placeholder = @"Email Address";
    self.emailField.leftViewMode = UITextFieldViewModeAlways;
    UIView* leftView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    self.emailField.leftView = leftView3;
    self.emailField.font = [UIFont fontWithName:@"OpenSans-Light" size:14.0f];
    self.emailField.returnKeyType = UIReturnKeyNext;
    
    self.passwordField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    self.passwordField.layer.cornerRadius = 3.0f;
    self.passwordField.placeholder = @"Password";
    self.passwordField.leftViewMode = UITextFieldViewModeAlways;
    UIView* leftView4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    self.passwordField.leftView = leftView4;
    self.passwordField.font = [UIFont fontWithName:@"OpenSans-Light" size:14.0f];
    self.passwordField.returnKeyType = UIReturnKeyNext;
    
    //set up delegates
    self.firstNameField.delegate = self;
    self.lastNameField.delegate = self;
    self.emailField.delegate = self;
    self.passwordField.delegate = self;
    
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
-(void)enableJoinButton
{
    if ((self.firstNameField.text.length > 0) &&
        (self.lastNameField.text.length > 0) &&
        (self.passwordField.text.length > 0) &&
        (self.emailField.text.length > 0))
    {
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    }
    else
    {
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    
    if (![self.passwordField.text isEqualToString:@""] &&
        ![self.emailField.text isEqualToString:@""] &&
        ![self.firstNameField.text isEqualToString:@""] &&
        ![self.lastNameField.text isEqualToString:@""])
    {
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    }
    
    // last text field to be edited is password field
    else if ((_firstNameField.text.length > 0) &&
        (_lastNameField.text.length > 0) &&
        (_emailField.text.length > 0) &&
        (_passwordField.text.length <= 0))
    {
        [_firstNameField setReturnKeyType:UIReturnKeyNext];
        [_lastNameField setReturnKeyType:UIReturnKeyNext];
        [_emailField setReturnKeyType:UIReturnKeyNext];
        [_passwordField setReturnKeyType:UIReturnKeyDone];
    }
    
    // last text field to be edited is the email field
    else if ((_firstNameField.text.length > 0) &&
        (_lastNameField.text.length > 0) &&
        (_emailField.text.length > 0) &&
        (_passwordField.text.length <= 0))
    {
        [_firstNameField setReturnKeyType:UIReturnKeyNext];
        [_lastNameField setReturnKeyType:UIReturnKeyNext];
        [_emailField setReturnKeyType:UIReturnKeyDone];
        [_passwordField setReturnKeyType:UIReturnKeyNext];
    }
        
    // last text field to be edited is the last name field
    else if ((_firstNameField.text.length > 0) &&
             (_lastNameField.text.length <= 0) &&
             (_emailField.text.length > 0) &&
             (_passwordField.text.length > 0))
    {
        [_firstNameField setReturnKeyType:UIReturnKeyNext];
        [_lastNameField setReturnKeyType:UIReturnKeyDone];
        [_emailField setReturnKeyType:UIReturnKeyNext];
        [_passwordField setReturnKeyType:UIReturnKeyNext];
    }

    // last text field to be edited is the first name field
    else if ((_firstNameField.text.length <= 0) &&
             (_lastNameField.text.length > 0) &&
             (_emailField.text.length > 0) &&
             (_passwordField.text.length > 0))
    {
        [_firstNameField setReturnKeyType:UIReturnKeyDone];
        [_lastNameField setReturnKeyType:UIReturnKeyNext];
        [_emailField setReturnKeyType:UIReturnKeyNext];
        [_passwordField setReturnKeyType:UIReturnKeyNext];
    }
    
    [self.view endEditing:YES];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if (textField.returnKeyType == UIReturnKeyDone)
    {
        [self.view endEditing:YES];
    }
    else if (textField == _firstNameField && textField.returnKeyType != UIReturnKeyDone)
    {
        [_lastNameField becomeFirstResponder];
    }
    else if (textField == _lastNameField && textField.returnKeyType != UIReturnKeyDone)
    {
        [_emailField becomeFirstResponder];
    }
    else if (textField == _emailField && textField.returnKeyType != UIReturnKeyDone)
    {
        [_passwordField becomeFirstResponder];
    }
    else if (textField == _passwordField && textField.returnKeyType != UIReturnKeyDone)
    {
        [_firstNameField becomeFirstResponder];
    }
    return YES;
}


#pragma mark - IBActions for Navigation Bar
// Adds new user

- (IBAction)addUser:(id)sender {
    PFUser *user = [PFUser user];
    user.username = _emailField.text;
    user.password = _passwordField.text;
    user.email = _emailField.text;
    
    UIImage *imageFile = [UIImage imageNamed:@"default_profile_image.png"];
    NSData *imageData = UIImageJPEGRepresentation(imageFile, 0.05f);
    PFFile *image = [PFFile fileWithName:@"profile.png" data:imageData];
    
    user[@"profileImage"] = image;
    user[@"firstName"] = _firstNameField.text;
    user[@"lastName"] = _lastNameField.text;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Hooray! Let them use the app now.
            NSLog(@"added new user");
            [PFUser logInWithUsernameInBackground:_emailField.text password:_passwordField.text
                                            block:^(PFUser *user, NSError *error) {
                                                if (user) {
                                                    // Do stuff after successful login.
                                                    [self performSegueWithIdentifier:@"toMainSegueFromJoin" sender:self];
                                                } else {
                                                    // The login failed. Check error to see why.
                                                    NSString *errorString = [error userInfo][@"error"];
                                                    UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Oh no!" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                                                    [errorAlertView show];
                                                }
                                            }];
        
        } else {
            NSString *errorString = [error userInfo][@"error"];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Uh oh!" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
            // Show the errorString somewhere and let the user try again.
        }
    }];
}

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

// Cancel the current view
- (IBAction)cancel:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
