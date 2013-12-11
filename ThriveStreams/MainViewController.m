//
//  MainViewController.m
//  Uptimal
//
//  Created by Ryan Badilla on 10/4/13.
//  Copyright (c) 2013 ThriveStreams. All rights reserved.
//

#import "MainViewController.h"
#import "FlatUIHelper.h"
#import "ThriveButton.h"
#import "ThriveButtonMenu.h"
#import "MBProgressHUD.h"
#import "GoalViewController.h"
#import <Parse/Parse.h>
#import "AppDelegate.h"
#import "ArrowView.h"
#import "GoalListViewController.h"
#import "UserGoalViewController.h"
#import "SettingsViewController.h"

@interface MainViewController ()
{
    NSMutableString *fullname;
    
    NSMutableArray *_goalArray;
    NSMutableArray *_accomplishedGoalsArray;
    
    NSArray *_tableSections;
    
    
    ThriveButtonMenu *thriveMenu;
    
    UIImage *meditationImage;
    UIImage *journalImage;
    UIImage *exerciseImage;
    UIImage *nutritionImage;
}
@end

@implementation MainViewController

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

    _userImage.image = _profileImage;

    // setup table sections
    _tableSections = [[NSArray alloc] initWithObjects:@"Goals", @"Accomplished", nil];
    
    // populate user labels
    _nameLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:16.0];
    _nameLabel.text = [NSString stringWithFormat:@"%@ %@", _firstname, _lastname];
    _stepsLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:12.0];
    _stepsLabel.text = @"0 Steps Taken";
    _followersLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:12.0];
    _followersLabel.text = @"0 Followers";
    
    UIColor *addGoalColor = [UIColor colorWithRed:46.0/255.0 green:204.0/255.0 blue:113.0/255.0 alpha:1.0f];
    UIColor *photoColor = [UIColor colorWithRed:52.0/255.0 green:152.0/255.0 blue:219.0/255.0 alpha:1.0f];
    UIColor *editColor = [UIColor colorWithRed:241.0/255.0 green:196.0/255.0 blue:15.0/255.0 alpha:1.0f];
 
    // set up background color
    [self.view setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:240.0/255.0 blue:241.0/255.0 alpha:1.0]];
    
    ThriveButton *mainThriveButton = [[ThriveButton alloc]
                                      initAsMainButtonWithFrame:THRIVE_BUTTON_RECT_DEFAULT
                                      iconImage:[UIImage imageNamed:@"uptimalBanner.png"]
                                      subIconImage:[UIImage imageNamed:@"Xbutton.png"]
                                      borderColor: BUTTON_THRIVE_BORDER
                                      fillColor:BUTTON_THRIVE_FILL];

    ThriveButton *addButton = [[ThriveButton alloc] initAsSubButtonWithFrame:THRIVE_BUTTON_RECT_DEFAULT iconImage:[UIImage imageNamed:@"addGoal.png"] borderColor:addGoalColor fillColor:addGoalColor withBlock:^{
        
        [self performSegueWithIdentifier:@"AddGoalSegue" sender: self];

    }];
    
    ThriveButton *photoButton = [[ThriveButton alloc] initAsSubButtonWithFrame:THRIVE_BUTTON_RECT_DEFAULT iconImage:[UIImage imageNamed:@"camera.png"] borderColor:photoColor fillColor:photoColor withBlock:^{

    }];
    
    ThriveButton *editButton = [[ThriveButton alloc] initAsSubButtonWithFrame:THRIVE_BUTTON_RECT_DEFAULT iconImage:[UIImage imageNamed:@"pencil.png"] borderColor:editColor fillColor:editColor withBlock:^{

    }];

    
    ThriveButtonMenu *menu = [[ThriveButtonMenu alloc] initWithFrame:THRIVEMENU_DEFAULT_SUPERVIEW_CGRECT parent:self mainButton:mainThriveButton subButtons:addButton, photoButton, editButton, nil];
    
    // store a pointer to the menu
    thriveMenu = menu;
    
    [self.view addSubview:menu];
    //
    // end of ThriveMenu setup
    //
    
    // set up table view
    _tableView.separatorInset = UIEdgeInsetsZero;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    
    // set up navigationbar
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithWhite:0.6 alpha:0.9]];
 /*   UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 260, 20)];
    [logo setImage:[UIImage imageNamed:@"TS_Logo_BPLAN2.png"]];
    [logo setContentMode:UIViewContentModeScaleAspectFit];
    self.navigationItem.titleView = logo; */
    self.navigationItem.title = @"Uptimal";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"3dotButton.png"] style:UIBarStyleDefault target:self action:@selector(showOverlay)];
    
    // hack to push navigation bar image
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, 4)]];
    self.navigationItem.leftBarButtonItem.enabled = NO;
    
    
    [self populateGoals];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"viewWillAppear called");
    [self populateGoals];
    [_tableView reloadData];

}

- (void)displayIntroOverlay
{
    // hide the thrive menu
    [thriveMenu setHidden:YES];
    
    // initialize overlay view
    UIView *overlayView = [[UIView alloc] initWithFrame:self.view.frame];
    [overlayView setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.5]];
    
    // setup Label
    __block BOOL didTap = NO;
    UILabel *tapLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 245, 280, 28)];
    [tapLabel setTextAlignment:NSTextAlignmentCenter];
    [tapLabel setTextColor:[UIColor colorWithWhite:1.0 alpha:1.0]];
    [tapLabel setFont:[UIFont fontWithName:@"OpenSans-Light" size:14.0]];
    [tapLabel setText:@"Tap to Uptimize"];
    [overlayView addSubview:tapLabel];
    
    UILabel *addGoalLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 245, 280, 28)];
    [addGoalLabel setTextAlignment:NSTextAlignmentCenter];
    [addGoalLabel setTextColor:[UIColor colorWithWhite:1.0 alpha:1.0]];
    [addGoalLabel setFont:[UIFont fontWithName:@"OpenSans-Light" size:14.0]];
    [addGoalLabel setText:@"Tap to Add Goal"];
    [overlayView addSubview:addGoalLabel];
    [addGoalLabel setAlpha:0.0];
    
    //setup Arrow
    ArrowView *arrow = [[ArrowView alloc] initWithFrame:
                        CGRectMake((self.view.frame.size.width / 2) - 10,
                                   280, 20, 200)];
    [overlayView addSubview:arrow];
    
    
    // initialize ThriveButton
    ThriveButton *mainThriveButton = [[ThriveButton alloc]
                                      initAsMainButtonWithFrame:THRIVE_BUTTON_RECT_DEFAULT
                                      iconImage:[UIImage imageNamed:@"uptimalBanner.png"]
                                      subIconImage:[UIImage imageNamed:@"Xbutton.png"]
                                      borderColor: BUTTON_THRIVE_BORDER
                                      fillColor:BUTTON_THRIVE_FILL];
    [mainThriveButton setBlockCode:^{
        didTap = !didTap;
        
        if (didTap)
        {
            [UIView animateWithDuration:0.4
                                  delay:0.0
                                options:UIViewAnimationOptionTransitionCrossDissolve
                             animations:^{
                                 tapLabel.alpha = 0.0;
                                 addGoalLabel.alpha = 1.0;
                                 arrow.frame = CGRectMake(arrow.frame.origin.x, arrow.frame.origin.y,
                                        arrow.frame.size.width, arrow.frame.size.height - 75.0);
                             }
                             completion:nil];
        }
        else
        {
            [UIView animateWithDuration:0.4
                                  delay:0.0
                                options:UIViewAnimationOptionTransitionCrossDissolve
                             animations:^{
                                 tapLabel.alpha = 1.0;
                                 addGoalLabel.alpha = 0.0;
                                 arrow.frame = CGRectMake(arrow.frame.origin.x, arrow.frame.origin.y,
                                                          arrow.frame.size.width, arrow.frame.size.height + 75.0);
                             }
                             completion:nil];
        }
    }];

    ThriveButton *goalButton = [[ThriveButton alloc]
                                initAsSubButtonWithFrame:THRIVE_BUTTON_RECT_DEFAULT
                                iconImage:[UIImage imageNamed:@"addGoal.png"]
                                borderColor:[UIColor colorWithRed:46.0/255.0 green:204.0/255.0 blue:113.0/255.0 alpha:1.0f]
                                fillColor:[UIColor colorWithRed:46.0/255.0 green:204.0/255.0 blue:113.0/255.0 alpha:1.0f]
                                withBlock:^{
                                    didTap = !didTap;
                                    if (didTap)
                                    {
                                        [UIView animateWithDuration:0.4
                                                              delay:0.0
                                                            options:UIViewAnimationOptionTransitionCrossDissolve
                                                         animations:^{
                                                             tapLabel.alpha = 0.0;
                                                             addGoalLabel.alpha = 1.0;
                                                             arrow.frame = CGRectMake(arrow.frame.origin.x, arrow.frame.origin.y,
                                                                    arrow.frame.size.width, arrow.frame.size.height - 75.0);
                                                         }
                                                         completion:nil];
                                    }
                                    else
                                    {
                                        [UIView animateWithDuration:0.4
                                                              delay:0.0
                                                            options:UIViewAnimationOptionTransitionCrossDissolve
                                                         animations:^{
                                                             tapLabel.alpha = 1.0;
                                                             addGoalLabel.alpha = 0.0;
                                                             arrow.frame = CGRectMake(arrow.frame.origin.x, arrow.frame.origin.y,
                                                                arrow.frame.size.width, arrow.frame.size.height + 75.0);
                                                         }
                                                         completion:nil];
                                    }
                                    
                                    [self performSegueWithIdentifier:@"AddGoalSegue" sender:self];

                                }];
    
    ThriveButtonMenu *introMenu = [[ThriveButtonMenu alloc] initWithFrame:THRIVEMENU_DEFAULT_SUPERVIEW_CGRECT parent:self mainButton:mainThriveButton subButtons:goalButton, nil];
    
    
    [overlayView addSubview:introMenu];
    
    [self.view addSubview:overlayView];
    
}

#pragma mark - Populate goals
- (void)populateGoals
{

    NSArray *userGoalsArray = PFUser.currentUser[@"Goals"];
    
    // initialize goalArray and accomplishedGoalArray
    _goalArray = [[NSMutableArray alloc] initWithCapacity:[userGoalsArray count]];
    _accomplishedGoalsArray = [[NSMutableArray alloc] initWithCapacity:[userGoalsArray count]];
    
    //user has no goals set, so set up intro
    if ([userGoalsArray count] == 0)
    {
        [self displayIntroOverlay];
    }
    
    else
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"Getting your goals...";
        
        NSArray *userGoals = PFUser.currentUser[@"Goals"];
        for (PFObject *userGoal in userGoals)
        {
            [userGoal fetch];
            if (userGoal[@"isComplete"] == [NSNumber numberWithBool:YES])
                [_accomplishedGoalsArray addObject:userGoal];
            else if (userGoal[@"isRemoved"] == [NSNumber numberWithBool:NO])
                [_goalArray addObject:userGoal];
            
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
}

#pragma mark - Get Goal method
- (PFObject *)getGoalData:(NSString *)goalId
{
    PFObject* goalObj;
    NSArray *foundObjects;
    PFQuery *query = [PFQuery queryWithClassName:@"Goal"];
    [query whereKey:@"Goal" equalTo:goalId];
    
    foundObjects = [query findObjects];
    
    // there should only be one object found
    if ([foundObjects count] == 1)
    {
        PFObject *goal = [foundObjects objectAtIndex:0];
        goalObj = goal;
    }
    
    return goalObj;
}

#pragma mark - UITableView Data Source delegates
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (indexPath.section == 0)
        [self performSegueWithIdentifier: @"userGoalSegue" sender: [_goalArray objectAtIndex:indexPath.row]];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [_tableSections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0)
    {
        return [_goalArray count];
    }
    else
    {
        return [_accomplishedGoalsArray count];
    }
}

-(UITableViewCell *)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    PFObject *goal;
    
    if (indexPath.section == 0)
        goal = [_goalArray objectAtIndex:indexPath.row];
    else
        goal = [_accomplishedGoalsArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [goal objectForKey:@"GoalDescription"];
    cell.textLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:16.0];
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [self configureCell:cell atIndexPath:indexPath];
    cell = [self configureCell:cell atIndexPath:indexPath];
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

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(10, 7, 10, 10)];
    [arrow setContentMode:UIViewContentModeScaleAspectFit];
    [arrow setImage:[UIImage imageNamed:@"white_>.png"]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 2, tableView.frame.size.width, 18)];
    [label setFont:[UIFont fontWithName:@"OpenSans-Bold" size:12.0]];
    [label setTextColor:[UIColor colorWithWhite:1.0 alpha:1.0]];
    NSString *string =[_tableSections objectAtIndex:section];
    [label setText:string];
    [view addSubview:label];
    [view addSubview:arrow];
    [view setBackgroundColor:[UIColor colorWithRed:189/255.0 green:195/255.0 blue:199/255.0 alpha:1.0]];
    return view;
    
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
            button.titleLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:16.0f];
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

    }
    else if ([buttonTitle isEqualToString:@"Settings"])
    {
        [self performSegueWithIdentifier:@"toSettingsSegue" sender:self];
    }
    else if ([buttonTitle isEqualToString:@"Cancel"])
    {
        
    }
}

#pragma mark - Image profile 
/*
- (IBAction)selectPhoto:(id)sender {
    NSLog(@"tapped");
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
     [picker dismissViewControllerAnimated:YES completion:NULL];
    
} */



#pragma mark - prepareforsegue

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AddGoalSegue"])
    {
        NSMutableArray *goalArray = [[NSMutableArray alloc] initWithCapacity:100];
        
        // pull data from parse
        PFQuery *query = [PFQuery queryWithClassName:@"Goal"];
        [query whereKeyExists:@"Category"];
        [query whereKeyDoesNotExist:@"RootGoalID"];
        NSArray * foundObjects = [query findObjects];
        
        [_activityIndicator startAnimating];
        [query findObjects];
        
        for (PFObject *object in foundObjects)
        {
            NSString *categoryName = [object objectForKey:@"Category"];
            if (![goalArray containsObject:categoryName])
                    [goalArray addObject:categoryName];
        }
            
        UINavigationController *navigationController = segue.destinationViewController;
        GoalListViewController *controller = (GoalListViewController *)navigationController.topViewController;
        controller.goalArray = goalArray;
        
        [_activityIndicator stopAnimating];
    }
    else if ([segue.identifier isEqualToString:@"userGoalSegue"])
    {
        UINavigationController *navigationController = segue.destinationViewController;
        UserGoalViewController *controller= (UserGoalViewController *)navigationController.topViewController;
        
        PFObject *goal = sender;
        NSMutableArray *stepsArray = [[NSMutableArray alloc] initWithCapacity:100];
        
        // get the creator
        NSString *createdBy = [goal objectForKey:@"createdBy"];
        PFQuery *query = [PFUser query];
        PFUser *creator = (PFUser *)[query getObjectWithId:createdBy];
        
        // get the steps
        stepsArray = [self getSteps:stepsArray currentStep:sender];
        
        // send data to view controller
        controller.goalObject = goal;
        controller.stepsArray = stepsArray;
        controller.createdByUser = creator;

    }
}

-(NSMutableArray *)getSteps:(NSMutableArray *)array currentStep:(PFObject *)currentStep
{
    
    PFObject * nextStep = [currentStep objectForKey:@"nextStep"];
    [nextStep fetchIfNeeded];
    
    if (nextStep != nil)
    {
        [array addObject:nextStep];
        return [self getSteps:array currentStep:nextStep];
    }
    
    return array;
    
}

- (IBAction)tapEditButton:(id)sender
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    SettingsViewController *viewController = (SettingsViewController *)[storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
    [self presentViewController:viewController animated:YES completion:nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
