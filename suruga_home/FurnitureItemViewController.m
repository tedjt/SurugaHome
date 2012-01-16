//
//  OneBoxImageViewController.m
//  DubbleWrapper
//
//  Created by Glen Urban on 6/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FurnitureItemViewController.h"
#import "Image.h"

@implementation FurnitureItemViewController
@synthesize textFieldPrice;
@synthesize textFieldType;
@synthesize typePicker;
@synthesize typePickerArray;

@synthesize furniture, imageView, textFieldName, cameraButton, parentController;

#pragma mark - PRIVATE FUNCTIONS
- (void)keyBoardTypePicker 
{
    self.typePickerArray = [NSArray arrayWithObjects:
        NSLocalizedString(@"Couch", @"Couch furniture type"),
        NSLocalizedString(@"Table",@"Table furniture type"),
        NSLocalizedString(@"Lighting",@"Lamp furniture type"),
        NSLocalizedString(@"Art",@"Art furniture type"),
        NSLocalizedString(@"Television",@"Television furniture type"),
        NSLocalizedString(@"Cooking Supplies",@"Cooking suplies furniture type"),
        NSLocalizedString(@"Bed",@"Couch furniture type"),
        NSLocalizedString(@"Dresser",@"Couch furniture type"),
        NSLocalizedString(@"Storage",@"Couch furniture type"),
        NSLocalizedString(@"Other",@"Other furniture type"),
        nil];
    //TODO - make this work for Type Category selection.
    // create a UIPicker view as a custom keyboard view
    self.typePicker = [[[UIPickerView alloc] init] autorelease];
    self.typePicker.showsSelectionIndicator = YES;
    typePicker.dataSource = self;
    typePicker.delegate = self;
    //TODO - initialize the typePicker fields from typeArray.
    
    //Set typePicker as the inputView for textFieldType
    textFieldType.inputView = self.typePicker;
    
    // create a done view + done button, attach to it a doneClicked action, and place it in a toolbar as an accessory input view...
    // Prepare done button
    UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
    keyboardDoneButtonView.barStyle = UIBarStyleDefault;
    keyboardDoneButtonView.translucent = YES;
    keyboardDoneButtonView.tintColor = nil;
    [keyboardDoneButtonView sizeToFit];
    
    UIBarButtonItem* doneButton = [[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(typePickerDone:)] autorelease];
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:doneButton, nil]];
    
    // Plug the keyboardDoneButtonView into the text field...
    textFieldType.inputAccessoryView = keyboardDoneButtonView;
    [keyboardDoneButtonView release];
}

- (IBAction)typePickerDone:(id)sender{   
    //TODO - make conditional save
	[self saveData];
    [self.textFieldType resignFirstResponder];
}


- (void)updatePhotoButton {
	/*
	 How to present the photo button depends on the editing state and whether the furniture item has a thumbnail image. 
	 */
	
	if (furniture.image.thumb != nil) {
		[self.imageView setImage: [furniture.image getLargeImage]];
	} else {
		[self.imageView setImage: [UIImage imageNamed:@"section_box_camera.png"]];
	}
}

# pragma mark UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.typePickerArray count];
}

# pragma mark UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [typePickerArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.furniture.type =  [typePickerArray objectAtIndex:row];
    self.textFieldType.text = [typePickerArray objectAtIndex:row];
    self.typePicker.tag = row;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.editing = YES;
	
	self.textFieldName.text = self.furniture.name;
	self.textFieldName.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
    
    self.textFieldPrice.keyboardType = UIKeyboardTypeDecimalPad;
	self.textFieldPrice.text = [self.furniture.price stringValue];
    
    self.textFieldType.text = self.furniture.type;
	[self keyBoardTypePicker];
    
	self.imageView.contentMode = UIViewContentModeScaleAspectFit;
	
	// set image on button
	[self updatePhotoButton];
}
 
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)viewDidUnload {
    [self setTextFieldPrice:nil];
    [self setTextFieldType:nil];
    [self setTextFieldName:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [textFieldPrice release];
    [textFieldType release];
    [textFieldName release];
    [super dealloc];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return NO;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
	
	if (textField == textFieldName) {
		self.furniture.name = textFieldName.text;
		self.navigationItem.title = textFieldName.text;
	} else if (textField == textFieldPrice) {
        self.furniture.price = [NSNumber numberWithDouble:[textFieldPrice.text doubleValue]];
    }
	
    //TODO - make conditional save
	[self saveData];
	
	return YES;
}

- (void) saveData {
	NSManagedObjectContext *context = furniture.managedObjectContext;
	NSError *error = nil;
	if (![context save:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
	
	[parentController.tableView reloadData];
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range 
 replacementText:(NSString *)text
{
    // Any new character added is passed in as the "text" parameter
    if ([text isEqualToString:@"\n"]) {
        // Be sure to test for equality using the "isEqualToString" message
        [textView resignFirstResponder];
		
        // Return FALSE so that the final '\n' character doesn't get added
        return FALSE;
    }
    // For any other character return TRUE so that the text gets added to the view
    return TRUE;
}

#pragma mark -
#pragma mark Photo

- (IBAction)cameraButtonClick:(id)sender{
    // If in editing state, then display an image picker; if not, create and push a photo view controller.
	//	if (self.editing) {
	PhotoAppViewController * photoVC = [[PhotoAppViewController alloc] init];
	photoVC.delegate = self;
	[self presentModalViewController:photoVC animated:YES];
    
	[photoVC release];
}

- (UIImage*) getCurrentlySelectedImage {
    return [furniture.image getLargeImage];
}

- (void) photoAppViewController:(PhotoAppViewController *) photoAppViewController didAddPhoto: (UIImage*) image{
	//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)selectedImage editingInfo:(NSDictionary *)editingInfo {
	
	if(image){
        // Delete any existing image.
        //TODO - use a better delete function to remove pathToFull
		Image *oldImage = furniture.image;
		if (oldImage != nil) {
			[furniture.managedObjectContext deleteObject:oldImage];
		}
        
        // Create an image object for the new image.
		Image *imageObject = [NSEntityDescription insertNewObjectForEntityForName:@"Image" inManagedObjectContext:self.furniture.managedObjectContext];
        
        // Fill in data values.
        [imageObject setValuesFromImage:image];
        furniture.image = imageObject;
		
        //set the imageView Value
		imageView.image = image;
		
		// TODO: reload data
        //Save the image object
		[self saveData];
	}
	[self dismissModalViewControllerAnimated: YES];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissModalViewControllerAnimated:YES];
}

@end
