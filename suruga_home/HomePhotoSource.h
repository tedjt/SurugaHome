//
//  HomePhotoSource.h
//  suruga_home
//
//  Created by Ted Tomlinson on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Three20/Three20.h>
#import "Home.h"
#import "Image.h"

@interface HomePhotoSource : TTURLRequestModel <TTPhotoSource> {
    Home *home;
}

@property (nonatomic, retain) Home *home;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, retain) NSMutableArray *photos;

- (id)initWithHome: (Home *) home;
- (void)deletePhotoAtIndex: (NSUInteger) index;

@end

@interface HomePhoto : NSObject <TTPhoto> {
    NSString* caption;
    id<TTPhotoSource> photoSource;
    NSString* thumbUrl;
    NSString* url;
    CGSize size;
    NSInteger index;
    Image *image;
}
@property (nonatomic, copy) NSString *caption;
@property (nonatomic, assign) id <TTPhotoSource> photoSource;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *thumbUrl;
@property (nonatomic) CGSize size;
@property (nonatomic) NSInteger index;
@property (nonatomic, assign) Image *image;

- (id)initWithImage:(Image*) theImage;

@end