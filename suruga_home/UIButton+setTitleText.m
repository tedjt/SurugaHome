//
//  UIButton+setTitleText.m
//  suruga_home
//
//  Created by Ted Tomlinson on 5/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIButton+setTitleText.h"

@implementation UIButton (setTitleText)

-(void) setTitleText:(NSString *) title {
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateHighlighted];
    [self setTitle:title forState:UIControlStateDisabled];
    [self setTitle:title forState:UIControlStateSelected];   
}
@end
