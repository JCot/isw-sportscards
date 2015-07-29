//
//  Positions.h
//  SportsCards
//
//  Created by Justin Cotner on 7/29/15.
//  Copyright (c) 2015 Justin Cotner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NSManagedObject;

@interface Positions : NSManagedObject

@property (nonatomic, retain) NSString * position;
@property (nonatomic, retain) NSSet *athlete;
@end

@interface Positions (CoreDataGeneratedAccessors)

- (void)addAthleteObject:(NSManagedObject *)value;
- (void)removeAthleteObject:(NSManagedObject *)value;
- (void)addAthlete:(NSSet *)values;
- (void)removeAthlete:(NSSet *)values;

@end
