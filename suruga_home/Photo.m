//
//  Photo.m
//  suruga_home
//
//  Created by Ted Tomlinson on 12/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Photo.h"

@implementation Photo
@synthesize caption = _caption;
@synthesize urlLarge = _urlLarge;
@synthesize urlSmall = _urlSmall;
@synthesize urlThumb = _urlThumb;
@synthesize photoSource = _photoSource;
@synthesize size = _size;
@synthesize index = _index;

- (id)initWithCaption:(NSString *)caption urlLarge:(NSString *)urlLarge urlSmall:(NSString *)urlSmall urlThumb:(NSString *)urlThumb size:(CGSize)size {
    if ((self = [super init])) {
        self.caption = caption;
        self.urlLarge = urlLarge;
        self.urlSmall = urlSmall;
        self.urlThumb = urlThumb;
        self.size = size;
        self.index = NSIntegerMax;
        self.photoSource = nil;
    }
    return self;
}

+ (id)itemWithImageURL:(NSString*)theImageURL thumbImageURL:(NSString*)theThumbImageURL caption:(NSString*)theCaption size:(CGSize)theSize
{
    Photo *item = [[[[self class] alloc] init] autorelease];
    item.caption = theCaption;
    item.urlLarge = theImageURL;
    item.urlThumb = theThumbImageURL;
    item.size = theSize;
    
    //TTDPRINT(@"Creating photo with image: %@, thumb: %@, caption: %@, size: (%f, %f)", theImageURL, theThumbImageURL, theCaption, theSize.width, theSize.height);
    
    return item;
}

- (void) dealloc {
    self.caption = nil;
    self.urlLarge = nil;
    self.urlSmall = nil;
    self.urlThumb = nil;    
    [super dealloc];
}

#pragma mark TTPhoto

- (NSString*)URLForVersion:(TTPhotoVersion)version {
    switch (version) {
        case TTPhotoVersionLarge:
            return _urlLarge;
        case TTPhotoVersionMedium:
            return _urlLarge;
        case TTPhotoVersionSmall:
            return _urlSmall ? _urlSmall : _urlThumb;
        case TTPhotoVersionThumbnail:
            return _urlThumb;
        default:
            return nil;
    }
}

@end
