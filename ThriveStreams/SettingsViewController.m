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
#import "StackMob.h"

@interface SettingsViewController ()
{
    NSString *currentUsername;
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
    
    UserSingleton *singleton = [UserSingleton sharedManager];
    NSDictionary *userInfo = [singleton returnDictionary];
    NSString *firstName = [userInfo objectForKey:@"firstname"];
    NSString *lastName = [userInfo objectForKey:@"lastname"];
    NSString *username = [userInfo objectForKey:@"username"];
    currentUsername = username;
    
    // setup text fields
    self.firstNameField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    self.firstNameField.layer.cornerRadius = 3.0f;
    self.firstNameField.text = firstName;
    self.firstNameField.placeholder = @"First Name";
    self.firstNameField.leftViewMode = UITextFieldViewModeAlways;
    UIView* leftView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    self.firstNameField.leftView = leftView1;
    self.firstNameField.delegate = self;
    
    self.lastNameField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    self.lastNameField.layer.cornerRadius = 3.0f;
    self.lastNameField.text = lastName;
    self.lastNameField.placeholder = @"Last Name";
    self.lastNameField.leftViewMode = UITextFieldViewModeAlways;
    UIView* leftView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    self.lastNameField.leftView = leftView2;
    self.lastNameField.delegate = self;
    
    self.emailField.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    self.emailField.layer.cornerRadius = 3.0f;
    self.emailField.text = username;
    self.emailField.placeholder = @"Email Address";
    self.emailField.leftViewMode = UITextFieldViewModeAlways;
    UIView* leftView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    self.emailField.leftView = leftView3;
    self.emailField.enabled = NO;
    self.emailField.delegate = self;
    
    self.passwordField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    self.passwordField.layer.cornerRadius = 3.0f;
    self.passwordField.placeholder = @"Old Password";
    self.passwordField.leftViewMode = UITextFieldViewModeAlways;
    UIView* leftView4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    self.passwordField.leftView = leftView4;
    self.passwordField.delegate = self;
    
    self.confirmPasswordField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    self.confirmPasswordField.layer.cornerRadius = 3.0f;
    self.confirmPasswordField.placeholder = @"New Password";
    self.confirmPasswordField.leftViewMode = UITextFieldViewModeAlways;
    UIView* leftView5 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    self.confirmPasswordField.leftView = leftView5;
    self.confirmPasswordField.delegate = self;
    
    // set up navigation Bar
    self.navigationController.navigationBar.topItem.title = @"Settings";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Let's Do It!"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(done:)];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(cancel:)];
    
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
