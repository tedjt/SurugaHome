//
//  NSString+URLEncoding.m
//  suruga_home
//
//  Created by Ted Tomlinson on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSString+URLEncoding.h"

@implementation NSString (URLEncoding)
-(NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding {
	return (NSString *)CFURLCreateStringByAddingPercentEscapes(
        NULL,
        (CFStringRef)self,
        NULL,
        (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
        CFStringConvertNSStringEncodingToEncoding(encoding));
}
@end