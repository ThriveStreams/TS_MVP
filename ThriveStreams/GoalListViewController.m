//
//  GoalListViewController.m
//  Uptimal
//
//  Created by Ryan Badilla on 11/13/13.
//  Copyright (c) 2013 ThriveStreams. All rights reserved.
//

#import "GoalListViewController.h"
#import <Parse/Parse.h>
#import "GoalCategoryViewController.h"

@interface GoalListViewController ()

@end

@implementation GoalListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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

- (void)configureCell:(UITableViewCell *)cell withGoalName:(NSString *)goalName
{
    UILabel *label = (UILabel *)[cell viewWithTag:1000];
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
    [self performSegueWithIdentifier:@"GoalCategorySegue" sender:[_goalArray objectAtIndex:indexPath.row]];
}

// Cancel the current view
- (IBAction)done:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

// 
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"GoalCategorySegue"])
    {
        UINavigationController *navigationController = segue.destinationViewController;
        GoalCategoryViewController *controller = (GoalCategoryViewController *)navigationController.topViewController;
        
        PFQuery *query = [PFQuery queryWithClassName:@"Goal"];
        [query whereKey:@"Category" equalTo:sender];
        [query whereKeyDoesNotExist:@"RootGoalID"];
        
        NSMutableArray *goalArray = [[NSMutableArray alloc] initWithArray:[query findObjects]];;
        
        controller.goalArray = goalArray;
        controller.navigationTitle = sender;
        
        
    }
}

@end
