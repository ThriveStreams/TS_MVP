//
//  MainViewController.m
//  ThriveStreams
//
//  Created by Ryan Badilla on 10/4/13.
//  Copyright (c) 2013 ThriveStreams. All rights reserved.
//

#import "MainViewController.h"
#import "FlatUIHelper.h"
#import "AppDelegate.h"
#import "ThriveButton.h"
#import "ThriveButtonMenu.h"
#import "MBProgressHUD.h"
#import "UserSingleton.h"
#import "FundamentalGoalCell.h"
#import <Parse/Parse.h>
#import "User.h"
#import "Goal.h"

@interface MainViewController ()
{

    NSArray *thriveItems;
    NSMutableString *fullname;
    NSMutableArray *goalList;

    M13CheckboxState meditationState;
    M13CheckboxState journalState;
    M13CheckboxState exerciseState;
    M13CheckboxState nutritionState;
    
    UIImage *meditationImage;
    UIImage *journalImage;
    UIImage *exerciseImage;
    UIImage *nutritionImage;
}
@end

@implementation MainViewController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize client = _client;

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

    //initialize images with defaults
    meditationImage = [UIImage imageNamed:@"MeditationIcon.png"];
    journalImage = [UIImage imageNamed:@"JournalIcon.png"];
    exerciseImage = [UIImage imageNamed:@"ExerciseIcon.png"];
    nutritionImage = [UIImage imageNamed:@"NutritionIcon.png"];
    
    
    UIColor *meditationColor = [UIColor colorWithRed:155.0/255.0 green:89.0/255.0 blue:182.0/255.0 alpha:1.0f];
    UIColor *journalColor = [UIColor colorWithRed:241.0/255.0 green:196.0/255.0 blue:15.0/255.0 alpha:1.0f];
    UIColor *exerciseColor = [UIColor colorWithRed:46.0/255.0 green:204.0/255.0 blue:113.0/255.0 alpha:1.0f];
    UIColor *nutritionColor = [UIColor colorWithRed:230.0/255.0 green:126.0/255.0 blue:34.0/255.0 alpha:1.0f];
    
    //set up stackmob
    self.managedObjectContext = [[self.appDelegate coreDataStore] contextForCurrentThread];
    self.client = [SMClient defaultClient];
    
    // set up background color
    [self.view setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:240.0/255.0 blue:241.0/255.0 alpha:1.0]];
    
    ThriveButton *mainThriveButton = [[ThriveButton alloc]
                                      initAsMainButtonWithFrame:THRIVE_BUTTON_RECT_DEFAULT
                                      iconImage:[UIImage imageNamed:@"thriveButtonIcon.png"]
                                      subIconImage:[UIImage imageNamed:@"Xbutton.png"]
                                      borderColor: BUTTON_THRIVE_BORDER
                                      fillColor:BUTTON_THRIVE_FILL];

    ThriveButton *meditationButton = [[ThriveButton alloc] initAsSubButtonWithFrame:THRIVE_BUTTON_RECT_DEFAULT iconImage:[UIImage imageNamed:@"meditation_icon.png"] borderColor:meditationColor fillColor:meditationColor withBlock:^{
        if (meditationState == M13CheckboxStateUnchecked)
        {
            meditationImage = [UIImage imageNamed:@"CompletedIcon.png"];
            meditationState = M13CheckboxStateChecked;
        }
        else
        {
            meditationImage = [UIImage imageNamed:@"MeditationIcon.png"];
            meditationState = M13CheckboxStateUnchecked;
        }
        [self saveGoalData:@"h3AOIcsUkd" checkState:meditationState];
        
        [_tableView reloadData];
    }];
    
    ThriveButton *journalButton = [[ThriveButton alloc] initAsSubButtonWithFrame:THRIVE_BUTTON_RECT_DEFAULT iconImage:[UIImage imageNamed:@"journal_icon.png"] borderColor:journalColor fillColor:journalColor withBlock:^{
        if (journalState == M13CheckboxStateUnchecked)
        {
            journalImage = [UIImage imageNamed:@"CompletedIcon.png"];
            journalState = M13CheckboxStateChecked;
        }
        else
        {
            journalImage = [UIImage imageNamed:@"JournalIcon.png"];
            journalState = M13CheckboxStateUnchecked;
        }
        
        [self saveGoalData:@"xj435NyIuW" checkState:journalState];
        
        [_tableView reloadData];
    }];
    
    ThriveButton *exerciseButton = [[ThriveButton alloc] initAsSubButtonWithFrame:THRIVE_BUTTON_RECT_DEFAULT iconImage:[UIImage imageNamed:@"exercise_icon.png"] borderColor:exerciseColor fillColor:exerciseColor withBlock:^{
        if (exerciseState == M13CheckboxStateUnchecked)
        {
            exerciseState = M13CheckboxStateChecked;
            exerciseImage = [UIImage imageNamed:@"CompletedIcon.png"];
        }
        else
        {
            exerciseState = M13CheckboxStateUnchecked;
            exerciseImage = [UIImage imageNamed:@"ExerciseIcon.png"];
        }
        [self saveGoalData:@"ZPHaJ8CjvS" checkState:journalState];

        [_tableView reloadData];
    }];
    
    ThriveButton *nutritionButton = [[ThriveButton alloc] initAsSubButtonWithFrame:THRIVE_BUTTON_RECT_DEFAULT iconImage:[UIImage imageNamed:@"nutrition_icon.png"] borderColor:nutritionColor fillColor:nutritionColor withBlock:^{
        if (nutritionState == M13CheckboxStateUnchecked)
        {
            nutritionImage = [UIImage imageNamed:@"CompletedIcon.png"];
            nutritionState = M13CheckboxStateChecked;
        }
        else
        {
            nutritionImage = [UIImage imageNamed:@"NutritionIcon.png"];
            nutritionState = M13CheckboxStateUnchecked;
        }
        [self saveGoalData:@"SAeeSNsDWM" checkState:nutritionState];
    
        [_tableView reloadData];
    }];
    
    ThriveButtonMenu *menu = [[ThriveButtonMenu alloc] initWithFrame:THRIVEMENU_DEFAULT_SUPERVIEW_CGRECT parent:self mainButton:mainThriveButton subButtons:meditationButton, journalButton, exerciseButton, nutritionButton, nil];
    
    [self.view addSubview:menu];
    //
    // end of ThriveMenu setup
    //
    
    // set up table view
    _tableView.separatorInset = UIEdgeInsetsZero;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    [_tableView registerClass:[FundamentalGoalCell class] forCellReuseIdentifier:@"MyCellIdentifier"];
    
    
    // setup items for table view
    thriveItems = @[@"Meditation", @"Journal", @"Excercise", @"Nutrition"];
    
    // set up navigationbar
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithWhite:0.6 alpha:0.9]];
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 260, 20)];
    [logo setImage:[UIImage imageNamed:@"TS_Logo_BPLAN2.png"]];
    [logo setContentMode:UIViewContentModeScaleAspectFit];
    self.navigationItem.titleView = logo;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"3dotButton.png"] style:UIBarStyleDefault target:self action:@selector(showOverlay)];

    // hack to push navigation bar image
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, 4)]];
    self.navigationItem.leftBarButtonItem.enabled = NO;
    
   // self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@". . ." style:UIBarButtonItemStylePlain target:self action:@selector(showOverlay)];
    
    [self populateGoals];
  //  [self addDefaultGoals:[PFUser currentUser]];
}

#pragma mark - Populate goals
- (void)populateGoals
{
    NSArray *goalArray = PFUser.currentUser[@"ThriveStreams"];
    NSMutableArray *goalIDArray = [[NSMutableArray alloc] initWithCapacity:[goalArray count]];
    
    //user has no goals set, so add the default
    if ([goalArray count] == 0)
    {
        [self addDefaultGoals:[PFUser currentUser]];
    }
    
    // copy the goal IDs
    for (PFObject *goal in goalArray)
    {
        [goalIDArray addObject:[goal objectId]];
    }
    
    PFQuery *query = [PFQuery queryWithClassName:@"UserLog"];
    [query whereKey:@"UserID" equalTo:[[PFUser currentUser] objectId]];
    [query whereKey:@"Goal" containedIn:goalIDArray];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Getting your goals...";
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
        {
            for (PFObject *userLogObj in objects)
            {
                [self setCheckboxForGoalID:[userLogObj valueForKey:@"Goal"] isDone:YES];
            }
            [_tableView reloadData];
        }
        else
        {
            NSLog(@"Error: %@", error);
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

-(void)setCheckboxForGoalID:(NSString *)goalID isDone:(BOOL)done
{
    
    // goal is meditation
    if ([goalID isEqualToString:@"h3AOIcsUkd"])
    {
        if (done)
        {
            meditationImage = [UIImage imageNamed:@"CompletedIcon.png"];
            meditationState = M13CheckboxStateChecked;
        }
        else
        {
            meditationImage = [UIImage imageNamed:@"MeditationIcon.png"];
            meditationState = M13CheckboxStateUnchecked;
        }
    }
    
    //goal is journal
    else if ([goalID isEqualToString:@"xj435NyIuW"])
    {
        if (done)
        {
            journalImage = [UIImage imageNamed:@"CompletedIcon.png"];
            journalState = M13CheckboxStateChecked;
        }
        else
        {
            journalImage = [UIImage imageNamed:@"JournalIcon.png"];
            journalState = M13CheckboxStateUnchecked;
        }
    }
    
    // Goal is exercise
    else if ([goalID isEqualToString:@"ZPHaJ8CjvS"])
    {
        if (done)
        {
            exerciseImage = [UIImage imageNamed:@"CompletedIcon.png"];
            exerciseState = M13CheckboxStateChecked;
        }
        else
        {
            exerciseImage = [UIImage imageNamed:@"ExerciseIcon.png"];
            exerciseState = M13CheckboxStateUnchecked;
        }
    }
    
    // goal is nutrition
    else if ([goalID isEqualToString:@"SAeeSNsDWM"])
    {
        if (done)
        {
            nutritionImage = [UIImage imageNamed:@"CompletedIcon.png"];
            nutritionState = M13CheckboxStateChecked;
        }
        else
        {
            nutritionImage = [UIImage imageNamed:@"NutritionIcon.png"];
            nutritionState = M13CheckboxStateUnchecked;
        }
    }

}

#pragma mark - Save Data methods
- (void)saveGoalData:(NSString *)goalId checkState:(M13CheckboxState)checkState
{
    PFQuery *query = [PFQuery queryWithClassName:@"UserLog"];
    [query whereKey:@"UserID" equalTo:[[PFUser currentUser] objectId]];
    [query whereKey:@"Goal" equalTo:goalId];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
        {
            // There should only be one result
            if ([objects count] == 1)
            {
                PFObject *userLogObj = [objects objectAtIndex:0];
                [userLogObj deleteInBackground];
            }
            // No objects. Therefore, not set
            else if ([objects count] == 0)
            {
                PFObject *newUserLog = [PFObject objectWithClassName:@"UserLog"];
                [newUserLog setObject:@"Step Completed" forKey:@"Event"];
                [newUserLog setObject:goalId forKey:@"Goal"];
                [newUserLog setObject:[[PFUser currentUser] objectId] forKey:@"UserID"];
                [newUserLog saveInBackground];
                NSLog(@"added new object!");
            }
            
            // There was more than one result. Something happened.
            else
            {
                NSLog(@"Error: More than one result.");
            }
        }
        else
        {
            NSLog(@"Error: %@", error);
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
            [user addObjectsFromArray:objectArray forKey:@"ThriveStreams"];
            [user saveInBackground];
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

#pragma mark - UITableView Data Source delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [thriveItems count];
}

-(void)configureCell:(FundamentalGoalCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    // Meditation row
    if (indexPath.row == 0)
    {
        cell.goalLabel.text = @"Meditation";
        cell.checkbox.checkState = meditationState;
        cell.thriveImage.image = meditationImage;
        cell.parseObjectID = @"h3AOIcsUkd";
    }
    
    // Journal row
    else if (indexPath.row == 1)
    {
        cell.goalLabel.text = @"Journal";
        cell.checkbox.checkState = journalState;
        cell.thriveImage.image = journalImage;
        cell.parseObjectID = @"xj435NyIuW";
    }

    // Excercise row
    else if (indexPath.row == 2)
    {
        cell.goalLabel.text = @"Exercise";
        cell.checkbox.checkState = exerciseState;
        cell.thriveImage.image = exerciseImage;
        cell.parseObjectID = @"ZPHaJ8CjvS";
    }
    
    // Nutrition row
    else if (indexPath.row == 3)
    {
        cell.goalLabel.text = @"Nutrition";
        cell.checkbox.checkState = nutritionState;
        cell.thriveImage.image = nutritionImage;
        cell.parseObjectID = @"SAeeSNsDWM";
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FundamentalGoalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCellIdentifier"];
    
    [self configureCell:(FundamentalGoalCell *)cell atIndexPath:indexPath];
    
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark - actionsheet delegates
-(void)showOverlay
{
    // set up action
    NSString *settingsTitle = @"Settings";
    NSString *logoutTitle = @"Logout";
    NSString *cancelTitle = @"Cancel";
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:nil
                                      delegate:self
                                    cancelButtonTitle:cancelTitle
                                      destructiveButtonTitle:settingsTitle
                                      otherButtonTitles:logoutTitle, nil];
    
    //hack to change destructive button index so that the logout is at the bottom
    actionSheet.destructiveButtonIndex = 1;
    
    [actionSheet showInView:self.view];
}

-(void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    for (UIView *subview in actionSheet.subviews) {
        if ([subview isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)subview;
            button.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:16.0f];
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if  ([buttonTitle isEqualToString:@"Logout"])
    {
        //logout the user
        
        [PFUser logOut];
        NSLog(@"logout successful");
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate resetWindowToInitialView];
        
      /*  [[SMClient defaultClient] logoutOnSuccess:^(NSDictionary *result)
         {
             //reset the view to initial
             
             NSLog(@"logout successful");
             
             AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
             [appDelegate resetWindowToInitialView];
         } onFailure:^(NSError *error){
             NSLog(@"For some reason, couldn't log out. Here's the error: %@", error);
         }]; */
    }
    else if ([buttonTitle isEqualToString:@"Settings"])
    {
        [self performSegueWithIdentifier:@"toSettingsSegue" sender:self];
    }
    else if ([buttonTitle isEqualToString:@"Cancel"])
    {
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
