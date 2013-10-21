//
//  GoalViewController.m
//  ThriveStreams
//
//  Created by Ryan Badilla on 10/13/13.
//  Copyright (c) 2013 ThriveStreams. All rights reserved.
//

#import "GoalViewController.h"
#import "AppDelegate.h"
#import "FlatUIHelper.h"
#import "AppDelegate.h"
#import "ThriveButton.h"
#import "ThriveButtonMenu.h"
#import "MBProgressHUD.h"
#import <Parse/Parse.h>

@interface GoalViewController ()
{
    UIImage *whyImage;
    UIImage *toolsImage;
    UIImage *linksImage;
    UIImage *statsImage;
}

@end

@implementation GoalViewController

- (AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

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
    
    //initialize images with defaults
    whyImage = [UIImage imageNamed:@"MeditationIcon.png"];
    toolsImage = [UIImage imageNamed:@"JournalIcon.png"];
    linksImage = [UIImage imageNamed:@"ExerciseIcon.png"];
    statsImage = [UIImage imageNamed:@"NutritionIcon.png"];
    
    
    UIColor *meditationColor = [UIColor colorWithRed:155.0/255.0 green:89.0/255.0 blue:182.0/255.0 alpha:1.0f];
    UIColor *journalColor = [UIColor colorWithRed:241.0/255.0 green:196.0/255.0 blue:15.0/255.0 alpha:1.0f];
    UIColor *exerciseColor = [UIColor colorWithRed:46.0/255.0 green:204.0/255.0 blue:113.0/255.0 alpha:1.0f];
    UIColor *nutritionColor = [UIColor colorWithRed:230.0/255.0 green:126.0/255.0 blue:34.0/255.0 alpha:1.0f];
    
    
    // set up background color
    [self.view setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:240.0/255.0 blue:241.0/255.0 alpha:1.0]];
    
    ThriveButton *mainThriveButton = [[ThriveButton alloc]
                                      initAsMainButtonWithFrame:THRIVE_BUTTON_RECT_DEFAULT
                                      iconImage:[UIImage imageNamed:@"thriveButtonIcon.png"]
                                      subIconImage:[UIImage imageNamed:@"Xbutton.png"]
                                      borderColor: BUTTON_THRIVE_BORDER
                                      fillColor:BUTTON_THRIVE_FILL];
    
    ThriveButton *meditationButton = [[ThriveButton alloc] initAsSubButtonWithFrame:THRIVE_BUTTON_RECT_DEFAULT iconImage:[UIImage imageNamed:@"meditation_icon.png"] borderColor:meditationColor fillColor:meditationColor withBlock:^{

    }];
    
    ThriveButton *journalButton = [[ThriveButton alloc] initAsSubButtonWithFrame:THRIVE_BUTTON_RECT_DEFAULT iconImage:[UIImage imageNamed:@"journal_icon.png"] borderColor:journalColor fillColor:journalColor withBlock:^{

    }];
    
    ThriveButton *exerciseButton = [[ThriveButton alloc] initAsSubButtonWithFrame:THRIVE_BUTTON_RECT_DEFAULT iconImage:[UIImage imageNamed:@"exercise_icon.png"] borderColor:exerciseColor fillColor:exerciseColor withBlock:^{

    }];
    
    ThriveButton *nutritionButton = [[ThriveButton alloc] initAsSubButtonWithFrame:THRIVE_BUTTON_RECT_DEFAULT iconImage:[UIImage imageNamed:@"nutrition_icon.png"] borderColor:nutritionColor fillColor:nutritionColor withBlock:^{

    }];
    
    ThriveButtonMenu *menu = [[ThriveButtonMenu alloc] initWithFrame:THRIVEMENU_DEFAULT_SUPERVIEW_CGRECT parent:self mainButton:mainThriveButton subButtons:meditationButton, journalButton, exerciseButton, nutritionButton, nil];
    
    [self.view addSubview:menu];

    
    // set up the navigation controller
    self.navBar.topItem.title = @"Goal";
    
    [self.navBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor colorWithWhite:0.4 alpha:1.0],
      UITextAttributeTextColor,
      [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0],
      UITextAttributeTextShadowColor,
      [NSValue valueWithUIOffset:UIOffsetMake(0, 0)],
      UITextAttributeTextShadowOffset,
      [UIFont fontWithName:@"OpenSans" size:0.0],
      UITextAttributeFont,
      nil]];
    
     [self.view setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:240.0/255.0 blue:241.0/255.0 alpha:1.0]];
    
    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(cancel:)];
    
    NSDictionary* leftBarButtonDictionary = [NSDictionary dictionaryWithObjectsAndKeys: [UIColor colorWithRed:149.0/255.0 green:165.0/255.0 blue:166.0/255.0 alpha:1.0], UITextAttributeTextColor,
                                             [UIColor colorWithRed:149.0/255.0 green:165.0/255.0 blue:166.0/255.0 alpha:0.0], UITextAttributeTextShadowColor,
                                             [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeTextShadowOffset,
                                             [UIFont fontWithName:@"OpenSans" size:16.0], UITextAttributeFont,
                                             nil];
    
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithWhite:0.6 alpha:0.9]];
    
    [self.navItem.leftBarButtonItem setTitleTextAttributes:leftBarButtonDictionary forState:UIControlStateNormal];
    
    self.navItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"3dotButton.png"] style:UIBarStyleDefault target:self action:@selector(showOverlay)];

}

- (UIBarPosition)positionForBar:(id <UIBarPositioning>)bar
{
    return UIBarPositionTopAttached;
}

-(IBAction)cancel:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ActionSheetDelegate

-(void)showOverlay
{
    // set up action
    NSString *whyTitle = @"Why";
    NSString *toolsTitle = @"Tools";
    NSString *linksTitle = @"Links";
    NSString *statsTitle = @"Stats";
    NSString *cancelTitle = @"Cancel";
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:cancelTitle
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:toolsTitle, linksTitle, statsTitle,whyTitle, nil];
    
    [actionSheet showInView:self.view];
}

-(void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    for (UIView *subview in actionSheet.subviews) {
        if ([subview isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)subview;
            button.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:16.0f];
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:@"Why"])
    {
        
    }
    else if ([buttonTitle isEqualToString:@"Tools"])
    {
        
    }
    else if ([buttonTitle isEqualToString:@"Links"])
    {
        
    }
    else if ([buttonTitle isEqualToString:@"Stats"])
    {
        
    }
    else if ([buttonTitle isEqualToString:@"Cancel"])
    {
        
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
