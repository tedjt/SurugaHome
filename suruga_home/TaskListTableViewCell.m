//
//  TaskListTableViewCell.m
//  suruga_home
//
//  Created by Ted Tomlinson on 1/9/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "TaskListTableViewCell.h"

@implementation TaskListTableViewCell

@synthesize touchIconDelegate;
@synthesize touchIconIndexPath;

- (void)dealloc {
    [touchIconIndexPath release];
    [super dealloc];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint location = [((UITouch *)[touches anyObject]) locationInView:self];
    if (CGRectContainsPoint(self.imageView.frame, location)) {
        [self.touchIconDelegate tableViewCellIconTouched:self indexPath:self.touchIconIndexPath];
        return;
    }
    [super touchesBegan:touches withEvent:event];
}

@end
