//
//  PhotoSet.h
//  suruga_home
//
//  Created by Ted Tomlinson on 12/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Three20/Three20.h"

@class Home;

@interface PhotoSet : TTURLRequestModel <TTPhotoSource, TTURLResponse>
{
    NSString *_title;
    NSMutableArray *_results;
    
    Home* home;
}
extern NSString * const BASE_GOOGLE_URL;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, readonly) NSMutableArray *results;
@property (nonatomic, retain) Home *home;

- (id) initWithHome:(Home *) home;

-(id<TTPhoto>)photoAtIndex:(NSInteger)index;

//https://ajax.googleapis.com/ajax/services/search/images?v=1.0&imgtype=photo&rsz=8&q=<ADDRESS>
@end
