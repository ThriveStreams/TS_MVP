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
    
    _testLabel.text = @"";
    _test2Label.text = @"";
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
                _testLabel.text = error.description;
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
                _testLabel.text = error.description;
            }
        } else if (user.isNew) {
            NSLog(@"User with facebook signed up and logged in!");
            _testLabel.text = @"new user signed up. OK.";
            [self addDefaultGoals:user];
            [self setUpFacebookData];
            [self performSegueWithIdentifier:@"toMainSegueFromFacebook" sender:self];


            
        } else {
            NSLog(@"User with facebook logged in!");
            _testLabel.text = @"user signed up with existing account. OK.";
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
            _test2Label.text = @"properly set up facebook data";
        }
        else
        {
            _test2Label.text = error.description;
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

-(IBAction)deployStuff:(id)sender
{
    /*
    UIImage *imageFile1 = [UIImage imageNamed:@"Foursquare.png"];
    NSData *imageData1 = UIImageJPEGRepresentation(imageFile1, 0.05f);
    PFFile *image1 = [PFFile fileWithName:@"ForsquareIcon.png" data:imageData1];
    
    UIImage *imageFile2 = [UIImage imageNamed:@"Evernote.png"];
    NSData *imageData2 = UIImageJPEGRepresentation(imageFile2, 0.05f);
    PFFile *image2 = [PFFile fileWithName:@"EvernoteIcon.png" data:imageData2];
    
    UIImage *imageFile3 = [UIImage imageNamed:@"Twitter.png"];
    NSData *imageData3 = UIImageJPEGRepresentation(imageFile3, 0.05f);
    PFFile *image3 = [PFFile fileWithName:@"TwitterIcon.png" data:imageData3];
    
    UIImage *imageFile4 = [UIImage imageNamed:@"mapmyrun.png"];
    NSData *imageData4 = UIImageJPEGRepresentation(imageFile4, 0.05f);
    PFFile *image4 = [PFFile fileWithName:@"MapMyRunIcon.png" data:imageData4];
    
    UIImage *imageFile5 = [UIImage imageNamed:@"aim.png"];
    NSData *imageData5 = UIImageJPEGRepresentation(imageFile5, 0.05f);
    PFFile *image5 = [PFFile fileWithName:@"AimIcon.png" data:imageData5];
    
    UIImage *imageFile6 = [UIImage imageNamed:@"digg.png"];
    NSData *imageData6 = UIImageJPEGRepresentation(imageFile6, 0.05f);
    PFFile *image6 = [PFFile fileWithName:@"DiggIcon.png" data:imageData6];
    
    UIImage *imageFile7 = [UIImage imageNamed:@"google.png"];
    NSData *imageData7 = UIImageJPEGRepresentation(imageFile7, 0.05f);
    PFFile *image7 = [PFFile fileWithName:@"Google+Icon.png" data:imageData7];
    
    UIImage *imageFile8= [UIImage imageNamed:@"reddit.png"];
    NSData *imageData8 = UIImageJPEGRepresentation(imageFile8, 0.05f);
    PFFile *image8 = [PFFile fileWithName:@"RedditIcon.png" data:imageData8];
    
    UIImage *imageFile9 = [UIImage imageNamed:@"FaceBook.png"];
    NSData *imageData9 = UIImageJPEGRepresentation(imageFile9, 0.05f);
    PFFile *image9 = [PFFile fileWithName:@"FacebookIcon.png" data:imageData9];
    
    PFObject *link1 = [PFObject objectWithClassName:@"GoalLinks"];
    [link1 setObject:@"http://www.digg.com" forKey:@"Link"];
    [link1 setObject:@"Digg" forKey:@"LinkTitle"];
    [link1 setObject:@"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua." forKey:@"LinkDescription"];
    
    PFObject *link2 = [PFObject objectWithClassName:@"GoalLinks"];
    [link2 setObject:@"http://www.mapmyrun.com/" forKey:@"Link"];
    [link2 setObject:@"MapMyRun" forKey:@"LinkTitle"];
    [link2 setObject:@"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua." forKey:@"LinkDescription"];
    
    PFObject *link3 = [PFObject objectWithClassName:@"GoalLinks"];
    [link3 setObject:@"http://www.43things.com/" forKey:@"Link"];
    [link3 setObject:@"43Things" forKey:@"LinkTitle"];
    [link3 setObject:@"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua." forKey:@"LinkDescription"];
    
    PFObject *link4 = [PFObject objectWithClassName:@"GoalLinks"];
    [link4 setObject:@"http://www.linkedin.com" forKey:@"Link"];
    [link4 setObject:@"LinkedIn" forKey:@"LinkTitle"];
    [link4 setObject:@"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua." forKey:@"LinkDescription"];
    
    PFObject *link5 = [PFObject objectWithClassName:@"GoalLinks"];
    [link5 setObject:@"http://www.reddit.com" forKey:@"Link"];
    [link5 setObject:@"Reddit" forKey:@"LinkTitle"];
    [link5 setObject:@"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua." forKey:@"LinkDescription"];
    
    PFObject *link6 = [PFObject objectWithClassName:@"GoalLinks"];
    [link6 setObject:@"http://www.facebook.com" forKey:@"Link"];
    [link6 setObject:@"Facebook" forKey:@"LinkTitle"];
    [link6 setObject:@"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua." forKey:@"LinkDescription"];
    
    PFObject *link7 = [PFObject objectWithClassName:@"GoalLinks"];
    [link7 setObject:@"http://www.bing.com" forKey:@"Link"];
    [link7 setObject:@"Bing" forKey:@"LinkTitle"];
    [link7 setObject:@"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua." forKey:@"LinkDescription"];
    
    PFObject *link8 = [PFObject objectWithClassName:@"GoalLinks"];
    [link8 setObject:@"http://www.yahoo.com" forKey:@"Link"];
    [link8 setObject:@"Yahoo!" forKey:@"LinkTitle"];
    [link8 setObject:@"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua." forKey:@"LinkDescription"];
    
    PFObject *link9 = [PFObject objectWithClassName:@"GoalLinks"];
    [link9 setObject:@"http://www.google.com" forKey:@"Link"];
    [link9 setObject:@"Google" forKey:@"LinkTitle"];
    [link9 setObject:@"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua." forKey:@"LinkDescription"];
    
    PFObject *tool1 = [PFObject objectWithClassName:@"GoalTools"];
    [tool1 setObject:@"FourSquare" forKey:@"Name"];
    [tool1 setObject:@"https://itunes.apple.com/us/app/foursquare-find-restaurants/id306934924?mt=8" forKey:@"AppLink"];
    [tool1 setObject:image1 forKey:@"AppImage"];
    
    PFObject *tool2 = [PFObject objectWithClassName:@"GoalTools"];
    [tool2 setObject:@"Evernote" forKey:@"Name"];
    [tool2 setObject:@"https://itunes.apple.com/us/app/evernote/id281796108" forKey:@"AppLink"];
    [tool2 setObject:image2 forKey:@"AppImage"];

    PFObject *tool3 = [PFObject objectWithClassName:@"GoalTools"];
    [tool3 setObject:@"Twitter" forKey:@"Name"];
    [tool3 setObject:@"https://itunes.apple.com/us/app/twitter/id333903271" forKey:@"AppLink"];
    [tool3 setObject:image3 forKey:@"AppImage"];
    
    PFObject *tool4 = [PFObject objectWithClassName:@"GoalTools"];
    [tool4 setObject:@"MapMyRun" forKey:@"Name"];
    [tool4 setObject:@"https://itunes.apple.com/us/app/run-map-my-run-gps-running/id291890420?mt=8" forKey:@"AppLink"];
    [tool4 setObject:image4 forKey:@"AppImage"];
    
    PFObject *tool5 = [PFObject objectWithClassName:@"GoalTools"];
    [tool5 setObject:@"AIM" forKey:@"Name"];
    [tool5 setObject:@"https://itunes.apple.com/us/app/aim-free-sms-chat-group-chat/id306610781?mt=8" forKey:@"AppLink"];
    [tool5 setObject:image5 forKey:@"AppImage"];
    
    PFObject *tool6 = [PFObject objectWithClassName:@"GoalTools"];
    [tool6 setObject:@"Digg" forKey:@"Name"];
    [tool6 setObject:@"https://itunes.apple.com/us/app/digg/id362872995?mt=8" forKey:@"AppLink"];
    [tool6 setObject:image6 forKey:@"AppImage"];
    
    PFObject *tool7 = [PFObject objectWithClassName:@"GoalTools"];
    [tool7 setObject:@"Google+" forKey:@"Name"];
    [tool7 setObject:@"https://itunes.apple.com/us/app/google+/id447119634" forKey:@"AppLink"];
    [tool7 setObject:image7 forKey:@"AppImage"];
    
    PFObject *tool8 = [PFObject objectWithClassName:@"GoalTools"];
    [tool8 setObject:@"Reddit" forKey:@"Name"];
    [tool8 setObject:@"https://itunes.apple.com/us/app/alien-blue-reddit-client/id370144106?mt=8" forKey:@"AppLink"];
    [tool8 setObject:image8 forKey:@"AppImage"];
    
    PFObject *tool9 = [PFObject objectWithClassName:@"GoalTools"];
    [tool9 setObject:@"Facebook" forKey:@"Name"];
    [tool9 setObject:@"https://itunes.apple.com/ca/app/facebook/id284882215" forKey:@"AppLink"];
    [tool9 setObject:image9 forKey:@"AppImage"];*/
    
    NSArray *fundamentals = [NSArray arrayWithObjects: @"SAeeSNsDWM", @"ZPHaJ8CjvS", @"xj435NyIuW", @"h3AOIcsUkd", nil];
    
    PFQuery *fundamentalsQuery = [PFQuery queryWithClassName:@"Goal"];
    [fundamentalsQuery whereKey:@"objectId" containedIn:fundamentals];
    
    [fundamentalsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d objects", objects.count);
            // Do something with the found objects
            for (PFObject *object in objects) {
                UIImage *imageFile1 = [UIImage imageNamed:@"Foursquare.png"];
                NSData *imageData1 = UIImageJPEGRepresentation(imageFile1, 0.05f);
                PFFile *image1 = [PFFile fileWithName:@"ForsquareIcon.png" data:imageData1];
                
                UIImage *imageFile2 = [UIImage imageNamed:@"Evernote.png"];
                NSData *imageData2 = UIImageJPEGRepresentation(imageFile2, 0.05f);
                PFFile *image2 = [PFFile fileWithName:@"EvernoteIcon.png" data:imageData2];
                
                UIImage *imageFile3 = [UIImage imageNamed:@"Twitter.png"];
                NSData *imageData3 = UIImageJPEGRepresentation(imageFile3, 0.05f);
                PFFile *image3 = [PFFile fileWithName:@"TwitterIcon.png" data:imageData3];
                
                UIImage *imageFile4 = [UIImage imageNamed:@"mapmyrun.png"];
                NSData *imageData4 = UIImageJPEGRepresentation(imageFile4, 0.05f);
                PFFile *image4 = [PFFile fileWithName:@"MapMyRunIcon.png" data:imageData4];
                
                UIImage *imageFile5 = [UIImage imageNamed:@"aim.png"];
                NSData *imageData5 = UIImageJPEGRepresentation(imageFile5, 0.05f);
                PFFile *image5 = [PFFile fileWithName:@"AimIcon.png" data:imageData5];
                
                UIImage *imageFile6 = [UIImage imageNamed:@"digg.png"];
                NSData *imageData6 = UIImageJPEGRepresentation(imageFile6, 0.05f);
                PFFile *image6 = [PFFile fileWithName:@"DiggIcon.png" data:imageData6];
                
                UIImage *imageFile7 = [UIImage imageNamed:@"google_square.png"];
                NSData *imageData7 = UIImageJPEGRepresentation(imageFile7, 0.05f);
                PFFile *image7 = [PFFile fileWithName:@"GooglePlusIcon.png" data:imageData7];
                
                UIImage *imageFile8= [UIImage imageNamed:@"reddit.png"];
                NSData *imageData8 = UIImageJPEGRepresentation(imageFile8, 0.05f);
                PFFile *image8 = [PFFile fileWithName:@"RedditIcon.png" data:imageData8];
                
                UIImage *imageFile9 = [UIImage imageNamed:@"FaceBook.png"];
                NSData *imageData9 = UIImageJPEGRepresentation(imageFile9, 0.05f);
                PFFile *image9 = [PFFile fileWithName:@"FacebookIcon.png" data:imageData9];
                
                PFObject *link1 = [PFObject objectWithClassName:@"GoalLinks"];
                [link1 setObject:@"http://www.digg.com" forKey:@"Link"];
                [link1 setObject:@"Digg" forKey:@"LinkTitle"];
                [link1 setObject:@"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua." forKey:@"LinkDescription"];
                
                PFObject *link2 = [PFObject objectWithClassName:@"GoalLinks"];
                [link2 setObject:@"http://www.mapmyrun.com/" forKey:@"Link"];
                [link2 setObject:@"MapMyRun" forKey:@"LinkTitle"];
                [link2 setObject:@"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua." forKey:@"LinkDescription"];
                
                PFObject *link3 = [PFObject objectWithClassName:@"GoalLinks"];
                [link3 setObject:@"http://www.43things.com/" forKey:@"Link"];
                [link3 setObject:@"43Things" forKey:@"LinkTitle"];
                [link3 setObject:@"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua." forKey:@"LinkDescription"];
                
                PFObject *link4 = [PFObject objectWithClassName:@"GoalLinks"];
                [link4 setObject:@"http://www.linkedin.com" forKey:@"Link"];
                [link4 setObject:@"LinkedIn" forKey:@"LinkTitle"];
                [link4 setObject:@"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua." forKey:@"LinkDescription"];
                
                PFObject *link5 = [PFObject objectWithClassName:@"GoalLinks"];
                [link5 setObject:@"http://www.reddit.com" forKey:@"Link"];
                [link5 setObject:@"Reddit" forKey:@"LinkTitle"];
                [link5 setObject:@"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua." forKey:@"LinkDescription"];
                
                PFObject *link6 = [PFObject objectWithClassName:@"GoalLinks"];
                [link6 setObject:@"http://www.facebook.com" forKey:@"Link"];
                [link6 setObject:@"Facebook" forKey:@"LinkTitle"];
                [link6 setObject:@"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua." forKey:@"LinkDescription"];
                
                PFObject *link7 = [PFObject objectWithClassName:@"GoalLinks"];
                [link7 setObject:@"http://www.bing.com" forKey:@"Link"];
                [link7 setObject:@"Bing" forKey:@"LinkTitle"];
                [link7 setObject:@"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua." forKey:@"LinkDescription"];
                
                PFObject *link8 = [PFObject objectWithClassName:@"GoalLinks"];
                [link8 setObject:@"http://www.yahoo.com" forKey:@"Link"];
                [link8 setObject:@"Yahoo!" forKey:@"LinkTitle"];
                [link8 setObject:@"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua." forKey:@"LinkDescription"];
                
                PFObject *link9 = [PFObject objectWithClassName:@"GoalLinks"];
                [link9 setObject:@"http://www.google.com" forKey:@"Link"];
                [link9 setObject:@"Google" forKey:@"LinkTitle"];
                [link9 setObject:@"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua." forKey:@"LinkDescription"];
                
                PFObject *tool1 = [PFObject objectWithClassName:@"GoalTools"];
                [tool1 setObject:@"FourSquare" forKey:@"Name"];
                [tool1 setObject:@"https://itunes.apple.com/us/app/foursquare-find-restaurants/id306934924?mt=8" forKey:@"AppLink"];
                [tool1 setObject:image1 forKey:@"AppImage"];
                
                PFObject *tool2 = [PFObject objectWithClassName:@"GoalTools"];
                [tool2 setObject:@"Evernote" forKey:@"Name"];
                [tool2 setObject:@"https://itunes.apple.com/us/app/evernote/id281796108" forKey:@"AppLink"];
                [tool2 setObject:image2 forKey:@"AppImage"];
                
                PFObject *tool3 = [PFObject objectWithClassName:@"GoalTools"];
                [tool3 setObject:@"Twitter" forKey:@"Name"];
                [tool3 setObject:@"https://itunes.apple.com/us/app/twitter/id333903271" forKey:@"AppLink"];
                [tool3 setObject:image3 forKey:@"AppImage"];
                
                PFObject *tool4 = [PFObject objectWithClassName:@"GoalTools"];
                [tool4 setObject:@"MapMyRun" forKey:@"Name"];
                [tool4 setObject:@"https://itunes.apple.com/us/app/run-map-my-run-gps-running/id291890420?mt=8" forKey:@"AppLink"];
                [tool4 setObject:image4 forKey:@"AppImage"];
                
                PFObject *tool5 = [PFObject objectWithClassName:@"GoalTools"];
                [tool5 setObject:@"AIM" forKey:@"Name"];
                [tool5 setObject:@"https://itunes.apple.com/us/app/aim-free-sms-chat-group-chat/id306610781?mt=8" forKey:@"AppLink"];
                [tool5 setObject:image5 forKey:@"AppImage"];
                
                PFObject *tool6 = [PFObject objectWithClassName:@"GoalTools"];
                [tool6 setObject:@"Digg" forKey:@"Name"];
                [tool6 setObject:@"https://itunes.apple.com/us/app/digg/id362872995?mt=8" forKey:@"AppLink"];
                [tool6 setObject:image6 forKey:@"AppImage"];
                
                PFObject *tool7 = [PFObject objectWithClassName:@"GoalTools"];
                [tool7 setObject:@"Google+" forKey:@"Name"];
                [tool7 setObject:@"https://itunes.apple.com/us/app/google+/id447119634" forKey:@"AppLink"];
                [tool7 setObject:image7 forKey:@"AppImage"];
                
                PFObject *tool8 = [PFObject objectWithClassName:@"GoalTools"];
                [tool8 setObject:@"Reddit" forKey:@"Name"];
                [tool8 setObject:@"https://itunes.apple.com/us/app/alien-blue-reddit-client/id370144106?mt=8" forKey:@"AppLink"];
                [tool8 setObject:image8 forKey:@"AppImage"];
                
                PFObject *tool9 = [PFObject objectWithClassName:@"GoalTools"];
                [tool9 setObject:@"Facebook" forKey:@"Name"];
                [tool9 setObject:@"https://itunes.apple.com/ca/app/facebook/id284882215" forKey:@"AppLink"];
                [tool9 setObject:image9 forKey:@"AppImage"];
                
                [link1 setObject:object forKey:@"Goal"];
                [link2 setObject:object forKey:@"Goal"];
                [link3 setObject:object forKey:@"Goal"];
                [link4 setObject:object forKey:@"Goal"];
                [link5 setObject:object forKey:@"Goal"];
                [link6 setObject:object forKey:@"Goal"];
                [link7 setObject:object forKey:@"Goal"];
                [link8 setObject:object forKey:@"Goal"];
                [link9 setObject:object forKey:@"Goal"];
                
                [tool1 setObject:object forKey:@"Goal"];
                [tool2 setObject:object forKey:@"Goal"];
                [tool3 setObject:object forKey:@"Goal"];
                [tool4 setObject:object forKey:@"Goal"];
                [tool5 setObject:object forKey:@"Goal"];
                [tool6 setObject:object forKey:@"Goal"];
                [tool7 setObject:object forKey:@"Goal"];
                [tool8 setObject:object forKey:@"Goal"];
                [tool9 setObject:object forKey:@"Goal"];
                
                [link1 saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        NSLog(@"saved link1 to object: %@", object.objectId);
                    }
                    else
                        NSLog(@"Error: %@", error);
                }];
                
                [link2 saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        NSLog(@"saved link2 to object: %@", object.objectId);
                    }
                    else
                        NSLog(@"Error: %@", error);
                }];
                
                [link3 saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        NSLog(@"saved link3 to object: %@", object.objectId);
                    }
                    else
                        NSLog(@"Error: %@", error);
                }];
                
                [link4 saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        NSLog(@"saved link4 to object: %@", object.objectId);
                    }
                    else
                        NSLog(@"Error: %@", error);
                }];
                
                [link5 saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        NSLog(@"saved link5 to object: %@", object.objectId);
                    }
                    else
                        NSLog(@"Error: %@", error);
                }];
                
                [link6 saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        NSLog(@"saved link6 to object: %@", object.objectId);
                    }
                    else
                        NSLog(@"Error: %@", error);
                }];
                
                [link7 saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        NSLog(@"saved link7 to object: %@", object.objectId);
                    }
                    else
                        NSLog(@"Error: %@", error);
                }];
                
                [link8 saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        NSLog(@"saved link8 to object: %@", object.objectId);
                    }
                    else
                        NSLog(@"Error: %@", error);
                }];
                
                [link9 saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        NSLog(@"saved link9 to object: %@", object.objectId);
                    }
                    else
                        NSLog(@"Error: %@", error);
                }];
                
                [tool1 saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        NSLog(@"saved tool1 to object: %@", object.objectId);
                    }
                    else
                        NSLog(@"Error: %@", error);
                }];
                
                [tool2 saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        NSLog(@"saved tool2 to object: %@", object.objectId);
                    }
                    else
                        NSLog(@"Error: %@", error);
                }];
                
                [tool3 saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        NSLog(@"saved tool3 to object: %@", object.objectId);
                    }
                    else
                        NSLog(@"Error: %@", error);
                }];
                
                [tool4 saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        NSLog(@"saved tool4 to object: %@", object.objectId);
                    }
                    else
                        NSLog(@"Error: %@", error);
                }];
                
                [tool5 saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        NSLog(@"saved tool5 to object: %@", object.objectId);
                    }
                    else
                        NSLog(@"Error: %@", error);
                }];
                
                [tool6 saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        NSLog(@"saved tool6 to object: %@", object.objectId);
                    }
                    else
                        NSLog(@"Error: %@", error);
                }];
                
                [tool7 saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        NSLog(@"saved tool7 to object: %@", object.objectId);
                    }
                    else
                        NSLog(@"Error: %@", error);
                }];
                
                [tool8 saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        NSLog(@"saved tool8 to object: %@", object.objectId);
                    }
                    else
                        NSLog(@"Error: %@", error);
                }];
                
                [tool9 saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        NSLog(@"saved tool9 to object: %@", object.objectId);
                    }
                    else
                        NSLog(@"Error: %@", error);
                }];
            }

            
        }
        else {
            // Log details of the failure
            NSLog(@"Error: %@", error);
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
