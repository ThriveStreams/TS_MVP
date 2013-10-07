//
//  MainViewController.h
//  ThriveStreams
//
//  Created by Ryan Badilla on 10/4/13.
//  Copyright (c) 2013 ThriveStreams. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StackMob.h"
#import "M13Checkbox.h"

@interface MainViewController : UIViewController <UIActionSheetDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) SMClient *client;

- (void)saveGoalData:(NSString *)goalId checkState:(M13CheckboxState)checkState;

@end
