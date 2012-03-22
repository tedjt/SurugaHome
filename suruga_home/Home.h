//
//  Home.h
//  suruga_home
//
//  Created by Ted Tomlinson on 12/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Address;
@class Rating;
@class Price;

@interface Home : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSNumber * isRent;
@property (nonatomic, retain) Rating *rating;
@property (nonatomic, retain) Price *price;
@property (nonatomic, retain) NSSet *images;
@property (nonatomic, retain) Address *address;
@end

@interface Home (CoreDataGeneratedAccessors)

- (void)addImagesObject:(NSManagedObject *)value;
- (void)removeImagesObject:(NSManagedObject *)value;
- (void)addImages:(NSSet *)values;
- (void)removeImages:(NSSet *)values;
@end
