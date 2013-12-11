//
//  GoalViewController.m
//  Uptimal
//
//  Created by Ryan Badilla on 11/14/13.
//  Copyright (c) 2013 ThriveStreams. All rights reserved.
//

#import "GoalViewController.h"
#import "MainViewController.h"
#import "MBProgressHUD.h"

@interface GoalViewController ()
{
    NSArray *sectionList;
    float tableHeight;
    
    NSArray *userSteps;
    PFObject *userGoal;
}

@end

@implementation GoalViewController

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
    
    //set up sectionList and tableHeigh
    sectionList = [NSArray arrayWithObjects:@"Steps", @"Activity", nil];
    tableHeight = (18 + 18) + ([_stepsArray count] * 44);
    
    self.view.backgroundColor = [UIColor colorWithRed:236.0/255.0 green:240.0/255.0 blue:241.0/255.0 alpha:1.0];
    
    //Background Imageview
    PFFile *image = [_goalObject objectForKey:@"Image"];
    UIImage *backgroundImage;
    if ([image isKindOfClass:NULL])
    {
        backgroundImage = [UIImage imageWithData:[image getData]];
    }
    else
    {
        backgroundImage = [UIImage imageNamed:@"defaultbackground.jpg"];
    }

    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height / 2)];
    backgroundImageView.image = backgroundImage;
    
    //add the goal Title section
    UIView *goalTitleSection = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, backgroundImageView.frame.size.height - 60, self.view.frame.size.width, 60.0)];
 
    [goalTitleSection setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:8.0]];
    
    UILabel *goalTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(70.0, 10.0, 230.0, 22.0)];
    goalTitleLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:18.0];
    goalTitleLabel.text = [_goalObject objectForKey:@"GoalDescription"];
    [goalTitleSection addSubview:goalTitleLabel];
    
    UIImageView *goalCreatorImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    goalCreatorImage.image = [UIImage imageNamed:@"uptimalIcon.png"];
    [goalCreatorImage setContentMode:UIViewContentModeScaleAspectFit];
    [goalTitleSection addSubview:goalCreatorImage];
    
    if (_createdByUser != nil)
    {
        // get the creator name and image
        UILabel *createdByLabel= [[UILabel alloc] initWithFrame:CGRectMake(70.0, 30.0, 230.0, 20.0)];
        createdByLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:12.0];
        createdByLabel.text = [NSString stringWithFormat:@"Created by %@ %@", [_createdByUser objectForKey:@"firstName"], [_createdByUser objectForKey:@"lastName"]];
        [goalTitleSection addSubview:createdByLabel];
        
        PFFile *image = [_createdByUser objectForKey:@"profileImage"];
        UIImage *userImage = [UIImage imageWithData:[image getData]];
        goalCreatorImage.image = userImage;
    }
    else
    {
        goalCreatorImage.image = [UIImage imageNamed:@"uptimalIcon"];;
    }
    
    [backgroundImageView addSubview:goalTitleSection];
    
    //init tableview
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    _tableView.separatorInset = UIEdgeInsetsZero;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    _tableView.tableHeaderView = backgroundImageView;
    _tableView.scrollEnabled = YES;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _tableView.bounces = NO;
    [self.view addSubview:_tableView];
    
    _activityFeedArray = [[NSMutableArray alloc] initWithObjects:@"Feed 1", @"Feed 2", @"Feed 3", @"Feed 4", @"Feed 5", @"Feed 6", @"Feed 7", @"Feed 8", @"Feed 9", @"Feed 10", @"Feed 11", @"Feed 12", @"Feed 13", @"Feed 14", @"Feed 15", @"Feed 16", @"Feed 17", @"Feed 18", @"Feed 19", @"Feed 20", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)done:(id)sender
{
    UIAlertView *privacyView = [[UIAlertView alloc]
                                initWithTitle:@"Privacy"
                                message:@"Would you like this goal to be visible to others?"
                                delegate:self
                                cancelButtonTitle:@"No"
                                otherButtonTitles:@"Yes", nil];
    [privacyView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.title isEqualToString:@"Privacy"])
    {
        BOOL visible;
        NSLog(@"visible: %d", buttonIndex);
    
        if (buttonIndex == 0)
            visible = YES;
        else
            visible = NO;
    
        [self copyGoalsAndReturn:visible];
    }
}

-(void)copyGoalsAndReturn:(BOOL)visible
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Adding your goal...";
  
    NSMutableArray *newSteps = [[NSMutableArray alloc] initWithCapacity:[_stepsArray count]];
    
    //first create the goal
    PFObject *newGoal = [[PFObject alloc] initWithClassName:@"Goal"];
    
    if (_goalObject[@"Category"] == nil)
        newGoal[@"Category"] = [NSNull null];
    else
        newGoal[@"Category"] = _goalObject[@"Category"];
    
    if (_goalObject[@"GoalDescription"] == nil)
        newGoal[@"GoalDescription"] = [NSNull null];
    else
        newGoal[@"GoalDescription"] = _goalObject[@"GoalDescription"];
    
    if (_goalObject[@"createdBy"] == nil)
        newGoal[@"createdBy"] = [NSNull null];
    else
        newGoal[@"createdBy"] = _goalObject[@"createdBy"];
    
    if (_goalObject[@"Image"] == nil)
        newGoal[@"Image"] = [NSNull null];
    else
        newGoal[@"Image"] = _goalObject[@"Image"];
    
    if (_goalObject[@"WhyDescription"] == nil)
        newGoal[@"WhyDescription"] = [NSNull null];
    else
        newGoal[@"WhyDescription"] = _goalObject[@"WhyDescription"];
    
    
    newGoal[@"RootGoalID"] = _goalObject.objectId;
    newGoal[@"isComplete"] = [NSNumber numberWithBool:NO];
    newGoal[@"isRemoved"] = [NSNumber numberWithBool:NO];
    newGoal[@"isVisible"] = [NSNumber numberWithBool:visible];
    
    [newGoal save];
    
    // point to the previous step;
    PFObject *previousStep;
    
    // initialize first step
    if ([_stepsArray count] != 0)
    {
        previousStep = [[PFObject alloc] initWithClassName:@"Goal"];
        PFObject *step = [_stepsArray objectAtIndex:0];
        previousStep[@"GoalDescription"] = step[@"GoalDescription"];
        previousStep[@"Parent"] = newGoal.objectId;
        previousStep[@"RootGoalID"] = _goalObject.objectId;
        if (step[@"WhyDescription"] == nil)
            previousStep[@"WhyDescription"] = [NSNull null];
        else
            previousStep[@"WhyDescription"] = step[@"WhyDescription"];
        if (step[@"recurrence"] == nil)
            previousStep[@"recurrence"] = [NSNull null];
        else
            previousStep[@"recurrence"] = step[@"recurrence"];
        
        newGoal[@"nextStep"] = previousStep;
        [newSteps addObject:previousStep];
    }
    
    //next add remaining steps
    for (int index = 1; index < [_stepsArray count]; index++)
    {
        PFObject *nextStep = [[PFObject alloc] initWithClassName:@"Goal"];
        PFObject *stepArrayPointer = [_stepsArray objectAtIndex:index];
        nextStep[@"GoalDescription"] = stepArrayPointer[@"GoalDescription"];
        nextStep[@"Parent"] = newGoal.objectId;
        nextStep[@"RootGoalID"] = _goalObject.objectId;
        nextStep[@"isComplete"] = [NSNumber numberWithBool:NO];
        nextStep[@"isRemoved"] = [NSNumber numberWithBool:NO];
        if (stepArrayPointer[@"WhyDescription"] == nil)
            nextStep[@"WhyDescription"] = [NSNull null];
        else
            nextStep[@"WhyDescription"] = stepArrayPointer[@"WhyDescription"];
        if (stepArrayPointer[@"recurrence"] == nil)
            nextStep[@"recurrence"] = [NSNull null];
        else
            nextStep[@"recurrence"] = stepArrayPointer[@"recurrence"];
        
        previousStep[@"nextStep"] = nextStep;
        
        previousStep = nextStep;
        
        [newSteps addObject:previousStep];
    }
    
    [[PFUser currentUser] addObject:newGoal forKey:@"Goals"];
    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError* error)
     {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
         if (succeeded)
             [self performSegueWithIdentifier:@"goalToMainSegue" sender:self];
         else
         {
             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Uh oh" message:error.description delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alertView show];
         }
     }];
    

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"tableViewHeight: %f", tableHeight);
    NSLog(@"Content offset x: %f", scrollView.contentOffset.x);
    NSLog(@"Content offset y: %f", scrollView.contentOffset.y);
    
        float speedFactorFirst = 3.5f;
    
        float speedFactorsecond = _scrollView.contentSize.width / scrollView.contentSize.width;
        
        // setting the x value of the contentOffset of the underlying scrollviews
        [_scrollView setContentOffset:CGPointMake(speedFactorFirst * scrollView.contentOffset.x, 0)];
        [_scrollViewBackground setContentOffset:CGPointMake(speedFactorsecond * scrollView.contentOffset.x, 0)];
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

#pragma mark - UITableView Data Source delegates
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0)
        return [_stepsArray count];
    else
        return [_activityFeedArray count];
}

-(UITableViewCell *)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    if (indexPath.section == 0)
    {
        PFObject *goal = [_stepsArray objectAtIndex:indexPath.row];
    
        cell.textLabel.text = [goal objectForKey:@"GoalDescription"];
        cell.textLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:14.0];
    }
    
    if (indexPath.section == 1)
    {
        cell.textLabel.text = [_activityFeedArray objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:14.0];
    }
        
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
    NSString *string =[sectionList objectAtIndex:section];
    [label setText:string];
    [view addSubview:label];
    [view addSubview:arrow];
    [view setBackgroundColor:[UIColor colorWithRed:189/255.0 green:195/255.0 blue:199/255.0 alpha:1.0]];
    return view;

}


@end
