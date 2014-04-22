//
//  NSString+URLEncoding.m
//  EmptyAppExample01
//
//  Created by Randall Nickerson on 3/4/14.
//  Copyright (c) 2014 Threadbare Games. All rights reserved.
//

#import "NSString+URLEncoding.h"

@implementation NSString (URLEncoding)


/*
 Example:
 
 NSString* raw = @"hell & brimstone + earthly/delight";
 NSString* url = [NSString stringWithFormat:@"http://example.com/example?param=%@", [raw urlEncodeUsingEncoding:NSUTF8Encoding]];
 
 url will be http://example.com/example?param=hell%20%26%20brimstone%20%2B%20earthly%2Fdelight
 
 */
- (NSString *) urlEncodeUsingEncoding:( NSStringEncoding ) encoding
{
    
	return (NSString *) CFBridgingRelease ( CFURLCreateStringByAddingPercentEscapes ( NULL,
                                                                                      (CFStringRef)self,
                                                                                      NULL,
                                                                                      (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                                      CFStringConvertNSStringEncodingToEncoding( encoding )));
    
}
@end
