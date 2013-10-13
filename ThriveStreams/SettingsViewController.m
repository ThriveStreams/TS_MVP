//
//  SettingsViewController.m
//  ThriveStreams
//
//  Created by Ryan Badilla on 10/4/13.
//  Copyright (c) 2013 ThriveStreams. All rights reserved.
//

#import "SettingsViewController.h"
#import "AppDelegate.h"
#import "User.h"
#import "UserSingleton.h"
#import "MBProgressHUD.h"
#import <Parse/Parse.h>

@interface SettingsViewController ()
{
    id userID;
    UITapGestureRecognizer *tapOutsideKeyboard;
}

@end

@implementation SettingsViewController

- (AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

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
    self.managedObjectContext = [[self.appDelegate coreDataStore] contextForCurrentThread];
    self.client = [SMClient defaultClient];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:240.0/255.0 blue:241.0/255.0 alpha:1.0]];
    
    NSString *firstName = [[PFUser currentUser] objectForKey:@"firstName"];
    NSString *lastName = [[PFUser currentUser] objectForKey:@"lastName"];
    NSString *username =[[PFUser currentUser] username];
    
    // setup text fields
    self.firstNameField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    self.firstNameField.layer.cornerRadius = 3.0f;
    self.firstNameField.text = firstName;
    self.firstNameField.placeholder = @"First Name";
    self.firstNameField.leftViewMode = UITextFieldViewModeAlways;
    UIView* leftView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    self.firstNameField.font = [UIFont fontWithName:@"OpenSans" size:14.0f];
    self.firstNameField.leftView = leftView1;
    self.firstNameField.delegate = self;
    
    self.lastNameField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    self.lastNameField.layer.cornerRadius = 3.0f;
    self.lastNameField.text = lastName;
    self.lastNameField.placeholder = @"Last Name";
    self.lastNameField.leftViewMode = UITextFieldViewModeAlways;
    UIView* leftView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    self.lastNameField.font = [UIFont fontWithName:@"OpenSans" size:14.0f];
    self.lastNameField.leftView = leftView2;
    self.lastNameField.delegate = self;
    
    self.emailField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    self.emailField.layer.cornerRadius = 3.0f;
    self.emailField.text = username;
    self.emailField.placeholder = @"Email Address";
    self.emailField.leftViewMode = UITextFieldViewModeAlways;
    UIView* leftView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    self.emailField.font = [UIFont fontWithName:@"OpenSans" size:14.0f];
    self.emailField.leftView = leftView3;
    self.emailField.delegate = self;
    
    self.passwordField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    self.passwordField.layer.cornerRadius = 3.0f;
    self.passwordField.placeholder = @"New Password";
    self.passwordField.leftViewMode = UITextFieldViewModeAlways;
    UIView* leftView4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    self.passwordField.font = [UIFont fontWithName:@"OpenSans" size:14.0f];
    self.passwordField.leftView = leftView4;
    self.passwordField.delegate = self;
    
    self.confirmPasswordField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    self.confirmPasswordField.layer.cornerRadius = 3.0f;
    self.confirmPasswordField.placeholder = @"Confirm New Password";
    self.confirmPasswordField.leftViewMode = UITextFieldViewModeAlways;
    UIView* leftView5 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    self.confirmPasswordField.font = [UIFont fontWithName:@"OpenSans" size:14.0f];
    self.confirmPasswordField.leftView = leftView5;
    self.confirmPasswordField.delegate = self;
    
    // set up navigation Bar
    self.navigationController.navigationBar.topItem.title = @"Settings";
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor colorWithWhite:0.4 alpha:1.0],
      UITextAttributeTextColor,
      [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0],
      UITextAttributeTextShadowColor,
      [NSValue valueWithUIOffset:UIOffsetMake(0, 0)],
      UITextAttributeTextShadowOffset,
      [UIFont fontWithName:@"OpenSans" size:0.0],
      UITextAttributeFont,
      nil]];
    
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:22.0/255.0 green:160.0/255.0 blue:133.0/255.0 alpha:1.0]];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Let's Do It!"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(done:)];
    
    NSDictionary* rightBarButtonDictionaryDisabled = [NSDictionary dictionaryWithObjectsAndKeys: [UIColor colorWithRed:22.0/255.0 green:160.0/255.0 blue:133.0/255.0 alpha:0.3], UITextAttributeTextColor,
                                                      [UIColor colorWithRed:149.0/255.0 green:165.0/255.0 blue:166.0/255.0 alpha:0.0], UITextAttributeTextShadowColor,
                                                      [NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset,
                                                      [UIFont fontWithName:@"OpenSans" size:16.0], UITextAttributeFont,
                                                      nil];
    NSDictionary* rightBarButtonDictionaryNormal = [NSDictionary dictionaryWithObjectsAndKeys: [UIColor colorWithRed:22.0/255.0 green:160.0/255.0 blue:133.0/255.0 alpha:1.0], UITextAttributeTextColor,
                                                    [UIColor colorWithRed:149.0/255.0 green:165.0/255.0 blue:166.0/255.0 alpha:0.0], UITextAttributeTextShadowColor,
                                                    [NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset,
                                                    [UIFont fontWithName:@"OpenSans" size:16.0], UITextAttributeFont,
                                                    nil];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:rightBarButtonDictionaryNormal forState:UIControlStateNormal];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:rightBarButtonDictionaryDisabled forState:UIControlStateDisabled];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(cancel:)];
    
    NSDictionary* leftBarButtonDictionary = [NSDictionary dictionaryWithObjectsAndKeys: [UIColor colorWithRed:149.0/255.0 green:165.0/255.0 blue:166.0/255.0 alpha:1.0], UITextAttributeTextColor,
                                             [UIColor colorWithRed:149.0/255.0 green:165.0/255.0 blue:166.0/255.0 alpha:0.0], UITextAttributeTextShadowColor,
                                             [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeTextShadowOffset,
                                             [UIFont fontWithName:@"OpenSans" size:16.0], UITextAttributeFont,
                                             nil];
    
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:leftBarButtonDictionary forState:UIControlStateNormal];
    
    //initialize tap gesture to remove keyboard
    tapOutsideKeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapRemoveKeyboard:)];
    tapOutsideKeyboard.cancelsTouchesInView = FALSE;
    [self.view addGestureRecognizer:tapOutsideKeyboard];
}

#pragma mark -UITextDelegates
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    
    return YES;
}

#pragma mark - removeKeyboard method
-(void)singleTapRemoveKeyboard:(UITapGestureRecognizer *)sender
{
    [self.view endEditing:YES];
}

#pragma mark - IBActions for navigation buttons

-(IBAction)done:(id)sender
{
    // flag to see if it is safe to save the user object
    BOOL safeToSave = YES;
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        [currentUser setObject:_firstNameField.text forKey:@"firstName"];
        [currentUser setObject:_lastNameField.text forKey:@"lastName"];
        currentUser.email = [_emailField.text lowercaseString];
        currentUser.username = [_emailField.text lowercaseString];
        
        // passwordField has text, confirmPasswordField does not have text
        if (([_passwordField.text length] > 0) && ([_confirmPasswordField.text length] <= 0))
        {
            safeToSave = NO;

            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Confirm Password" message:@"Please confirm your new password." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
        }
        
        // passwordField does not have text, confirmPasswordField has text
        else if (([_passwordField.text length] <= 0) &&
                 ([_confirmPasswordField.text length] > 0))
        {
            safeToSave = NO;
        
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No new password" message:@"Please type in your new password." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
        }
        
        // both fields have text
        else if (([_passwordField.text length] > 0) &&
                 ([_confirmPasswordField.text length] > 0))
        {
            if ([_passwordField.text isEqualToString:_confirmPasswordField.text])
            {
                currentUser.password = _confirmPasswordField.text;
            }
            else
            {
                safeToSave = NO;
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Password Mismatch" message:@"Passwords do not match." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertView show];
            }
        }
        
        if (safeToSave)
        {
            [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
                if (succeeded)
                {
                    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                }
                else
                {
                    NSString *errorString =  [error userInfo][@"error"];
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Uh oh" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alertView show];
                }
            }];
        }
        
    } else {
        // show the signup or login screen
    }
}


/*
-(IBAction)done:(id)sender
{
    
    [self.view endEditing:YES];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"User"];
    NSPredicate *predicte = [NSPredicate predicateWithFormat:@"username == %@", currentUsername];
    [fetchRequest setPredicate:predicte];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.dimBackground = YES;
    hud.labelText = @"Updating your information...";
    
    [self.managedObjectContext executeFetchRequest:fetchRequest onSuccess:^(NSArray *results) {
        NSLog(@"went here for executeFetch");
        NSManagedObject *userObject = [results objectAtIndex:0];
        
        if (![self.emailField.text isEqualToString:currentUsername])
        {
            [userObject setValue:[self.emailField.text lowercaseString] forKey:[userObject primaryKeyField]];
            currentUsername = self.emailField.text;
        }
        [userObject setValue:self.firstNameField.text forKey:@"firstname"];
        [userObject setValue:self.lastNameField.text forKey:@"lastname"];
        
        [self.managedObjectContext saveOnSuccess:^{
            NSLog(@"User object updated part one!");
            
            // user typed into a new password field
            if (_confirmPasswordField.text.length > 0)
            {
                [[SMClient defaultClient] changeLoggedInUserPasswordFrom:_passwordField.text to:_confirmPasswordField.text onSuccess:^(NSDictionary *result){
                    
                    
                }onFailure:^(NSError *error){
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    NSLog(@"Error: %@", error);
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:error.description delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alertView show];
                }];
            }
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
            hud.mode = MBProgressHUDModeCustomView;
            hud.labelText = @"Information updated!";
            [hud hide:YES afterDelay:2];
            
        } onFailure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"There was an error! %@", error);
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:error.description delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
        }];
        
        
        
    } onFailure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"Error fetching: %@", error);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }];
}
 */

-(IBAction)cancel:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
