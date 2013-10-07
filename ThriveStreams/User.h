//
//  User.h
//  ThriveStreams
//
//  Created by Ryan Badilla on 10/5/13.
//  Copyright (c) 2013 ThriveStreams. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "StackMob.h"

@interface User : SMUserManagedObject


@property (nonatomic, retain) NSDate * createddate;
@property (nonatomic, retain) NSString * firstname;
@property (nonatomic, retain) NSDate * lastmoddate;
@property (nonatomic, retain) NSString * lastname;
@property (nonatomic, retain) NSString * userimage;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSSet *goal;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addGoalObject:(NSManagedObject *)value;
- (void)removeGoalObject:(NSManagedObject *)value;
- (void)addGoal:(NSSet *)values;
- (void)removeGoal:(NSSet *)values;

- (id)initIntoManagedObjectContext:(NSManagedObjectContext *)context;

@end
