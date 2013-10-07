//
//  UserSingleton.m
//  ThriveStreams
//
//  Created by Ryan Badilla on 5/1/13.
//  Copyright (c) 2013 ThriveStreams. All rights reserved.
//

#import "UserSingleton.h"

@implementation UserSingleton

+(id)sharedManager
{
    static UserSingleton *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}


- (id)init {
    if (self = [super init]) {
    }
    return self;
}

- (id)initWithId:(id)userObjectID {
    if (self = [super init]) {
        _userDataID = userObjectID;
    }
    return self;
}

- (id)initWithId:(id)userObjectID image:(UIImage *)userImage {
    if (self = [super init]) {
        _userDataID = userObjectID;
        _userImage = userImage;
    }
    return self;
}


- (id)initWithDictionary:(NSDictionary *)userObjectDictionary {
    if (self = [super init]) {
        _userDataDictionary = userObjectDictionary;
        _userImage = nil;
    }
    return self;
}


- (id)initWithDictionaryAndImage:(NSDictionary *)userObjectDictionary image:(UIImage *)userImage {
    if (self = [super init]) {
        _userDataDictionary = userObjectDictionary;
        _userImage = userImage;
    }
    return self;
}


-(void)setId:(id)userObject
{
    _userDataID = userObject;
}

-(void)setImage:(UIImage *)userImage
{
    _userImage = userImage;
}

-(void)setUserDataDictionary:(NSDictionary *)userDataDictionary
{
    _userDataDictionary = userDataDictionary;
}

- (id)returnUserId
 {
     return _userDataID;
 }

-(UIImage *)returnUserImage
{
    return _userImage;
}

- (NSDictionary *)returnDictionary
{
    return _userDataDictionary;
}

@end
