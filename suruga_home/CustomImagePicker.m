//
//  CustomImagePicker.m
//  CustomImagePicker
//
//  Created by Ray Wenderlich on 1/27/10.
//  Copyright 2010 Ray Wenderlich. All rights reserved.
//

#import "Three20/Three20.h"
#import "CustomImagePicker.h"
#import "PhotoSet.h"
#import "Home.h"

@implementation CustomImagePicker
@synthesize images = _images;
@synthesize selectedImage = _selectedImage;
@synthesize scrollView;
@synthesize home;

- (id) init {
	if ((self = [super init])) {
		_images =  [[NSMutableArray alloc] init];
	}
	return self;
}

- (id) initWithScrollView:(UIScrollView *)view {
    if (self = [self init]) {
        [view retain];
        scrollView = view;
	}
    return self;
}

- (void)addImage:(UIImage *)image {
	[_images addObject:image];
}

- (void)viewDidLoad {
    //initialize images from home object
    self.images = [NSMutableArray arrayWithArray:[self.home.images allObjects]];
	// Create view
    if (self.scrollView == nil) {
        self.scrollView = [[[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    }
    
    [self layoutImages];
	
	// Create cancel button
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] 
									 initWithTitle:@"Cancel" 
									 style:UIBarButtonItemStylePlain 
									 target:self 
									 action:@selector(cancel:)];
	self.navigationItem.leftBarButtonItem = cancelButton;
	[cancelButton release];
    self.view = self.scrollView;
	
	[super viewDidLoad];
}

- (void) layoutImages {
    //remove all views
    for(UIView *subview in [self.scrollView subviews]) {
        [subview removeFromSuperview];
    }
    
    //add internet buttons
	UIButton * imagesButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    imagesButton.frame = CGRectMake(24, 25, 170, 30);
    [imagesButton setTitle:@"Web Images" forState:UIControlStateNormal]; 
    [imagesButton addTarget:self 
                     action:@selector(webButtonClicked:) 
           forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:imagesButton];

    //add individual images
	int row = 0;
	int column = 0;
	for(int i = 0; i < _images.count; ++i) {
        [[self.scrollView viewWithTag:i] removeFromSuperview];
		Image *imageObject = [_images objectAtIndex:i];
		UIImage *thumb = [[[UIImage alloc] initWithData:imageObject.thumb] autorelease];
		UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
		button.frame = CGRectMake(column*100+24, row*80+65, 80, 80);
		[button setImage:thumb forState:UIControlStateNormal];
		[button addTarget:self 
				   action:@selector(buttonClicked:) 
		 forControlEvents:UIControlEventTouchUpInside];
		button.tag = i; 
		[self.scrollView addSubview:button];
		
		if (column == 2) {
			column = 0;
			row++;
		} else {
			column++;
		}
		
	}
	
	[self.scrollView setContentSize:CGSizeMake(320, (row+1) * 80 + 10)];
}

- (IBAction)buttonClicked:(id)sender {
	UIButton *button = (UIButton *)sender;
	self.selectedImage = [_images objectAtIndex:button.tag];
    //change to pop up a view controller
    UIViewController *viewController = [[UIViewController alloc] init];
    UIImageView *bigImageView = [[UIImageView alloc] initWithImage:[self.selectedImage getLargeImage]];
    bigImageView.contentMode = UIViewContentModeScaleAspectFit;
    [[viewController view] addSubview:bigImageView];
    
    // Create delete button
	UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc] 
									 initWithTitle:@"Delete" 
									 style:UIBarButtonItemStylePlain 
									 target:self 
									 action:@selector(delete:)];
    deleteButton.tag = button.tag;
	viewController.navigationItem.rightBarButtonItem = deleteButton;
    
    [self.navigationController pushViewController:viewController animated:YES];
    [deleteButton release];
    [viewController release];
    [bigImageView release];
}

- (IBAction)webButtonClicked:(id)sender {
    WebThumbsViewController *thumbs = [[WebThumbsViewController alloc] init];
    thumbs.photoSource = [[PhotoSet alloc] initWithAddress:self.home.address];
    thumbs.parentController = self;

    [self.navigationController pushViewController:thumbs animated:YES];
    TT_RELEASE_SAFELY(thumbs);
}

- (IBAction)cancel:(id)sender {
	self.selectedImage = nil;
    // Dismiss the modal view to return to the main list
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)delete:(id)sender {
    [[NSFileManager defaultManager] removeItemAtPath:self.selectedImage.pathToFull error:nil];
    [self.home removeImagesObject:self.selectedImage];
    //remove specific image from list of images.
    [self.images removeObjectAtIndex:[(UIButton *) sender tag]];
    //[[self.scrollView viewWithTag:[(UIButton *) sender tag]] removeFromSuperview];
    [self.home.managedObjectContext deleteObject:self.selectedImage];
	self.selectedImage = nil;
    [self layoutImages];
    // Dismiss the modal view to return to the main list
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
}

- (void)dealloc {
	self.images = nil;
	self.selectedImage = nil;
    self.scrollView = nil;
	[super dealloc];
}

#pragma mark Photo

- (IBAction)cameraButtonClick:(id)sender{
    
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
	
	[self presentModalViewController:picker animated:YES];
    [picker release];
}


- (void) webThumbsViewController:(WebThumbsViewController *)webThumbsViewController didAddPhoto:(UIImage *)image 
{
	if(image){

		// Create an image object for the new image.
		Image *imageObject = [NSEntityDescription insertNewObjectForEntityForName:@"Image" inManagedObjectContext:self.home.managedObjectContext];
        
        [imageObject setValuesFromImage:image];
        [home addImagesObject:imageObject];
        [self.images addObject:imageObject];
        
        //Save the image object
        NSError *error;
		if (![self.home.managedObjectContext save:&error]) {
			// Update to handle the error appropriately.
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			exit(-1);  // Fail
		}
        [webThumbsViewController.navigationController popViewControllerAnimated:YES];
		[self layoutImages];
	}
    //[self.navigationController popViewControllerAnimated:YES];    
	//[self dismissModalViewControllerAnimated: YES];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissModalViewControllerAnimated:YES];
}

@end
