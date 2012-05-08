//
//  HomePhotoSource.m
//  suruga_home
//
//  Created by Ted Tomlinson on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HomePhotoSource.h"

@implementation HomePhotoSource
@synthesize home, title, photos;

- (id)initWithHome: (Home *) theHome {
    if ((self = [super init])) {
        self.home = theHome;
        self.title = home.name;
        
        // Populate photos array.
        NSMutableArray *a = [NSMutableArray arrayWithCapacity:home.images.count];
        int index = 0;
        for (Image *i in home.images) {
            HomePhoto *p = [[[HomePhoto alloc] initWithImage:i] autorelease];
            p.photoSource = self;
            p.index = index;
            [a addObject:p];
            index++;
        }
        self.photos = a;      
    }
    return self;
}

- (void)deletePhotoAtIndex: (NSUInteger) index {
    [self.photos removeObjectAtIndex:index];
}

- (void) dealloc {
    self.home = nil;
    self.title = nil;
    self.photos = nil;
    [super dealloc];
}

#pragma mark TTModel

- (BOOL)isLoading { 
    return FALSE;
}

- (BOOL)isLoaded {
    return TRUE;
}

#pragma mark TTPhotoSource

- (NSInteger)numberOfPhotos {
    return photos.count;
}

- (NSInteger)maxPhotoIndex {
    return photos.count-1;
}

- (id<TTPhoto>)photoAtIndex:(NSInteger)photoIndex {
    if (photoIndex < photos.count) {
        return [photos objectAtIndex:photoIndex];
    } else {
        return nil;
    }
}
@end

@implementation HomePhoto
@synthesize photoSource, thumbUrl, url, size, index, caption, image;

- (id)initWithImage:(Image*) theImage {
    if ((self = [super init])) {
        self.image = theImage;
        UIImage *largeImage = [image getLargeImage];
        self.url = [[TTURLCache sharedCache] storeTemporaryImage:largeImage toDisk:NO];
        self.thumbUrl = [[TTURLCache sharedCache] storeTemporaryData:image.thumb];
        self.size = [largeImage size];//CGSizeMake(640, 920);
        self.index = NSIntegerMax;
        self.photoSource = nil;
        self.caption = nil;
    }
    return self;
    
}

- (void) dealloc {
    [[TTURLCache sharedCache] removeURL:url fromDisk:NO];
    [[TTURLCache sharedCache] removeURL:thumbUrl fromDisk:NO];
    self.caption = nil;
    self.url = nil;
    self.thumbUrl = nil;
    [super dealloc];
}

#pragma mark TTPhoto

- (NSString*)URLForVersion:(TTPhotoVersion)version {
    switch (version) {
        case TTPhotoVersionLarge:
            return url;
        case TTPhotoVersionMedium:
            return url;
        case TTPhotoVersionSmall:
            return thumbUrl;
        case TTPhotoVersionThumbnail:
            return thumbUrl;
        default:
            return nil;
    }
}


@end
