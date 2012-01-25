//
//  UserData.h
//  suruga_home
//
//  Created by Ted Tomlinson on 1/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class UserData;
@interface UserData : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * isRenting;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * reason;
@property (nonatomic, retain) NSDate * when;
@property (nonatomic, retain) NSNumber * numBeds;
@property (nonatomic, retain) NSNumber * numBaths;

+ (UserData *)fetchUserDataWithContext: (NSManagedObjectContext *) context;

@end
