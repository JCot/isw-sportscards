//
//  Stats.h
//  SportsCards
//
//  Created by Justin Cotner on 7/29/15.
//  Copyright (c) 2015 Justin Cotner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NSManagedObject;

@interface Stats : NSManagedObject

@property (nonatomic, retain) NSString * statName;
@property (nonatomic, retain) NSNumber * value;
@property (nonatomic, retain) NSSet *athlete;
@property (nonatomic, retain) NSSet *team;
@end

@interface Stats (CoreDataGeneratedAccessors)

- (void)addAthleteObject:(NSManagedObject *)value;
- (void)removeAthleteObject:(NSManagedObject *)value;
- (void)addAthlete:(NSSet *)values;
- (void)removeAthlete:(NSSet *)values;

- (void)addTeamObject:(NSManagedObject *)value;
- (void)removeTeamObject:(NSManagedObject *)value;
- (void)addTeam:(NSSet *)values;
- (void)removeTeam:(NSSet *)values;

@end
