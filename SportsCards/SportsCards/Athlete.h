//
//  Athlete.h
//  SportsCards
//
//  Created by Justin Cotner on 7/29/15.
//  Copyright (c) 2015 Justin Cotner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NSManagedObject, Positions, Stats;

@interface Athlete : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) NSSet *stats;
@property (nonatomic, retain) NSManagedObject *team;
@property (nonatomic, retain) NSSet *position;
@end

@interface Athlete (CoreDataGeneratedAccessors)

- (void)addStatsObject:(Stats *)value;
- (void)removeStatsObject:(Stats *)value;
- (void)addStats:(NSSet *)values;
- (void)removeStats:(NSSet *)values;

- (void)addPositionObject:(Positions *)value;
- (void)removePositionObject:(Positions *)value;
- (void)addPosition:(NSSet *)values;
- (void)removePosition:(NSSet *)values;

@end
