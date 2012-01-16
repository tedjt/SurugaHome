//
//  CompareDetailsViewController.m
//  suruga_home
//
//  Created by Ted Tomlinson on 12/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CompareDetailsViewController.h"
#import "CustomImagePicker.h"
#import "HomeDetailViewController.h"

@implementation CompareDetailsViewController
@synthesize scrollView;
@synthesize pageControl;
@synthesize detailsImageView;
@synthesize detailsNameField;
@synthesize detailsPhoneField;
@synthesize detailsCityField;
@synthesize detailsStateField;
@synthesize detailsZipField;
@synthesize detailsStreetField;
@synthesize detailsMapView;
@synthesize detailsView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    //HomeDetailViewController *homeDetailsView = [[HomeDetailViewController alloc] initWithNibName:@"homeDetailViewController" bundle:nil];
    [[NSBundle mainBundle] loadNibNamed:@"homeDetailViewController" owner:self options:nil];
    [self.scrollView addSubview:self.detailsView];
    
    NSArray *colors = [NSArray arrayWithObjects:[UIColor redColor], [UIColor greenColor], [UIColor blueColor], nil];
    
    CGRect frame;
    frame.origin.x = self.scrollView.frame.size.width * 1;
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    
    CustomImagePicker *imagePicker = [[CustomImagePicker alloc] initWithScrollView:[[[UIScrollView alloc] initWithFrame:frame] autorelease]];
    imagePicker.title = @"Choose Custom Image";
    [imagePicker addImage:[UIImage imageNamed:@"logo1.png"]];
	[imagePicker addImage:[UIImage imageNamed:@"logo2.png"]];
	[imagePicker addImage:[UIImage imageNamed:@"logo3.png"]];
	[imagePicker addImage:[UIImage imageNamed:@"logo4.png"]];
    [self.scrollView addSubview:imagePicker.view];
    [imagePicker release];
	
	// Add images to the picker
	// Note that this can take time due to resizing for thumbnails, so for production you
	// should either: a) have full-size and thumbs for each image pre-made, or:
	//                b) put a loading indicator in as this code runs
    for (int i = 2; i < colors.count; i++) {
        CGRect frame;
        frame.origin.x = self.scrollView.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = self.scrollView.frame.size;
        
        UIView *subview = [[UIView alloc] initWithFrame:frame];
        subview.backgroundColor = [colors objectAtIndex:i];
        [self.scrollView addSubview:subview];
        [subview release];
    }
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * colors.count, self.scrollView.frame.size.height);
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setPageControl:nil];
    [self setDetailsImageView:nil];
    [self setDetailsNameField:nil];
    [self setDetailsPhoneField:nil];
    [self setDetailsCityField:nil];
    [self setDetailsStateField:nil];
    [self setDetailsZipField:nil];
    [self setDetailsStreetField:nil];
    [self setDetailsMapView:nil];
    [self setDetailsView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
}

- (void)dealloc {
    [scrollView release];
    [pageControl release];
    [detailsImageView release];
    [detailsNameField release];
    [detailsPhoneField release];
    [detailsCityField release];
    [detailsStateField release];
    [detailsZipField release];
    [detailsStreetField release];
    [detailsMapView release];
    [detailsView release];
    [super dealloc];
}
- (IBAction)changePage:(id)sender {
    // update the scroll view to the appropriate page
    CGRect frame;
    frame.origin.x = self.scrollView.frame.size.width * self.pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    [self.scrollView scrollRectToVisible:frame animated:YES];
}
@end
