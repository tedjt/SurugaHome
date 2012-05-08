//
//  ManagedObjectCloner.h
//  suruga_home
//
//  Created by Ted Tomlinson on 4/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface ManagedObjectCloner : NSObject {
}
+(NSManagedObject *)clone:(NSManagedObject *)source inContext:(NSManagedObjectContext *)context;
@end