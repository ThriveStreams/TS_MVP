//
//  GoalListViewController.h
//  Uptimal
//
//  Created by Ryan Badilla on 11/13/13.
//  Copyright (c) 2013 ThriveStreams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoalListViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *goalArray;

- (IBAction)done:(id)sender;

@end
