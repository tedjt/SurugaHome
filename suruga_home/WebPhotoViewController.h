//
//  CustomImagePicker.h
//  CustomImagePicker
//
//  Created by Ray Wenderlich on 1/27/10.
//  Copyright 2010 Ray Wenderlich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Three20/Three20.h>

@class WebThumbsViewController;

@interface WebPhotoViewController : TTPhotoViewController {
    WebThumbsViewController *parentController;
    
}

@property (nonatomic, assign) WebThumbsViewController *parentController;

- (void)savePhoto;
@end


