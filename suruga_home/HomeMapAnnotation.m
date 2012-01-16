//
//  HomeMapAnnotation.m
//  suruga_home
//
//  Created by Ted Tomlinson on 1/9/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "HomeMapAnnotation.h"

@implementation HomeMapAnnotation
@synthesize coordinate;
@synthesize image;
@synthesize home;
@synthesize title;
@synthesize subtitle;


- (void)dealloc
{
    [image release];
    [super dealloc];
}

@end
