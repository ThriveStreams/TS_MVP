//
//  UserGoalViewController.h
//  Uptimal
//
//  Created by Ryan Badilla on 12/10/13.
//  Copyright (c) 2013 ThriveStreams. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface UserGoalViewController : UIViewController <UIAlertViewDelegate, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>

@property (nonatomic, strong) NSString *goalTitle;
@property (nonatomic, strong) NSString *creatorName;

@property (nonatomic, strong) PFObject *goalObject;
@property (nonatomic, strong) PFUser *createdByUser;

@property (nonatomic, strong) NSMutableArray *stepsArray;
@property (nonatomic, strong) NSMutableArray *activityFeedArray;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIScrollView *scrollViewBackground;

@property (nonatomic, strong) UITableView *tableView;

- (IBAction)showMenu:(id)sender;
- (IBAction)back:(id)sender;


@end
