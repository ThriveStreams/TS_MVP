//
//  User.m
//  ThriveStreams
//
//  Created by Ryan Badilla on 10/5/13.
//  Copyright (c) 2013 ThriveStreams. All rights reserved.
//

#import "User.h"


@implementation User

@dynamic createddate;
@dynamic firstname;
@dynamic lastmoddate;
@dynamic lastname;
@dynamic userimage;
@dynamic username;
@dynamic goal;


- (id)initIntoManagedObjectContext:(NSManagedObjectContext *)context {
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:context];
    self = [super initWithEntity:entity insertIntoManagedObjectContext:context];
    
    if (self) {
    }
    
    return self;
}
@end
