//
//  MainViewController.h
//  Uptimal
//
//  Created by Ryan Badilla on 10/4/13.
//  Copyright (c) 2013 ThriveStreams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController <UIActionSheetDelegate, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate>


@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *stepsLabel;
@property (nonatomic, strong) IBOutlet UILabel *followersLabel;
@property (nonatomic, strong) IBOutlet UIImageView *userImage;

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) IBOutlet UIButton *editButton;

@property (nonatomic, strong) NSString *firstname;
@property (nonatomic, strong) NSString *lastname;

@property (nonatomic, strong) UIImage *profileImage;

- (IBAction)tapEditButton:(id)sender;
- (void)populateGoals;

@end
