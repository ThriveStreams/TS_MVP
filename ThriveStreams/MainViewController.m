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
#import "User.h"
#import "Goal.h"

@interface MainViewController ()
{

    NSArray *thriveItems;
    NSMutableString *fullname;
    NSArray *goalList;
    
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
        [self saveGoalData:@"Meditation" checkState:meditationState];
        
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
        
        [self saveGoalData:@"Journal" checkState:journalState];
        
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
        [self saveGoalData:@"Exercise" checkState:journalState];

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
        [self saveGoalData:@"Nutrition" checkState:nutritionState];
    
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
    [logo setImage:[UIImage imageNamed:@"TS_Logo_BPLAN.png"]];
    [logo setContentMode:UIViewContentModeScaleAspectFit];
    self.navigationItem.titleView = logo;
    
    NSLog(@"CRECT: %f, %f, %f, %f", logo.frame.origin.x, logo.frame.origin.y, logo.frame.size.height, logo.frame.size.width);
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"3dotButton.png"] style:UIBarStyleDefault target:self action:@selector(showOverlay)];
    
   // self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@". . ." style:UIBarButtonItemStylePlain target:self action:@selector(showOverlay)];
    
    [self populateGoals];
}

#pragma mark - Populate goals
- (void)populateGoals
{
    // populate goals
    UserSingleton *singleton = [UserSingleton sharedManager];
    NSDictionary *userInfo = [singleton returnDictionary];
    NSString *username = [userInfo objectForKey:@"username"];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Getting your goals...";
    
    NSFetchRequest *goalFetch = [[NSFetchRequest alloc] initWithEntityName:@"Goal"];
    [goalFetch setPredicate:[NSPredicate predicateWithFormat:@"user == %@",username]];
 
    [self.managedObjectContext executeFetchRequest:goalFetch onSuccess:^(NSArray *results) {
        if ([results count] > 0) {
            for (int index = 0; index < [results count]; index++)
            {
                Goal *goal = [results objectAtIndex:index];
                if ([goal.title isEqualToString:@"Meditation"])
                {
                    if ([goal.isdone boolValue])
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
                else if ([goal.title isEqualToString:@"Journal"])
                {
                    if ([goal.isdone boolValue])
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
                else if ([goal.title isEqualToString:@"Exercise"])
                {
                    if ([goal.isdone boolValue])
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
                else if ([goal.title isEqualToString:@"Nutrition"])
                {
                    if ([goal.isdone boolValue])
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
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [_tableView reloadData];
    }onFailure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma mark - Save Data methods

- (void)saveGoalData:(NSString *)goalTitle checkState:(M13CheckboxState)checkState
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Updating goal...";
    
    UserSingleton *singleton = [UserSingleton sharedManager];
    NSDictionary *userInfo = [singleton returnDictionary];
    NSString *username = [userInfo objectForKey:@"username"];
    
    NSFetchRequest *goalFetch = [[NSFetchRequest alloc] initWithEntityName:@"Goal"];
    [goalFetch setPredicate:[NSPredicate predicateWithFormat:@"(title == %@) AND (user == %@)", goalTitle, username]];
    
    [self.managedObjectContext executeFetchRequest:goalFetch onSuccess:^(NSArray *results) {
        if ([results count] > 0) {
            Goal *goal = [results objectAtIndex:0];
            if (checkState == M13CheckboxStateChecked)
            {
                [goal setValue:[NSNumber numberWithBool:YES] forKey:@"isdone"];
            }
            else
            {
                [goal setValue:[NSNumber numberWithBool:NO] forKey:@"isdone"];
            }
            
            [self.managedObjectContext saveOnSuccess:^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
                hud.mode = MBProgressHUDModeCustomView;
                hud.labelText = @"Goal updated!";
                [hud hide:YES afterDelay:1];
                
                NSLog(@"success");
            } onFailure:^(NSError *error) {
                NSLog(@"There was an error! %@", error);
            }];
            
        }
       else
       {
           [self addDefaultGoals];
       }
    } onFailure:^(NSError *error){
        
    }];
}

- (void)addDefaultGoals
{
    UserSingleton *singleton = [UserSingleton sharedManager];
    NSDictionary *userInfo = [singleton returnDictionary];
    NSString *username = [userInfo objectForKey:@"username"];
    
    NSFetchRequest *userFetch = [[NSFetchRequest alloc] initWithEntityName:@"Goal"];
    [userFetch setPredicate:[NSPredicate predicateWithFormat:@"User == %@", username]];
    
    [self.managedObjectContext executeFetchRequest:userFetch onSuccess:^(NSArray *results) {
        if ([results count] > 0) {
            User *currentUser = (User *)[results objectAtIndex:0];
            
            Goal *meditationGoal = [NSEntityDescription insertNewObjectForEntityForName:@"Goal" inManagedObjectContext:self.managedObjectContext];
            
            [meditationGoal setValue:[NSNumber numberWithBool:NO] forKey:@"isdone"];
            [meditationGoal setValue:@"Meditation" forKey:@"title"];
            [meditationGoal setValue:[meditationGoal assignObjectId] forKey:[meditationGoal primaryKeyField]];
            
            Goal *journalGoal = [NSEntityDescription insertNewObjectForEntityForName:@"Goal" inManagedObjectContext:self.managedObjectContext];
            
            [journalGoal setValue:[NSNumber numberWithBool:NO] forKey:@"isdone"];
            [journalGoal setValue:@"Journal" forKey:@"title"];
            [journalGoal setValue:[journalGoal assignObjectId] forKey:[journalGoal primaryKeyField]];
            
            Goal *exerciseGoal = [NSEntityDescription insertNewObjectForEntityForName:@"Goal" inManagedObjectContext:self.managedObjectContext];
            
            [exerciseGoal setValue:[NSNumber numberWithBool:NO] forKey:@"isdone"];
            [exerciseGoal setValue:@"Exercise" forKey:@"title"];
            [exerciseGoal setValue:[exerciseGoal assignObjectId] forKey:[exerciseGoal primaryKeyField]];
            
            Goal *nutritionGoal = [NSEntityDescription insertNewObjectForEntityForName:@"Goal" inManagedObjectContext:self.managedObjectContext];
            
            [nutritionGoal setValue:[NSNumber numberWithBool:NO] forKey:@"isdone"];
            [nutritionGoal setValue:@"Nutrition" forKey:@"title"];
            [nutritionGoal setValue:[nutritionGoal assignObjectId] forKey:[nutritionGoal primaryKeyField]];
            
            NSError *error = nil;
            if (![self.managedObjectContext saveAndWait:&error]) {
                NSLog(@"There was an error! %@", error);
            }
            else {
                NSLog(@"Created goals with goals!");
            }
            
            [currentUser addGoalObject:meditationGoal];
            [currentUser addGoalObject:journalGoal];
            [currentUser addGoalObject:exerciseGoal];
            [currentUser addGoalObject:nutritionGoal];
            
            [self.managedObjectContext saveOnSuccess:^{
                
                NSLog(@"goals added to current user");
                
            } onFailure:^(NSError *error) {
                NSLog(@"Login Fail: %@",error);
                NSString *errorString = [error description];
                UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Oh no!" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [errorAlertView show];
            }];
        }
    }
    onFailure:^(NSError *error){
        NSLog(@"Login Fail: %@",error);
        NSString *errorString = [error description];
        UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Oh no!" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [errorAlertView show];
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
    }
    
    // Journal row
    else if (indexPath.row == 1)
    {
        cell.goalLabel.text = @"Journal";
        cell.checkbox.checkState = journalState;
        cell.thriveImage.image = journalImage;
    }

    // Excercise row
    else if (indexPath.row == 2)
    {
        cell.goalLabel.text = @"Exercise";
        cell.checkbox.checkState = exerciseState;
        cell.thriveImage.image = exerciseImage;
    }
    
    // Nutrition row
    else if (indexPath.row == 3)
    {
        cell.goalLabel.text = @"Nutrition";
        cell.checkbox.checkState = nutritionState;
        cell.thriveImage.image = nutritionImage;
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

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if  ([buttonTitle isEqualToString:@"Logout"])
    {
        //logout the user
        [[SMClient defaultClient] logoutOnSuccess:^(NSDictionary *result)
         {
             //reset the view to initial
             NSLog(@"logout successful");
             
             AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
             [appDelegate resetWindowToInitialView];
         } onFailure:^(NSError *error){
             NSLog(@"For some reason, couldn't log out. Here's the error: %@", error);
         }];
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
