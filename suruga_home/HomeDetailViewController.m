//
//  HomeDetailViewController.m
//  suruga_home
//
//  Created by Ted Tomlinson on 12/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HomeDetailViewController.h"
#import "Home.h"
#import "Rating.h"
#import "DCRoundSwitch.h"
#import "UIButton+setTitleText.h"
#import "TextFieldPickerView.h"
#import "HomePhotoSource.h"
#import "homeThumbsViewController.h"

@implementation HomeDetailViewController
@synthesize home;
@synthesize parentController;
@synthesize imageButton;
@synthesize ratingButton;
@synthesize priceButton;
@synthesize notesTextField;
@synthesize isRentSwitch;
@synthesize scrollView;
@synthesize nameTextField;
@synthesize addressTextField;
@synthesize sizeTextField;
@synthesize layoutTextField;
@synthesize stationTextField;
@synthesize nearestStationTextField;
@synthesize mapView;
@synthesize doneButton, saveButton;

#pragma mark - Private Functions
- (void)keyBoardLayoutPicker 
{
    NSArray *options = [NSArray arrayWithObjects:
                        [NSArray arrayWithObjects:
                         NSLocalizedString(@"0 L", @"0 L"),
                         NSLocalizedString(@"1 L", @"1 L"),
                         NSLocalizedString(@"2 L", @"2 L"),
                         NSLocalizedString(@"3 L", @"3 L"),
                         NSLocalizedString(@"4 L", @"4 L"),
                         NSLocalizedString(@"5 L", @"5 L"),
                         NSLocalizedString(@"6 L", @"6 L"),
                         NSLocalizedString(@"7 L", @"7 L"),
                         nil],
                        [NSArray arrayWithObjects:
                         NSLocalizedString(@"0 D", @"0 D"),
                         NSLocalizedString(@"1 D", @"1 D"),
                         NSLocalizedString(@"2 D", @"2 D"),
                         NSLocalizedString(@"3 D", @"3 D"),
                         NSLocalizedString(@"4 D", @"4 D"),
                         NSLocalizedString(@"5 D", @"5 D"),
                         NSLocalizedString(@"6 D", @"6 D"),
                         NSLocalizedString(@"7 D", @"7 D"),
                         nil], 
                        [NSArray arrayWithObjects:
                         NSLocalizedString(@"0 K", @"0 K"),
                         NSLocalizedString(@"1 K", @"1 K"),
                         NSLocalizedString(@"2 K", @"2 K"),
                         NSLocalizedString(@"3 K", @"3 K"),
                         NSLocalizedString(@"4 K", @"4 K"),
                         NSLocalizedString(@"5 K", @"5 K"),
                         NSLocalizedString(@"6 K", @"6 K"),
                         NSLocalizedString(@"7 K", @"7 K"),
                         nil], 
                        nil];
    [[[TextFieldPickerView alloc] initWithTextField:layoutTextField options:options useNewButton:NO] autorelease];
}

- (void) updateAddressCoordinates {
    //Get forward geocoded address
    if (self.home.address != nil) {
        SVGeocoder *geocodeRequest = [[[SVGeocoder alloc] initWithAddress:self.home.address] autorelease];
        [geocodeRequest setDelegate:self];
        [geocodeRequest startAsynchronous];
    }
}

#pragma mark -
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self keyBoardLayoutPicker];
    //Set renting switch
    self.isRentSwitch.onText = NSLocalizedString(@"Renting", @"Renting Option");
	self.isRentSwitch.offText = NSLocalizedString(@"Buying", @"Buying Option");
    
    self.scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, 1200);
    
    //Register for keyboard events
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
            selector:@selector(keyboardWillBeHidden:)
            name:UIKeyboardWillHideNotification object:nil];
    
    //Map View
    //Get forward geocoded address
    if(self.home.latitude != nil) {
        [self setMapViewZoom];
    } else { 
        [mapView.userLocation addObserver:self  
            forKeyPath:@"location"  
            options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld)  
            context:NULL]; 
    }

    //Nav bar buttons
    self.saveButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)] autorelease];
    self.navigationItem.rightBarButtonItem = self.saveButton;
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)] autorelease];
    
    //Done button
    self.doneButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)] autorelease];
    
    // Load home values if not nil
    // Do any additional setup after loading the view from its nib.
    if(self.home.name != nil) {
        self.title = self.home.name;
        self.nameTextField.text = self.home.name;
    } else { self.title = NSLocalizedString(@"New Home", @"New Home Nav Title");}
    if (home.nearestStation != nil)
        self.nearestStationTextField.text = self.home.nearestStation;
    if (home.address != nil)
        self.addressTextField.text = self.home.address;
    self.isRentSwitch.on = [self.home.isRent boolValue];
    if ([home.size intValue] != 0)
        self.sizeTextField.text = [self.home.size stringValue];
    self.layoutTextField.text = self.home.layout;
    if (![[home.notes stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString: @""])
        self.notesTextField.text = self.home.notes;
    else
        self.notesTextField.text = NSLocalizedString(@"Notes", @"Notes hint text");
    if ([home.stationDistance intValue] != 0)
        self.stationTextField.text = [self.home.stationDistance stringValue];
    if (self.home.rating != nil) {
        [self.ratingButton setImage: [UIImage imageNamed:[NSString stringWithFormat:@"%d_stars.png", [self.home.rating.overall intValue]]] forState:UIControlStateNormal];                                          
    }
    if (self.home.budgetItems != nil) {
        NSString *title = [NSString stringWithFormat:@"$%d",[self.home getInitialCost]];
        [self.priceButton setTitleText:title];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    // Need to restore nav bar due to three20 bug.
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
}

- (void)viewDidUnload
{
    [self setNameTextField:nil];
    [self setAddressTextField:nil];
    //[self setMapView:nil];
    [self setImageButton:nil];
    [self setRatingButton:nil];
    [self setPriceButton:nil];
    [self setIsRentSwitch:nil];
    [self setSizeTextField:nil];
    [self setLayoutTextField:nil];
    [self setStationTextField:nil];
    [self setNotesTextField:nil];
    [self setScrollView:nil];
    [self setDoneButton:nil];
    [self setSaveButton:nil];
    [self setNearestStationTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    id o = mapView.userLocation.observationInfo;
    if (o != nil ) {
        [self.mapView.userLocation removeObserver:self forKeyPath:@"location"];
    }
    //[mapView.userLocation removeObserver:self forKeyPath:@"location"];
    [self.mapView removeFromSuperview]; // release crashes app
    self.mapView = nil;
    [home release];
    [nameTextField release];
    [addressTextField release];
    //[mapView release];
    [imageButton release];
    [ratingButton release];
    [priceButton release];
    [isRentSwitch release];
    [sizeTextField release];
    [layoutTextField release];
    [stationTextField release];
    [notesTextField release];
    [scrollView release];
    [doneButton release];
    [saveButton release];
    [nearestStationTextField release];
    [super dealloc];
}

-(void)observeValueForKeyPath:(NSString *)keyPath  
                     ofObject:(id)object  
                       change:(NSDictionary *)change  
                      context:(void *)context {  
    
    if ([self.mapView showsUserLocation] && CLLocationCoordinate2DIsValid(self.mapView.userLocation.coordinate)) {
        MKCoordinateRegion region;
        region.center = self.mapView.userLocation.coordinate;  
        
        MKCoordinateSpan span; 
        span.latitudeDelta  = 0.01; // Change these values to change the zoom
        span.longitudeDelta = 0.01; 
        region.span = span;
        
        [self.mapView setRegion:region animated:YES];
        // and of course you can use here old and new location values
    }
}

#pragma mark - Text Field

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
    self.navigationItem.rightBarButtonItem = self.doneButton;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
    self.navigationItem.rightBarButtonItem = self.saveButton;
    if (textField == addressTextField && ![addressTextField.text isEqualToString:home.address]) {
        home.address = addressTextField.text;
        [self updateAddressCoordinates];
    }
}

- (IBAction)done:(id)sender {
    [activeField resignFirstResponder];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (activeField != layoutTextField && !CGRectContainsPoint(aRect, CGPointMake(activeField.frame.origin.x, activeField.frame.origin.y + activeField.frame.size.height))) {
        CGPoint scrollPoint = CGPointMake(0.0, activeField.frame.origin.y-kbSize.height + 100);
        [scrollView setContentOffset:scrollPoint animated:YES];
    } else if ([notesTextField isFirstResponder]) {
        CGPoint scrollPoint = CGPointMake(0.0, notesTextField.frame.origin.y-kbSize.height + 100);
        [scrollView setContentOffset:scrollPoint animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
}

#pragma mark -

- (IBAction)imageButtonClicked:(id)sender {
    [self updateHomeObject];
    HomeThumbsViewController *photoView = [[HomeThumbsViewController alloc] initWithHome:self.home];
    [self.navigationController pushViewController:photoView animated:YES];
    TT_RELEASE_SAFELY(photoView);
}

- (IBAction)ratingButtonClicked:(id)sender {
    if (self.home.rating == nil) {
        self.home.rating = [NSEntityDescription insertNewObjectForEntityForName:@"Rating" inManagedObjectContext:self.home.managedObjectContext];
    }
    RatingViewController *ratingView = [[RatingViewController alloc] initWithNibName:@"RatingViewController" bundle:nil rating: self.home.rating];
    ratingView.parentController = self;
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:ratingView];
	[self presentModalViewController:navController animated:YES];
    [ratingView release];
    [navController release];
}

- (void)dismissRatingViewController:(RatingViewController *)ratingViewController
{
    [self.ratingButton setImage: [UIImage imageNamed:[NSString stringWithFormat:@"%d_stars.png", [self.home.rating.overall intValue]]] forState:UIControlStateNormal];
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)priceButtonClicked:(id)sender {
    HomePriceTableViewController *priceView = [[HomePriceTableViewController alloc] init];
    priceView.home = self.home;
    priceView.parentController = self;
    [self.navigationController pushViewController:priceView animated:YES];
    [priceView release];
}

- (void)updatePrice
{
    //TODO change this depending on rent vs buy
    //TODO change to use yen instead of dollars.
    NSString *title = [NSString stringWithFormat:@"$%d",[self.home getInitialCost]];
    [self.priceButton setTitleText:title];
}

- (IBAction)isRentSwitched:(id)sender {
    self.home.isRent = [NSNumber numberWithBool: self.isRentSwitch.on];
}
#pragma mark - SVGeocoderDelegate
- (void)setMapViewZoom {
    CLLocationCoordinate2D c = [self.home getCoordinate];
    if (fabs(c.latitude) > 0.0001) {
        [self.mapView addAnnotation: [[[MKPlacemark alloc] initWithCoordinate:c addressDictionary:nil] autorelease]];
                                      
    //     SVPlacemark *placemark = [[SVPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(lat, lng) addressDictionary:formattedAddressDict]
        MKCoordinateRegion region;
        region.center = c;
        
        MKCoordinateSpan span; 
        span.latitudeDelta  = 0.01; // Change these values to change the zoom
        span.longitudeDelta = 0.01; 
        region.span = span;
        
        [self.mapView setRegion:region animated:YES];
    } else{
        [self updateAddressCoordinates];
    }
}
- (void)geocoder:(SVGeocoder *)geocoder didFindPlacemark:(SVPlacemark *)placemark
{
    //set address values;
    self.home.latitude = [NSNumber numberWithDouble:placemark.coordinate.latitude];
    self.home.longitude = [NSNumber numberWithDouble:placemark.coordinate.longitude];
    
    [self setMapViewZoom];
    if ([(NSObject *) self.parentController conformsToProtocol:@protocol(HomeMapViewDelegate)])
    {
        [(NSObject<HomeMapViewDelegate> *) self.parentController loadMapViewAnnotations];
    }
}
- (void)geocoder:(SVGeocoder *)geocoder didFailWithError:(NSError *)error
{
    //[mapView.userLocation addObserver:self  
    //    forKeyPath:@"location"  
    //    options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld)  
    //                               context:NULL];
    //TODO - do I need to manually observe value
    //TODO - reset address lat/long object to nil or go with last known good value?
    [self observeValueForKeyPath:@"location" ofObject:self.mapView.userLocation change:nil context:nil];
    
}

#pragma mark - Model Methods
- (void) updateHomeObject {
    self.home.name = nameTextField.text;
    self.home.notes = notesTextField.text;
    self.home.nearestStation = nearestStationTextField.text;
    if (![self.home.address isEqualToString:addressTextField.text]) {
        self.home.address = addressTextField.text;
        [self updateAddressCoordinates]; 
    }
    self.home.size = [NSNumber numberWithInt:[self.sizeTextField.text intValue]];
    self.home.layout = self.layoutTextField.text;
    self.home.stationDistance = [NSNumber numberWithInt: [self.stationTextField.text intValue]];
    self.home.isRent = [NSNumber numberWithBool: self.isRentSwitch.on];
}
- (IBAction)save:(id)sender {
    [self updateHomeObject];
    // Save the changes
    [self.parentController homeDetailViewController:self didFinishWithSave:YES];

}

- (IBAction)cancel:(id)sender {
    [self.parentController homeDetailViewController:self didFinishWithSave:NO];
}
@end
