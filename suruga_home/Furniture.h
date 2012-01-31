//
//  Furniture.h
//  suruga_home
//
//  Created by Ted Tomlinson on 1/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Room;
@class Image;

@interface Furniture : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * length;
@property (nonatomic, retain) NSString * width;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) Room *room;
@property (nonatomic, retain) Image * image;

@end
