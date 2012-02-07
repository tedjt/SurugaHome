//
//  HomeLaunchViewController.h
//  suruga_home
//
//  Created by Ted Tomlinson on 1/23/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class Category;
@interface HomeLaunchViewController : UIViewController {
    UITableView *mTableView;
    UIButton *imageButton;
    UIButton *textButton;    
}
@property (nonatomic, retain) IBOutlet UIButton *imageButton;
@property (nonatomic, retain) IBOutlet UIButton *textButton;

//Configuration properties
@property (nonatomic, retain) NSString *pageTitle;
@property (nonatomic, retain) UIViewController *nextVC;
@property (nonatomic, retain) NSString *categoryName;

- (IBAction)homesButtonClicked:(id)sender;
- (IBAction)checklistClicked:(id)sender;
@end