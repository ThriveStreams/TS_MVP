//
//  ResetPasswordViewController.h
//  Uptimal
//
//  Created by Ryan Badilla on 11/19/13.
//  Copyright (c) 2013 ThriveStreams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResetPasswordViewController : UIViewController <UIAlertViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UILabel *resetPasswordLabel;
@property (nonatomic, strong) IBOutlet UITextField *emailField;

@end
