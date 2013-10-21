//
//  GoalViewController.h
//  ThriveStreams
//
//  Created by Ryan Badilla on 10/13/13.
//  Copyright (c) 2013 ThriveStreams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoalViewController : UIViewController <UIActionSheetDelegate, UINavigationBarDelegate>

@property (nonatomic, strong) IBOutlet UINavigationBar *navBar;
@property (nonatomic, strong) IBOutlet UINavigationItem *navItem;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;


@property (nonatomic, strong) NSString *goalTitle;
@property (nonatomic, strong) NSString *goalDescription;
@property (nonatomic, strong) NSArray *goalLinks;
@property (nonatomic, strong) NSArray *goalApps;

@end
