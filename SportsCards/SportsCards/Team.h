//
//  Team.h
//  SportsCards
//
//  Created by Justin Cotner on 7/29/15.
//  Copyright (c) 2015 Justin Cotner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Athlete, Stats;

@interface Team : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * sport;
@property (nonatomic, retain) NSSet *athletes;
@property (nonatomic, retain) NSSet *stats;
@end

@interface Team (CoreDataGeneratedAccessors)

- (void)addAthletesObject:(Athlete *)value;
- (void)removeAthletesObject:(Athlete *)value;
- (void)addAthletes:(NSSet *)values;
- (void)removeAthletes:(NSSet *)values;

- (void)addStatsObject:(Stats *)value;
- (void)removeStatsObject:(Stats *)value;
- (void)addStats:(NSSet *)values;
- (void)removeStats:(NSSet *)values;

@end
