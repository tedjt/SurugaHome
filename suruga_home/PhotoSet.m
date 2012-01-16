//
//  PhotoSet.m
//  suruga_home
//
//  Created by Ted Tomlinson on 12/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PhotoSet.h"
#import "Photo.h"
#import "Address.h"
#import "extThree20JSON/TTErrorCodes.h"
#import "extThree20JSON/SBJson.h"
#import "extThree20JSON/NSString+SBJSON.h"

@implementation PhotoSet
NSString * const BASE_GOOGLE_URL = @"https://ajax.googleapis.com/ajax/services/search/images?v=1.0&imgtype=photo&rsz=8";

@synthesize title = _title;
@synthesize photos = _photos;
@synthesize address;

- (id) initWithTitle:(NSString *)title photos:(NSArray *)photos {
    if ((self = [super init])) {
        self.title = title;
        self.photos = photos;
        for(int i = 0; i < _photos.count; ++i) {
            Photo *photo = [_photos objectAtIndex:i];
            photo.photoSource = self;
            photo.index = i;
        }        
    }
    return self;
}

- (id) initWithAddress:(Address *) addressObject {
    if ((self = [super init])) {
        self.address = addressObject;
    }
    return self;
}
    
-(void) load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more query: (NSString *) query start: (int) start{
    TTURLRequest *request = [TTURLRequest requestWithURL:[NSString stringWithFormat:@"%@&start=%d&q=%@", BASE_GOOGLE_URL, start, [query stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]] delegate:self];
    //I didn't use a cache because my content can be pretty dynamic; change this if you want caching
    request.cachePolicy = cachePolicy;
    request.response = self;
    request.httpMethod = @"GET";
    
    //send out the request to be processed by the response parser
    [request send];
}

/*
 *  Kick off the request, pulling from cache if possible. Parsing will be handled in the process response
 */
-(void) load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more{
    for(int i = 0; i < 3; ++i) {
        [self load:cachePolicy more:more query: [self.address getFormattedAddress] start:(i*8)];
    }
}

- (NSError *) request:(TTURLRequest *)request processResponse:(NSHTTPURLResponse *)response data:(id)data{
    if ([self numberOfPhotos] == 0) {
        _results = nil;
        _results = [[NSMutableArray alloc] init]; 
    }
    // Handle request parsing.
    // This response is designed for NSData objects, so if we get anything else it's probably a
    // mistake.
    TTDASSERT([data isKindOfClass:[NSData class]]);
    NSError* err = nil;
    if ([data isKindOfClass:[NSData class]]) {
        NSString* json = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
        // When there are newline characters in the JSON string, 
        // the error "Unescaped control character '0x9'" will be thrown. This removes those characters.
        json =  [json stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        NSError *error = nil;
        NSArray *jsonObjects = [[[jsonParser objectWithString:json error:&error] objectForKey:@"responseData"] objectForKey:@"results"];
        for (NSDictionary *dict in jsonObjects)
        {
            Photo *item = [Photo 
                           itemWithImageURL:[dict objectForKey:@"url"]
                           thumbImageURL:[dict objectForKey:@"tbUrl"]
                           caption:@""
            size:CGSizeMake([[dict objectForKey:@"width"] intValue],
                            [[dict objectForKey:@"height"] intValue])];
            item.photoSource = self;
            [_results addObject:item];
        }
//        if (!_rootObject) {
//            err = [NSError errorWithDomain:kTTExtJSONErrorDomain
//                                      code:kTTExtJSONErrorCodeInvalidJSON
//                                  userInfo:nil];
//        }
        [jsonParser release], jsonParser = nil;
    }
    
    /*Handle all the parsing here which involves looping through your resulting XML/JSON, creating a new PhotoItem for each one and setting the medium and thumb src then adding it to the results array like so:
     PhotoItem *item = [PhotoItem itemWithImageURL:mediumSrc thumbImageURL:thumbSrc caption:@"" size:CGSizeMake(mediumWidth, mediumHeight)];
     [_results addObject:item];
     */
    return err;
}


- (void) dealloc {
    self.title = nil;
    self.photos = nil;
    [_results release];
    [address release];
    [super dealloc];
}

#pragma mark TTModel

//- (BOOL)isLoading { 
//    return FALSE;
//}

//- (BOOL)isLoaded {
//    return TRUE;
//}

#pragma mark TTPhotoSource

-(NSArray *) results{
    return [[_results copy] autorelease];
}

-(NSInteger) numberOfPhotos{
    return [_results count];
}

-(NSInteger) maxPhotoIndex{
    return [_results count] - 1;
}

- (id<TTPhoto>)photoAtIndex:(NSInteger)index{
    if (index < 0 || index > [self numberOfPhotos])
        return nil;
    
    id<TTPhoto> photo = [_results objectAtIndex:index];
    photo.index = index;
    photo.photoSource = self;
    return photo;
}

#pragma mark Singleton

static PhotoSet *samplePhotoSet = nil;

+ (PhotoSet *) samplePhotoSet {
    @synchronized(self) {
        if (samplePhotoSet == nil) {
            Photo *mathNinja = [[[Photo alloc] initWithCaption:@"Math Ninja" 
                                                      urlLarge:@"http://www.raywenderlich.com/downloads/math_ninja_large.png" 
                                                      urlSmall:@"bundle://math_ninja_small.png" 
                                                      urlThumb:@"bundle://math_ninja_thumb.png" 
                                                          size:CGSizeMake(1024, 768)] autorelease];
            Photo *instantPoetry = [[[Photo alloc] initWithCaption:@"Instant Poetry" 
                                                          urlLarge:@"http://www.raywenderlich.com/downloads/instant_poetry_large.png" 
                                                          urlSmall:@"bundle://instant_poetry_small.png" 
                                                          urlThumb:@"bundle://instant_poetry_thumb.png" 
                                                              size:CGSizeMake(1024, 748)] autorelease];
            Photo *rpgCalc = [[[Photo alloc] initWithCaption:@"RPG Calc" 
                                                    urlLarge:@"http://www.raywenderlich.com/downloads/rpg_calc_large.png" 
                                                    urlSmall:@"bundle://rpg_calc_small.png" 
                                                    urlThumb:@"bundle://rpg_calc_thumb.png" 
                                                        size:CGSizeMake(640, 920)] autorelease];
            Photo *levelMeUp = [[[Photo alloc] initWithCaption:@"Level Me Up" 
                                                      urlLarge:@"http://www.raywenderlich.com/downloads/level_me_up_large.png" 
                                                      urlSmall:@"bundle://level_me_up_small.png" 
                                                      urlThumb:@"bundle://level_me_up_thumb.png" 
                                                          size:CGSizeMake(1024, 768)] autorelease];
            NSArray *photos = [NSArray arrayWithObjects:mathNinja, instantPoetry, rpgCalc, levelMeUp, nil];
            samplePhotoSet = [[self alloc] initWithTitle:@"My Apps" photos:photos];
        }
    }
    return samplePhotoSet;
}

@end