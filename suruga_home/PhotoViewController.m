//
//  PhotoViewController.m
//  suruga_home
//
//  Created by Ted Tomlinson on 12/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PhotoViewController.h"
#import "PhotoSet.h"

@implementation PhotoViewController
@synthesize photoSet = _photoSet;

- (void) viewDidLoad {
    self.photoSource = [PhotoSet samplePhotoSet];
}

- (void) dealloc {
    self.photoSet = nil;    
    [super dealloc];
}

@end
