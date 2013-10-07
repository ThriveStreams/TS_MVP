//
//  Goal.h
//  ThriveStreams
//
//  Created by Ryan Badilla on 10/5/13.
//  Copyright (c) 2013 ThriveStreams. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Goal : NSManagedObject

@property (nonatomic, retain) NSDate * lastmoddate;
@property (nonatomic, retain) NSDate * createddate;
@property (nonatomic, retain) NSString * goalId;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * isdone;
@property (nonatomic, retain) User *user;


@end
