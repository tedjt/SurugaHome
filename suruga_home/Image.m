//
//  Image.m
//  suruga_home
//
//  Created by Ted Tomlinson on 12/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Image.h"
#import "UIImageExtras.h"


@implementation Image
@dynamic thumb;
@dynamic pathToFull;

# pragma mark private functions

- (NSString*) getUniqueString {
	CFUUIDRef theUUID = CFUUIDCreate(nil);
	CFStringRef str = CFUUIDCreateString(nil, theUUID);
	CFRelease(theUUID);
	return [(NSString *) str autorelease];
}

- (void) setValuesFromImage: (UIImage *) image {
    // Create a thumbnail version of the image for the recipe object.
    self.thumb =  UIImagePNGRepresentation([image imageByScalingAndCroppingForSize:CGSizeMake(80, 80)]);


    // Get the location of the Documents directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) ;
    NSString *imagePath = [paths objectAtIndex:0] ;
    self.pathToFull = [NSString stringWithFormat:@"%@.png", [self getUniqueString]];
    NSString *filepath = [NSString stringWithFormat:@"%@/%@", imagePath, self.pathToFull];
    
    // Save the image 
    NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(image)];
    [imageData writeToFile:filepath atomically:YES];
}

//TODO support scaling the returned image.
- (UIImage*) getLargeImage {
	// Get the location of the Documents directory
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) ;
	NSString *imagePath = [paths objectAtIndex:0] ;
	NSString *filepath = [NSString stringWithFormat:@"%@/%@", imagePath, self.pathToFull] ;
	
	NSData * imageData = [NSData dataWithContentsOfFile: filepath];
	return [UIImage imageWithData: imageData];
}

@end

@implementation ImageToDataTransformer


+ (BOOL)allowsReverseTransformation {
	return YES;
}

+ (Class)transformedValueClass {
	return [NSData class];
}


- (id)transformedValue:(id)value {
	NSData *data = UIImagePNGRepresentation(value);
	return data;
}


- (id)reverseTransformedValue:(id)value {
	UIImage *uiImage = [[UIImage alloc] initWithData:value];
	return [uiImage autorelease];
}

@end