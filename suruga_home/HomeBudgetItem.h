//
//  BudgetItem.h
//  suruga_home
//
//  Created by Ted Tomlinson on 1/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseBudgetItem.h"

@class Home;

@interface HomeBudgetItem : BaseBudgetItem {
@private
}
@property (nonatomic, retain) Home *home;

@end
