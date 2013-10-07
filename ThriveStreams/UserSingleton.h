//
//  UserSingleton.h
//  ThriveStreams
//
//  Created by Ryan Badilla on 5/1/13.
//  Copyright (c) 2013 ThriveStreams. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StackMob.h"
#import "User.h"
#import "AppDelegate.h"

@interface UserSingleton : NSObject
{
    NSManagedObject *managedObject;
}

@property (nonatomic, strong) NSDictionary *userDataDictionary;
@property (nonatomic, strong) id userDataID;
@property (nonatomic, strong) UIImage *userImage;

+(id)sharedManager;

- (id)initWithId:(id)userObjectID;
- (id)initWithId:(id)userObjectID image:(UIImage *)userImage;
- (id)initWithDictionary:(NSDictionary *)userObjectDictionary;
- (id)initWithDictionaryAndImage:(NSDictionary *)userObjectDictionary image:(UIImage *)userImage;
-(void)setId:(id)userObject;
-(void)setImage:(UIImage *)userImage;


-(void)setUserDataDictionary:(NSDictionary *)userDataDictionary;
-(UIImage *)returnUserImage;
- (id)returnUserId;
- (NSDictionary *)returnDictionary;

@end
