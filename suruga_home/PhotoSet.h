//
//  PhotoSet.h
//  suruga_home
//
//  Created by Ted Tomlinson on 12/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Three20/Three20.h"

@class Address;

@interface PhotoSet : TTURLRequestModel <TTPhotoSource, TTURLResponse>
{
    NSString *_title;
    NSArray *_photos;
    NSMutableArray *_results;
    
    Address* address;
}
extern NSString * const BASE_GOOGLE_URL;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, retain) NSArray *photos;
@property (nonatomic, readonly) NSMutableArray *results;
@property (nonatomic, retain) Address *address;

- (id) initWithAddress:(Address *) address;

-(id<TTPhoto>)photoAtIndex:(NSInteger)index;


+ (PhotoSet *)samplePhotoSet;
//https://ajax.googleapis.com/ajax/services/search/images?v=1.0&imgtype=photo&rsz=8&q=<ADDRESS>
@end
