//
//  OneBoxImageViewController.h
//  DubbleWrapper
//
//  Created by Glen Urban on 6/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Furniture.h"
#import "PhotoAppViewController.h"
#import "OneRoomTableViewController.h"

@interface FurnitureItemViewController : UIViewController < UITextFieldDelegate, PhotoDelegate, UIPickerViewDataSource, UIPickerViewDelegate>{
	Furniture * furniture;
    UITextField * textFieldName;
    UITextField *textFieldPrice;
    UITextField *textFieldType;
    UIPickerView *typePicker;
    NSArray *typePickerArray;
	UIImageView * imageView;
	UIButton		*cameraButton;
	//NSManagedObjectContext *managedObjectContext;
	OneRoomTableViewController *parentController;
	
}

@property (nonatomic, retain) Furniture * furniture;
@property (nonatomic, retain) IBOutlet UITextField * textFieldName;
@property (nonatomic, retain) IBOutlet UITextField *textFieldPrice;
@property (nonatomic, retain) IBOutlet UITextField *textFieldType;
@property (nonatomic, retain) IBOutlet UIPickerView *typePicker;
@property (nonatomic, retain) IBOutlet NSArray *typePickerArray;
@property (nonatomic, retain) IBOutlet UIImageView * imageView;
@property (nonatomic, retain) IBOutlet UIButton		*cameraButton;
@property (nonatomic, retain) 	OneRoomTableViewController *parentController;

//@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (IBAction)cameraButtonClick:(id)sender;

- (void) saveData;

@end
