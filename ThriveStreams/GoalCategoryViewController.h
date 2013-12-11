//
//  GoalCategoryViewController.h
//  Uptimal
//
//  Created by Ryan Badilla on 11/13/13.
//  Copyright (c) 2013 ThriveStreams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoalCategoryViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *goalArray;
@property (nonatomic, strong) NSString *navigationTitle;

- (IBAction)back:(id)sender;

@end
