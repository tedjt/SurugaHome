//
//  OneBoxTableViewController.h
//  DubbleWrapper
//
//  Created by Glen Urban on 6/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Room.h"

@interface OneRoomTableViewController : UITableViewController < UITextFieldDelegate>{
	Room *room;
	UITextField	*textFieldName;
	UILabel *labelPrice;
	
	NSMutableArray *roomItems;

}


@property (nonatomic, retain) IBOutlet UITextField	*textFieldName;
@property (nonatomic, retain) IBOutlet UILabel	*labelPrice;

@property (nonatomic, retain) Room *room;

@property (nonatomic, retain) NSMutableArray *roomItems;

- (void)setUpTextFields;

- (void)showFurnitureItem:(Furniture*) furniture editMode: (BOOL) editMode animated:(BOOL)animated;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath ;

- (void) saveData;

@end
