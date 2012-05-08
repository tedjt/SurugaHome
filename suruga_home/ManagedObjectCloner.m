//
//  ManagedObjectCloner.m
//  suruga_home
//
//  Created by Ted Tomlinson on 4/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ManagedObjectCloner.h"


@implementation ManagedObjectCloner

+(NSManagedObject *) clone:(NSManagedObject *)source inContext:(NSManagedObjectContext *)context{
    NSString *entityName = [[source entity] name];
    
    //create new object in data store
    NSManagedObject *cloned = [NSEntityDescription
                               insertNewObjectForEntityForName:entityName
                               inManagedObjectContext:context];
    
    //loop through all attributes and assign then to the clone
    NSDictionary *attributes = [[NSEntityDescription
                                 entityForName:entityName
                                 inManagedObjectContext:context] attributesByName];
    
    for (NSString *attr in attributes) {
        [cloned setValue:[source valueForKey:attr] forKey:attr];
    }
    
    //Loop through all relationships, and clone them.
    NSDictionary *relationships = [[NSEntityDescription
                                    entityForName:entityName
                                    inManagedObjectContext:context] relationshipsByName];
    for (NSString *relName in [relationships allKeys]){
        NSRelationshipDescription *rel = [relationships objectForKey:relName];
        
        NSString *keyName = [NSString stringWithFormat:@"%@",rel];
        if ([rel isToMany]) {
            //get a set of all objects in the relationship
            NSMutableSet *sourceSet = [source mutableSetValueForKey:keyName];
            NSMutableSet *clonedSet = [cloned mutableSetValueForKey:keyName];
            NSEnumerator *e = [sourceSet objectEnumerator];
            NSManagedObject *relatedObject;
            while ( relatedObject = [e nextObject]){
                //Clone it, and add clone to set
                NSManagedObject *clonedRelatedObject = [ManagedObjectCloner clone:relatedObject inContext:context];
                [clonedSet addObject:clonedRelatedObject];
            }
        }else {
//            if ((int)[source primitiveValueForKey: keyName] != 1) {
//                [cloned setValue:[source valueForKey:keyName] forKey:keyName];
//            }
        }
        
    }
    
    return cloned;
}

@end