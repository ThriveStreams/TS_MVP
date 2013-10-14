//
//  SplashViewController.m
//  ThriveStreams
//
//  Created by Ryan Badilla on 10/4/13.
//  Copyright (c) 2013 ThriveStreams. All rights reserved.
//

#import "WelcomeViewController.h"
#import "MainViewController.h"
#import <Parse/Parse.h>

@interface WelcomeViewController ()

@end

@implementation WelcomeViewController

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
    
    [self.view setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:1.0]];
    
    UIColor* greyColor = [UIColor colorWithRed:149.0/255 green:165.0/255 blue:166.0/255 alpha:1.0f];
    UIColor* greenColor = [UIColor colorWithRed:39.0/255 green:174.0/255 blue:96.0/255 alpha:1.0f];
    
    
    self.loginButton.backgroundColor = greenColor;
    self.loginButton.layer.cornerRadius = 3.0f;
    self.loginButton.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:18.0f];
    [self.loginButton setTitle:@"Login" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    
    self.joinButton.backgroundColor = greyColor;
    self.joinButton.layer.cornerRadius = 3.0f;
    self.joinButton.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:18.0f];
    [self.joinButton setTitle:@"Join" forState:UIControlStateNormal];
    [self.joinButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.joinButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    
    self.facebookButton.backgroundColor = [UIColor colorWithRed:59.0/255.0 green:89.0/255.0 blue:152.0/255.0 alpha:1.0];
    self.facebookButton.layer.cornerRadius = 3.0f;
    self.facebookButton.titleLabel.font = [UIFont fontWithName:@"FACEBOLF" size:18.0f];
    [self.facebookButton setTitle:@"facebook" forState:UIControlStateNormal];
    [self.facebookButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.facebookButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
}


- (IBAction)loginWithFacebook:(id)sender  {
    // The permissions requested from the user
    NSArray *permissionsArray = @[@"email"];
    
    [_activityIndicator startAnimating]; // Show loading indicator until login is finished
    [self.facebookButton setTitle:@"" forState:UIControlStateNormal];
    // Login PFUser using Facebook
    
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        [_activityIndicator stopAnimating]; // Hide loading indicator
           [self.facebookButton setTitle:@"facebook" forState:UIControlStateNormal];
        
        if (!user) {
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
            }
        } else if (user.isNew) {
            NSLog(@"User with facebook signed up and logged in!");
            [self addDefaultGoals:user];
            [self setUpFacebookData];
            [self performSegueWithIdentifier:@"toMainSegueFromFacebook" sender:self];


            
        } else {
            NSLog(@"User with facebook logged in!");
            [self performSegueWithIdentifier:@"toMainSegueFromFacebook" sender:self];

        }
    }];
}

- (void)setUpFacebookData
{
    // Create request for user's Facebook data
    FBRequest *request = [FBRequest requestForMe];
    
    // Send request to Facebook
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *)result;
            
            NSString *firstName = userData[@"first_name"];
            NSString *lastName = userData[@"last_name"];
            NSString *email = userData[@"email"];
            
            PFUser *currentUser = [PFUser currentUser];
            currentUser.email = email;
            [currentUser setObject:firstName forKey:@"firstName"];
            [currentUser setObject:lastName forKey:@"lastName"];
            
            [currentUser saveInBackground];
        }
    }];
}

- (void)addDefaultGoals:(PFUser *)user
{
    NSMutableArray *objectArray = [[NSMutableArray alloc] initWithCapacity:4];
    NSArray *fundamentals = [NSArray arrayWithObjects: @"SAeeSNsDWM", @"ZPHaJ8CjvS", @"xj435NyIuW", @"h3AOIcsUkd", nil];
    
    PFQuery *fundamentalsQuery = [PFQuery queryWithClassName:@"Goal"];
    [fundamentalsQuery whereKey:@"objectId" containedIn:fundamentals];
    
    [fundamentalsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d objects", objects.count);
            // Do something with the found objects
            for (PFObject *object in objects) {
                NSLog(@"%@", object.objectId);
                [objectArray addObject:object];
            }
            NSLog(@"objectArray count: %d", [objectArray count]);
            [[PFUser currentUser] setObject:objectArray forKey:@"ThriveStreams"];
            [[PFUser currentUser] saveInBackground];
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
