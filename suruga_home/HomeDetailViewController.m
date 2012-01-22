//
//  HomeDetailViewController.m
//  suruga_home
//
//  Created by Ted Tomlinson on 12/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HomeDetailViewController.h"
#import "CustomImagePicker.h"
#import "Home.h"
#import "Address.h"
#import "Rating.h"
#import "Price.h"

@implementation HomeDetailViewController
@synthesize home;
@synthesize parentController;
@synthesize imageButton;
@synthesize ratingButton;
@synthesize priceButton;
@synthesize nameTextField;
@synthesize cityTextField;
@synthesize stateTextField;
@synthesize zipTextField;
@synthesize phoneTextField;
@synthesize streetTextField;
@synthesize mapView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Map View
    //Get forward geocoded address
    if(self.home.address.latitude != nil) {
        [self setMapViewZoom];
    } else { 
        [self.mapView.userLocation addObserver:self  
            forKeyPath:@"location"  
            options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld)  
            context:NULL]; 
    }

    //Nav bar buttons
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)] autorelease];
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)] autorelease];
    
    // Load home values if not nil
    // Do any additional setup after loading the view from its nib.
    if(self.home.name != nil) {
        self.title = self.home.name;
        self.nameTextField.text = self.home.name;
    } else { self.title = @"New Home";}
    if(self.home.phone != nil) {
        self.phoneTextField.text = self.home.phone;
    }
    if(self.home.address != nil) {
        Address *a = self.home.address;
        self.cityTextField.text = a.city;
        self.stateTextField.text = a.state;
        self.zipTextField.text = [a.zip intValue] != 0 ? [a.zip stringValue] : @"";
        self.streetTextField.text = self.home.address.street;
    }
    if (self.home.rating != nil) {
        [self.ratingButton setImage: [UIImage imageNamed:[NSString stringWithFormat:@"%d_stars.png", [self.home.rating.overall intValue]]] forState:UIControlStateNormal];                                          
    }
}

- (void)viewDidUnload
{
    [self setNameTextField:nil];
    [self setCityTextField:nil];
    [self setStateTextField:nil];
    [self setZipTextField:nil];
    [self setPhoneTextField:nil];
    [self setStreetTextField:nil];
    [self setMapView:nil];
    [self setImageButton:nil];
    [self setRatingButton:nil];
    [self setPriceButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [self.mapView.userLocation removeObserver:self forKeyPath:@"location"];
    //[self.mapView removeFromSuperview]; // release crashes app
    //self.mapView = nil;
    [home release];
    [nameTextField release];
    [cityTextField release];
    [stateTextField release];
    [zipTextField release];
    [phoneTextField release];
    [streetTextField release];
    [mapView release];
    [imageButton release];
    [ratingButton release];
    [priceButton release];
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

#pragma mark Text Field
- (IBAction)textFieldOutside:(id)sender {
    if([sender isKindOfClass:[UITextField class]])
    {   
        [sender resignFirstResponder];
        
//        UITextView *textView = sender;
//        // Handle text field keyboard
//        UIBarButtonItem *barButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:textView action:@selector(resignFirstResponder)] autorelease];
//        UIToolbar *toolbar = [[[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)] autorelease];
//        toolbar.items = [NSArray arrayWithObject:barButton];
//        
//        textView.inputAccessoryView = toolbar;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (IBAction)imageButtonClicked:(id)sender {
    CustomImagePicker *imagePicker = [[CustomImagePicker alloc] init];
    imagePicker.title = @"Home Images";
    [self updateHomeObject];
    imagePicker.home = self.home;

    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:imagePicker];
    [imagePicker release];
	[self presentModalViewController:navController animated:YES];
    [navController release];
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
    if (self.home.price == nil) {
        self.home.price = [NSEntityDescription insertNewObjectForEntityForName:@"Price" inManagedObjectContext:self.home.managedObjectContext];
    }
    PriceViewController *priceView = [[PriceViewController alloc] initWithNibName:@"PriceViewController" bundle:nil];
    priceView.price = self.home.price;
    priceView.parentController = self;
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:priceView];
	[self presentModalViewController:navController animated:YES];
    [priceView release];
    [navController release];
}

- (void)dismissPriceViewController:(PriceViewController *)priceViewController
{
    //TODO change this depending on rent vs buy
    //TODO change to use yen instead of dollars.
    self.priceButton.titleLabel.text = [NSString stringWithFormat:@"$%.2lf",[self.home.price getInitialSum]];
    //[NSString stringWithFormat:@"$%.2lf",[(Price *)[self.home valueForKey:@"price"] getInitialSum]];
    
    [self dismissModalViewControllerAnimated:YES];
}
#pragma mark - SVGeocoderDelegate
- (void) updateAddressCoordinates {
    //Get forward geocoded address
    if (self.home.address != nil) {
        SVGeocoder *geocodeRequest = [[SVGeocoder alloc] initWithAddress:[self.home.address getFormattedAddress]];
        [geocodeRequest setDelegate:self];
        [geocodeRequest startAsynchronous];
    }
}
- (void)setMapViewZoom {
    CLLocationCoordinate2D c = [self.home.address getCoordinate];
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
    self.home.address.latitude = [NSNumber numberWithDouble:placemark.coordinate.latitude];
    self.home.address.longitude = [NSNumber numberWithDouble:placemark.coordinate.longitude];
    
    [self setMapViewZoom];
    [self.parentController loadMapViewAnnotations];
}
- (void)geocoder:(SVGeocoder *)geocoder didFailWithError:(NSError *)error
{
    [self.mapView.userLocation addObserver:self  
                                forKeyPath:@"location"  
                                   options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld)  
                                   context:NULL];
    [self observeValueForKeyPath:@"location" ofObject:self.mapView.userLocation change:nil context:nil];
    
}
#pragma mark - Model Methods
- (void) updateHomeObject {
    self.home.name = nameTextField.text;
    self.home.phone = phoneTextField.text;
    if (self.home.address == nil) {
        self.home.address = [NSEntityDescription insertNewObjectForEntityForName:@"Address" inManagedObjectContext:self.home.managedObjectContext];
        self.home.address.home = self.home;
    }
    Address *a = self.home.address;
    if (![streetTextField.text isEqualToString:a.street] ||
        ![cityTextField.text isEqualToString:a.city] ||
        ![stateTextField.text isEqualToString:a.state] ||
        [zipTextField.text integerValue] != [zipTextField.text integerValue])
    {
        self.home.address.street = streetTextField.text;
        self.home.address.city = cityTextField.text;
        self.home.address.state = stateTextField.text;
        self.home.address.zip = [NSNumber numberWithInt:[zipTextField.text intValue]];
        //update coordinates
        [self updateAddressCoordinates];      
    }
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
