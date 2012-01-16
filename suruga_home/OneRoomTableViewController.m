//
//  OneBoxTableViewController.m
//  DubbleWrapper
//
//  Created by Glen Urban on 6/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "OneRoomTableViewController.h"
#import "FurnitureItemViewController.h"
#import "Furniture.h"
#import "Image.h"

@implementation OneRoomTableViewController

@synthesize room, textFieldName, labelPrice, roomItems;


#pragma mark -
#pragma mark View lifecycle


// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self setUpTextFields];
        //TODO - set typePicker values.
    }
    return self;
}

- (void)setUpTextFields {
	self.textFieldName = [[UITextField alloc] initWithFrame:CGRectMake(110,10,185,30)];
	
	textFieldName.borderStyle = UITextBorderStyleBezel;
	textFieldName.textColor = [UIColor blackColor];
	textFieldName.font = [UIFont systemFontOfSize:17.0];
	textFieldName.placeholder = @"<enter name>";
	textFieldName.backgroundColor = [UIColor whiteColor];
	textFieldName.autocorrectionType = UITextAutocorrectionTypeNo;	// no auto correction support
	
	textFieldName.keyboardType = UIKeyboardTypeDefault;	// use the default type input method (entire keyboard)
	textFieldName.returnKeyType = UIReturnKeyDone;
	
	textFieldName.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
	
	textFieldName.tag = 1;		// tag this control so we can remove it later for recycled cells
	
	textFieldName.delegate = self;	// let us be the delegate so we know when the keyboard's "Done" button is pressed
	
	// Add an accessibility label that describes what the text field is for.
	[textFieldName setAccessibilityLabel:NSLocalizedString(@"Name Text Field", @"Name Text Field Accessibility Label")];
	
	self.labelPrice = [[UILabel alloc] initWithFrame:CGRectMake(110,10,185,30)];
	labelPrice.textColor = [UIColor blackColor];
	labelPrice.font = [UIFont systemFontOfSize:17.0];
	labelPrice.backgroundColor = [UIColor whiteColor];	
	labelPrice.tag = 1;		// tag this control so we can remove it later for recycled cells
	
	// Add an accessibility label that describes what the text field is for.
	[labelPrice setAccessibilityLabel:NSLocalizedString(@"Price Label Field", @"Price Label Field Accessibility label")];
}

- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	
	/*
	 Create a mutable array that contains the recipe's ingredients ordered by displayOrder.
	 The table view uses this array to display the ingredients.
	 Core Data relationships are represented by sets, so have no inherent order. Order is "imposed" using the displayOrder attribute, but it would be inefficient to create and sort a new array each time the ingredients section had to be laid out or updated.
	 */
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES]; 
	//TODO: switch to displayOrder
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
	
	NSMutableArray *sortedFurnitureItems = [[NSMutableArray alloc] initWithArray:[room.furniture allObjects]];
	[sortedFurnitureItems sortUsingDescriptors:sortDescriptors];
	self.roomItems = sortedFurnitureItems;
	
	[sortDescriptor release];
	[sortDescriptors release];
	[sortedFurnitureItems release];
	
	// Update recipe type and ingredients on return.
    [self.tableView reloadData]; 
	
	self.editing = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	if(room.name == nil || [room.name isEqualToString: @""]){
		self.navigationItem.title = @"New Box";
	}else{
		self.navigationItem.title = room.name;
	}
	
	//self.tableView.editing = YES;
	self.tableView.allowsSelection = YES;
	self.tableView.allowsSelectionDuringEditing = YES;

	self.textFieldName.text = self.room.name;
	
	//add a button
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(newFurnitureItem:)] autorelease];
	
}
#pragma mark -

#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if(section ==0){
		return 2;
	}else if(section == 1){
		return [roomItems count];
	}
	return 0;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger) section{
	if(section == 0){
		return @"Room Information";
	}
	else{
		return @"Furniture Items";
	}
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if(indexPath.section == 0){
		static NSString *CellIdentifier = @"Cell";
		
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		}
		
		// return a metadata listing
		if(indexPath.row == 0){
			UILabel * nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,10,110,30)];
			nameLabel.text = @"Name:";
			nameLabel.backgroundColor = [UIColor clearColor];
			[cell addSubview:nameLabel];
			[cell addSubview:textFieldName];
            [nameLabel release];
		} else if(indexPath.row == 1){
			UILabel * priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,10,110,30)];
			priceLabel.text = @"Total Cost:";
			priceLabel.backgroundColor = [UIColor clearColor];
			[cell addSubview:priceLabel];
            
            self.labelPrice.text = [self.room sumPrices];
			[cell addSubview:labelPrice];
            [priceLabel release];
		}
		return cell;
	}
	else {
		static NSString *FurnitureItemCellIdentifier = @"FurnitureItemCellIdentifier";
		
		UITableViewCell *cell = (UITableViewCell*) [tableView dequeueReusableCellWithIdentifier:FurnitureItemCellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:FurnitureItemCellIdentifier] autorelease];
		}
		
		[self configureCell:cell atIndexPath:indexPath];
		return cell;
	}
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    // Configure the cell   
    Furniture *furniture = [roomItems objectAtIndex:indexPath.row];
    // Configure the cell to show the Room's details
	cell.textLabel.text = furniture.name;
    //TODO format this like a price.
    cell.detailTextLabel.text = [furniture.price stringValue];
    if(furniture.image != nil) {
        cell.imageView.image = [UIImage imageWithData:furniture.image.thumb];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if(indexPath.section == 1){
		Furniture *furniture = [roomItems objectAtIndex:indexPath.row];
		[self showFurnitureItem:furniture editMode: self.editing animated:YES];
	}
}

- (void)showFurnitureItem:(Furniture*) furniture editMode: (BOOL) editMode animated:(BOOL)animated{
	
	FurnitureItemViewController * furnitureItemViewController = [[FurnitureItemViewController alloc] initWithNibName:@"FurnitureItemViewController" bundle:nil];
	furnitureItemViewController.furniture = furniture;
	furnitureItemViewController.editing = editMode;
	
	furnitureItemViewController.parentController = self;
	
	[self.navigationController pushViewController:furnitureItemViewController animated:YES];
	
	[furnitureItemViewController release];
}

- (IBAction) newFurnitureItem : (id)sender{
	
	// CREATE AND ADD TO DATABASE
	Furniture *furniture = (Furniture*) [NSEntityDescription insertNewObjectForEntityForName:@"Furniture" inManagedObjectContext:self.room.managedObjectContext];
	[room addFurnitureObject:furniture];
	
	[self showFurnitureItem:furniture editMode:YES animated:NO];
}

#pragma mark -
#pragma mark Memory management

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
    self.textFieldName = nil;
    self.labelPrice = nil;
}


#pragma mark -
#pragma mark Text Fields

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return NO;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
	
	if (textField == textFieldName) {
		self.room.name = textFieldName.text;
		self.navigationItem.title = textFieldName.text;
	}
	
    //TODO make conditional save.
	[self saveData];
	
	return YES;
}

- (void) saveData{
	NSManagedObjectContext *context = room.managedObjectContext;
	NSError *error = nil;
	if (![context save:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
}

#pragma mark -
#pragma mark Editing

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		Furniture * itemToDelete = [roomItems objectAtIndex:indexPath.row];
		[room removeFurnitureObject:itemToDelete];
		 
		NSManagedObjectContext *context = room.managedObjectContext;
		[context deleteObject:itemToDelete];
		
		[roomItems removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
		[tableView reloadData];
    }   
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
	if(indexPath.section == 0){
		return UITableViewCellEditingStyleNone;
	}
	else{
		return UITableViewCellEditingStyleDelete;
	}
}

#pragma mark -
#pragma mark memory maanagement

- (void)dealloc {
	[textFieldName release];
    [labelPrice release];
    [roomItems release];
    [room release];
	[super dealloc];
}


@end

