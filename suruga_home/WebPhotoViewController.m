//
//  CustomImagePicker.m
//  CustomImagePicker
//
//  Created by Ray Wenderlich on 1/27/10.
//  Copyright 2010 Ray Wenderlich. All rights reserved.
//

#import "WebPhotoViewController.h"
#import "WebThumbsViewController.h"
#import "PhotoSet.h"

@implementation WebPhotoViewController
@synthesize parentController;

- (void)updateChrome {
    [super updateChrome];
    self.navigationItem.rightBarButtonItem =
    [[[UIBarButtonItem alloc] initWithTitle:TTLocalizedString(@"Save Photo",@"See Photo Navigation Button")
        style:UIBarButtonItemStyleBordered
        target:self
        action:@selector(savePhoto)]
     autorelease];
}

- (void)savePhoto {
    UIImage  *image  = [[[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[_centerPhoto URLForVersion:TTPhotoVersionLarge]]]] autorelease];
    [self.parentController.parentController webThumbsViewController:self.parentController didAddPhoto:image];
}

@end