//
//  HomePhotoViewController.m
//  suruga_home
//
//  Created by Ted Tomlinson on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HomeThumbsViewController.h"
#import "HomePhotoSource.h"
#import "PhotoSet.h"

@implementation HomeThumbsViewController
@synthesize home;

- (id) initWithHome: (Home *) theHome {
    if ((self = [super init])) {
        self.home = theHome;
    }
    return self;
}

- (void) viewDidLoad {
    self.photoSource = [[HomePhotoSource alloc] initWithHome:self.home];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add)] autorelease];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.photoSource = [[HomePhotoSource alloc] initWithHome:self.home];
}

- (TTPhotoViewController*)createPhotoViewController {
    HomePhotoViewController *photoController = [[[HomePhotoViewController alloc] init] autorelease];
    photoController.home = self.home;
    return photoController;
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (!(buttonIndex == [actionSheet cancelButtonIndex]))
    {
        if (buttonIndex == [actionSheet firstOtherButtonIndex]) {
            //Web Search
            WebThumbsViewController *thumbs = [[WebThumbsViewController alloc] init];
            thumbs.photoSource = [[PhotoSet alloc] initWithHome:self.home];
            thumbs.parentController = self;
            
            [self.navigationController pushViewController:thumbs animated:YES];
            TT_RELEASE_SAFELY(thumbs);
        } else {
            // Local
            UIImagePickerController * picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            [self presentModalViewController:picker animated:YES];
            [picker release];
        }
    }
}

- (void)add {
	UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Select Source", @"Home Photos Action SHeet")
        delegate:self
        cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel")
        destructiveButtonTitle:nil
        otherButtonTitles:
            NSLocalizedString(@"Web Search", @"Web Search Photo Source"),
            NSLocalizedString(@"Camera", @"CameraPhoto Source"), nil];
    
    // Show the sheet
    [sheet showInView:self.view];
    [sheet release];
}

- (void) dealloc {
    self.home = nil;    
    [super dealloc];
}

#pragma mark private Photo
- (void) addPhoto: (UIImage *) photo {
    if(photo){
        
		// Create an image object for the new image.
		Image *imageObject = [NSEntityDescription insertNewObjectForEntityForName:@"Image" inManagedObjectContext:self.home.managedObjectContext];
        
        [imageObject setValuesFromImage:photo];
        [home addImagesObject:imageObject];
        
        //Save the image object
        NSError *error;
		if (![self.home.managedObjectContext save:&error]) {
			// Update to handle the error appropriately.
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			exit(-1);  // Fail
		}
        self.photoSource = [[HomePhotoSource alloc] initWithHome:self.home];
		[self refresh];
	}
}

# pragma mark - UIImagePickerControllerDelegate, WebPhotoDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self addPhoto:[info objectForKey:@"UIImagePickerControllerOriginalImage"]];
    [picker dismissModalViewControllerAnimated:YES];
}

- (void) webThumbsViewController:(WebThumbsViewController *)webThumbsViewController didAddPhoto:(UIImage *)image 
{
    [self addPhoto:image];
    [webThumbsViewController.navigationController popViewControllerAnimated:YES];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissModalViewControllerAnimated:YES];
}

@end

@implementation HomePhotoViewController
@synthesize home;

- (void)updateChrome {
    [super updateChrome];
    self.navigationItem.rightBarButtonItem =
    [[[UIBarButtonItem alloc] initWithTitle:TTLocalizedString(@"Delete Photo",@"Delete Photo Navigation Button")
        style:UIBarButtonItemStyleBordered
        target:self
        action:@selector(deletePhoto)]
     autorelease];
}

- (void)deletePhoto {
    HomePhoto *photo = [_photoSource photoAtIndex:_centerPhotoIndex];
    //Cleanup photo from file-system
    [[NSFileManager defaultManager] removeItemAtPath:photo.image.pathToFull error:nil];
    [self.home removeImagesObject:photo.image];
    
    [(HomePhotoSource *)self.photoSource deletePhotoAtIndex:self.centerPhotoIndex];
    //[self previousAction];
    [self showActivity:nil];
    [self moveToNextValidPhoto];
    [_scrollView reloadData];
    [self refresh];  
}

- (void)moveToNextValidPhoto {
    if (self.centerPhotoIndex >= self.photoSource.numberOfPhotos) {
        // We were positioned at an index that is past the end, so move to the last photo
        _scrollView.centerPageIndex = _centerPhotoIndex;
        self.centerPhoto = [self.photoSource photoAtIndex: ([self.photoSource numberOfPhotos] - 1) ];;
    } else {
        self.centerPhoto = [self.photoSource photoAtIndex:self.centerPhotoIndex];
    }
}

- (void) dealloc {
    self.home = nil;    
    [super dealloc];
}

@end