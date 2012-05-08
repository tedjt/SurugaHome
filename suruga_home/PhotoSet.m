//
//  PhotoSet.m
//  suruga_home
//
//  Created by Ted Tomlinson on 12/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PhotoSet.h"
#import "Photo.h"
#import "Home.h"
#import "extThree20JSON/TTErrorCodes.h"
#import "extThree20JSON/SBJson.h"
#import "extThree20JSON/NSString+SBJSON.h"

@implementation PhotoSet
NSString * const BASE_GOOGLE_URL = @"https://ajax.googleapis.com/ajax/services/search/images?v=1.0&imgtype=photo&rsz=8";

@synthesize title = _title;
@synthesize home;

- (id) initWithHome:(Home *) homeObject {
    if ((self = [super init])) {
        self.home = homeObject;
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
        [self load:cachePolicy more:more query: self.home.address start:(i*8)];
    }
}

- (NSError *) request:(TTURLRequest *)request processResponse:(NSHTTPURLResponse *)response data:(id)data{
    if ([self numberOfPhotos] == 0) {
        _results = nil;
        _results = [[NSMutableArray alloc] init]; 
    }
    // Handle request parsing.
    // This response is designed for NSData objects, so if we get anything else it's probably a mistake.
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

        [jsonParser release], jsonParser = nil;
    }
    return err;
}


- (void) dealloc {
    self.title = nil;
    [_results release];
    [home release];
    [super dealloc];
}

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


@end