//
//  Home.h
//  suruga_home
//
//  Created by Ted Tomlinson on 12/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <MapKit/MapKit.h>

@class Rating;
@class Price;
@class HomeBudgetItem;

@interface Home : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSString * layout;
@property (nonatomic, retain) NSString * nearestStation;
@property (nonatomic, retain) NSNumber * size;
@property (nonatomic, retain) NSNumber * stationDistance;
@property (nonatomic, retain) NSNumber * isRent;
@property (nonatomic, retain) Rating *rating;
@property (nonatomic, retain) NSSet *images;
@property (nonatomic, retain) NSSet *budgetItems;

+ (NSArray *)fetchAllHomesWithContext: (NSManagedObjectContext *) context;

- (int) getTotalCost;
- (int) getRunningCost;
- (int) getRunningCapacity;
- (int) getInitialCost;
- (int) getInitialCapacity;
- (void) populateDefaultBudgetItems;

- (NSMutableArray *)fetchBudgetItemsInInitial: (BOOL) inInitial;
- (CLLocationCoordinate2D) getCoordinate;

@end

@interface Home (CoreDataGeneratedAccessors)

- (void)addImagesObject:(NSManagedObject *)value;
- (void)removeImagesObject:(NSManagedObject *)value;
- (void)addImages:(NSSet *)values;
- (void)removeImages:(NSSet *)values;

- (void)addBudgetItemsObject:(NSManagedObject *)value;
- (void)removeBudgetItemsObject:(NSManagedObject *)value;
- (void)addBudgetItems:(NSSet *)values;
- (void)removeBudgetItems:(NSSet *)values;
@end
