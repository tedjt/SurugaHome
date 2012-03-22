//
//  NotesViewController.h
//  suruga_home
//
//  Created by Ted Tomlinson on 2/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Home.h"

@interface NotesViewController : UIViewController
@property (retain, nonatomic) IBOutlet UITextView *textView;
@property (retain, nonatomic) Home* home;

@end
