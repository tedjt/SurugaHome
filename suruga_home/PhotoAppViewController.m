//
//  PhotoAppViewController.m
//

#import "PhotoAppViewController.h"

@implementation PhotoAppViewController
@synthesize imageView,choosePhotoBtn, takePhotoBtn, saveBtn, cancelBtn, delegate;


- (void)viewDidLoad
{
	[super viewDidLoad];
	if(YES){ //TODO: check for image existence?
		imageView.image = [delegate getCurrentlySelectedImage];
	}
}

-(IBAction) getPhoto:(id) sender {
	UIImagePickerController * picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
	if((UIButton *) sender == choosePhotoBtn) {
		picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
	} else {
		picker.sourceType = UIImagePickerControllerSourceTypeCamera;
	}
	
	[self presentModalViewController:picker animated:YES];
}

- (IBAction)dismiss:(id) sender {
	UIImage * theImage = nil;
	if((UIButton *) sender == saveBtn){
		// save the file
		theImage = imageView.image;
	}
	
	[delegate photoAppViewController:self didAddPhoto: theImage];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	[picker dismissModalViewControllerAnimated:YES];
	imageView.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end
