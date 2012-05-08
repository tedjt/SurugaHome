//
//  HomePhotoViewController.h
//  suruga_home
//
//  Created by Ted Tomlinson on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Three20/Three20.h>
#import "WebThumbsViewController.h"
#import "HomePhotoSource.h"

@class Home;

@interface HomeThumbsViewController : TTThumbsViewController <UIActionSheetDelegate, WebPhotoDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    Home *home;
}

@property (nonatomic, retain) Home *home;

- (id) initWithHome: (Home *) home;

@end

@interface HomePhotoViewController : TTPhotoViewController{
    Home *home;
}
@property (nonatomic, retain) Home *home;

- (void) deletePhoto;
- (void)moveToNextValidPhoto;

@end
