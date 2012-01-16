//
//  Image.h
//  suruga_home
//
//  Created by Ted Tomlinson on 12/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface ImageToDataTransformer : NSValueTransformer {
}
@end

@interface Image : NSManagedObject {
}
@property (nonatomic, retain) id thumb;
@property (nonatomic, retain) NSString * pathToFull;

- (void) setValuesFromImage: (UIImage *) image;
- (UIImage*) getLargeImage;

@end
