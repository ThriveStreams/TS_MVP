//
//  WelcomeViewController.m
//  Uptimal
//
//  Created by Ryan Badilla on 10/4/13.
//  Copyright (c) 2013 ThriveStreams. All rights reserved.
//

#import "WelcomeViewController.h"
#import "MainViewController.h"
#import <Parse/Parse.h>

@interface WelcomeViewController ()
{
    UIImage *profileImage;
}

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
    _mutableData = [[NSMutableData alloc] init];
    
    self.view.backgroundColor = [UIColor colorWithRed:236.0/255.0 green:240.0/255.0 blue:241.0/255.0 alpha:1.0];
    
    UIColor* greyColor = [UIColor colorWithRed:149.0/255 green:165.0/255 blue:166.0/255 alpha:1.0f];
    UIColor* greenColor = [UIColor colorWithRed:39.0/255 green:174.0/255 blue:96.0/255 alpha:1.0f];
    
    self.loginButton.backgroundColor = greenColor;
    self.loginButton.layer.cornerRadius = 5.0f;
    self.loginButton.titleLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:18.0f];
    [self.loginButton setTitle:@"Login" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    
    self.joinButton.backgroundColor = greyColor;
    self.joinButton.layer.cornerRadius = 5.0f;
    self.joinButton.titleLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:18.0f];
    [self.joinButton setTitle:@"Join" forState:UIControlStateNormal];
    [self.joinButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.joinButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    
    self.facebookButton.backgroundColor = [UIColor colorWithRed:59.0/255.0 green:89.0/255.0 blue:152.0/255.0 alpha:1.0];
    self.facebookButton.layer.cornerRadius = 5.0f;
    self.facebookButton.titleLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:18.0f];
    [self.facebookButton setTitle:@"Connect with Facebook" forState:UIControlStateNormal];
    [self.facebookButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.facebookButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    
    self.twitterButton.backgroundColor = [UIColor colorWithRed:64.0/255.0 green:153.0/255.0 blue:255.0/255.0 alpha:1.0];;
    self.twitterButton.layer.cornerRadius = 5.0f;
    self.twitterButton.titleLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:18.0f];
    [self.twitterButton setTitle:@"Connect with Twitter" forState:UIControlStateNormal];
    [self.twitterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.twitterButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
}

- (IBAction)loginWithTwitter:(id)sender {
    [_activityIndicatorFacebook startAnimating];
    
    [PFTwitterUtils logInWithBlock:^(PFUser *user, NSError *error) {
        if (!user) {
            [_activityIndicatorFacebook stopAnimating];
             NSLog(@"No user login");
           // [self performSegueWithIdentifier:@"toMainSegueFromFacebook" sender:self];
            [self setUpTwitterData];
        
            return;
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in with Twitter!");
            [self setUpTwitterData];
         //   [self performSegueWithIdentifier:@"toMainSegueFromFacebook" sender:self];
        } else {
            NSLog(@"User logged in with Twitter!");
        }     
    }];
}

- (IBAction)loginWithFacebook:(id)sender  {
    // The permissions requested from the user
    
    UIAlertView *facebookAlert = [[UIAlertView alloc] initWithTitle:@"One more step" message:@"By tapping \"Continue\" you agree to the Terms of Use, Cookie Policy and Privacy Policy of Facebook." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Continue", nil];
    [facebookAlert setTag:1];
    
    [facebookAlert show];
}

- (void)setUpTwitterData
{
    /*    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
        ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        
        [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
            if(granted) {
                NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
                
                if ([accountsArray count] > 0) {
                    ACAccount *twitterAccount = [accountsArray objectAtIndex:0];
                    NSLog(@"%@", twitterAccount.userFullName);
                    NSLog(@"%@",twitterAccount.username);
                //    NSLog(@"%@",twitterAccount.accountType);
                    
                }
            }
        }]; */
}

- (void)transferFacebookDataToParse: (NSData *)data
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
            currentUser.username = email;
            currentUser.email = email;
            [currentUser setObject:firstName forKey:@"firstName"];
            [currentUser setObject:lastName forKey:@"lastName"];
            
            UIImage *image = [UIImage imageWithData:data];
            NSData *imageData1 = UIImageJPEGRepresentation(image, 0.05f);
            PFFile *profile = [PFFile fileWithName:@"profileImage.jpg" data:imageData1];
            [currentUser setObject:profile forKey:@"profileImage"];
            profileImage = image;
            
            [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
               if (succeeded)
               {
                   [self performSegueWithIdentifier:@"toMainSegueFromFacebook" sender:self];
               }
            }];
        }
        else
        {
        }
    }];
}

-(void)getFacebookDataAndSegue:(NSString *)facebookId {

    NSURL *profilePictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookId]];
    NSURLRequest *profilePictureURLRequest = [NSURLRequest requestWithURL:profilePictureURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f]; // Facebook profile picture cache policy: Expires in 2 weeks
    [NSURLConnection connectionWithRequest:profilePictureURLRequest delegate:self];
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


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toMainSegueFromFacebook"])
    {
        [_activityIndicatorFacebook stopAnimating];
        [self.facebookButton setTitle:@"Connect with Facebook" forState:UIControlStateNormal];

        NSString *firstname = [[PFUser currentUser] objectForKey:@"firstName"];
        NSString *lastname = [[PFUser currentUser] objectForKey:@"lastName"];
        
        UINavigationController *navigationController = segue.destinationViewController;
        MainViewController *controller =(MainViewController *)navigationController.topViewController;
        controller.firstname = firstname;
        controller.lastname = lastname;
        controller.profileImage = profileImage;
    }
    
}


#pragma mark - UIViewDelegates

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // facebook alert
    if (alertView.tag == 1 && buttonIndex == 1)
    {
        
        NSArray *permissionsArray = @[@"email"];
        __block NSString *facebookId;
        
        [_activityIndicatorFacebook startAnimating]; // Show loading indicator until login is finished
        [self.facebookButton setTitle:@"" forState:UIControlStateNormal];
        // Login PFUser using Facebook
        
        [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
            [FBRequestConnection
             startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                 if (!error) {
                     facebookId = [result objectForKey:@"id"];
                 }
                 
                 if (!user) {
                     if (!error) {
                         NSLog(@"Uh oh. The user cancelled the Facebook login.");
                     } else {
                         NSLog(@"Uh oh. An error occurred: %@", error);
                     }
                 } else if (user.isNew) {
                     NSLog(@"User with facebook signed up and logged in!");
                     //      [self addDefaultGoals:user];
                     [self getFacebookDataAndSegue: facebookId];
                     
                 } else {
                     NSLog(@"User with facebook logged in!");
                     [self getFacebookDataAndSegue: facebookId];
                     
                 }
             }];
        }];
   
    }
}

#pragma mark - NSURLConnectionDataDelegate

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _mutableData = [[NSMutableData alloc] init];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_mutableData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self transferFacebookDataToParse: _mutableData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
