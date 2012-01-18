//
//  CustomImagePicker.h
//  CustomImagePicker
//
//  Created by Ray Wenderlich on 1/27/10.
//  Copyright 2010 Ray Wenderlich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebThumbsViewController.h"
#import "Image.h"

@class Home;

@interface CustomImagePicker : UIViewController <WebPhotoDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
	NSMutableArray *_images;
	Image *_selectedImage;
    UIScrollView *scrollView;
    
    Home *home;
}

@property (nonatomic, retain) NSMutableArray *images;
@property (nonatomic, retain) Image *selectedImage;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) Home *home;

- (id) initWithScrollView:(UIScrollView *) view;
- (IBAction)buttonClicked:(id)sender;
- (IBAction)cancel:(id)sender;
- (void)addImage:(UIImage *)image;
- (void) layoutImages;

@end