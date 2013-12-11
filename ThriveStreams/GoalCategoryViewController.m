//
//  GoalCategoryViewController.m
//  Uptimal
//
//  Created by Ryan Badilla on 11/13/13.
//  Copyright (c) 2013 ThriveStreams. All rights reserved.
//

#import "GoalCategoryViewController.h"
#import "GoalViewController.h"
#import <Parse/Parse.h>

@interface GoalCategoryViewController ()

@end

@implementation GoalCategoryViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationController.navigationItem.title = _navigationTitle;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_goalArray count];
}

- (void)configureCell:(UITableViewCell *)cell withGoalName:(PFObject *)goal
{
    UILabel *label = (UILabel *)[cell viewWithTag:1000];
    NSString *goalName = [goal objectForKey:@"GoalDescription"];
    label.text = goalName;
    label.font = [UIFont fontWithName:@"OpenSans-Light" size:16.0];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"GoalCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [self configureCell:cell withGoalName:[_goalArray objectAtIndex:indexPath.row]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"AddNewGoalSegue" sender:[_goalArray objectAtIndex:indexPath.row]];
}

// Cancel the current view
- (IBAction)back:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AddNewGoalSegue"])
    {
        UINavigationController *navigationController = segue.destinationViewController;
        GoalViewController *controller= (GoalViewController *)navigationController.topViewController;
        
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

@end
