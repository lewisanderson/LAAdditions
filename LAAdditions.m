//
//  LAAdditions.m
// 
//
//  Created by Lewis Anderson on 9/2/11.
//  Copyright 2011 Lewis Anderson. All rights reserved.
//

#import "LAAdditions.h"
#include <QuartzCore/QuartzCore.h>
#include <QuartzCore/CALayer.h>

@implementation NSObject (Math)

- (bool)isInRange:(double)input min:(double)min max:(double)max
{
	if (input >= min && input <= max)
		return TRUE;
	else
		return FALSE;
}

@end


@implementation NSData (String)

- (NSString *)stringValue
{
	return [NSString stringWithData:self];
}

- (NSString *)stringBinaryValue
{
	NSMutableString *string = [NSMutableString stringWithCapacity:[self length]*2];
	const char *bytes = (const char *)[self bytes];
	for (int i = 0; i < [self length];i++)
	{
		[string appendFormat:@"%02hhx",bytes[i]];
	}
	
	//NSLog(@"%d==%d", [self length], [string length]);
	
	return string;
}

@end



@implementation UIImage (Resize)

+ (UIImage *)resizableImageNamed:(NSString *)name forHeight:(float)height
{
	UIImage *original = [UIImage imageNamed:name];
	float heightChange = (original.size.height/height);
//	NSLog(@"%f = %f / %f", heightChange, original.size.height, height);
	if (heightChange < 0.9999 || heightChange > 1.0001)  // TEST	
	{
		float newScale = original.scale * heightChange;
//		NSLog(@"changing scale %.3f to %.3f", original.scale, newScale);
		original = [UIImage imageWithCGImage:[original CGImage] scale:newScale  orientation:UIImageOrientationUp];
	}
	UIImage *stretch = [original resizableImageWithCapInsets:UIEdgeInsetsMake(11,11,11,11)];
	
	return stretch;
}

@end


@implementation UIButton (Image)

// sets background using a scaled, resizeable image
- (void)setBackgroundImageNamed:(NSString *)name forState:(UIControlState)state
{
	UIImage *image = [UIImage resizableImageNamed:name forHeight:self.frame.size.height];
	[self setBackgroundImage:image forState:state];
}

@end

const int kYellowColor = 0;
const int kGreenColor = 1;
const int kBlueColor = 2;
const int kRedColor = 3;

@implementation UIButton (Glossy)

- (void)setBorderAndText 
{
	self.layer.masksToBounds = TRUE;
	self.layer.borderWidth = 0.5;
	self.layer.cornerRadius = 5.0;
	self.layer.borderColor = [[UIColor darkGrayColor] CGColor];
	self.titleLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.75];
//	self.layer.shadowOpacity = 0.75;
//	self.layer.shadowColor = [[UIColor whiteColor] CGColor];
//	self.layer.shadowOffset = CGSizeMake(0.0, 1.0);
//	self.layer.shadowRadius = 0.0;
}

- (void)setYellowBackgroundForState:(UIControlState)state
{
	[self setBackgroundImage:[UIImage gradientForColor:kYellowColor height:self.frame.size.height] forState:state];
}

- (void)setGreenBackgroundForState:(UIControlState)state
{
	[self setBackgroundImage:[UIImage gradientForColor:kGreenColor height:self.frame.size.height] forState:state];
}

- (void)setBlueBackgroundForState:(UIControlState)state
{
	[self setBackgroundImage:[UIImage gradientForColor:kBlueColor height:self.frame.size.height] forState:state];
}

- (void)setRedBackgroundForState:(UIControlState)state
{
	[self setBackgroundImage:[UIImage gradientForColor:kRedColor height:self.frame.size.height] forState:state];
}

@end

@implementation UIImage (Gradient)

// draw half-gradient (relies on functions I dont have)
void drawCurvedGloss(CGContextRef context, CGRect rect, float height, float r, float g, float b) 
{
	// 1-high = dark, 1-low=light
	float factor = 1.0-0.5;//0.39;
	CGColorRef glossStart = [UIColor colorWithRed:(r+factor*(1.0-r)) green:(g+factor*(1.0-g)) blue:(b+factor*(1.0-b)) alpha:1.0].CGColor;
	factor = 1.0-0.79;
	CGColorRef glossEnd = [UIColor colorWithRed:(r+factor*(1.0-r)) green:(g+factor*(1.0-g)) blue:(b+factor*(1.0-b)) alpha:1.0].CGColor;
	factor = 1.0-1.0;
	CGColorRef solidColor = [UIColor colorWithRed:(r+factor*(1.0-r)) green:(g+factor*(1.0-g)) blue:(b+factor*(1.0-b)) alpha:1.0].CGColor;
	
	
	NSMutableArray *normalGradientLocations = [NSMutableArray arrayWithObjects:
                                               [NSNumber numberWithFloat:0.0f],
                                               [NSNumber numberWithFloat:1.0f],
                                               nil];
	
	NSArray *colors = [NSArray arrayWithObjects:(__bridge id)glossStart, (__bridge id)glossEnd, nil];
	
    int locCount = [normalGradientLocations count];
    CGFloat locations[locCount];
    for (int i = 0; i < [normalGradientLocations count]; i++)
    {
        NSNumber *location = [normalGradientLocations objectAtIndex:i];
        locations[i] = [location floatValue];
    }
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
	
    CGGradientRef normalGradient = CGGradientCreateWithColors(space, (__bridge CFArrayRef)colors, locations);
    CGColorSpaceRelease(space);
	CGContextDrawLinearGradient(context, normalGradient, CGPointMake(0.5, 0.0), CGPointMake(0.5, height/2.0), 0);
	CGContextSetFillColorWithColor(context, solidColor);
	CGContextFillRect(context, CGRectMake(0, height/2.0, 1, height/2.0));
	
}

+ (UIImage *)gradientForColor:(int)color height:(float)height
{
	// TODO return resizable image with height and color
//	CGColorRef endColor = [UIColor colorWithRed:182.0/255.0 green:28.0/255.0 blue:38.0/255.0 alpha:1.0].CGColor;
	
	UIGraphicsBeginImageContext(CGSizeMake(1, height));
	CGContextRef context = UIGraphicsGetCurrentContext();
	float red,green,blue;
	if (color == kRedColor)
	{
		red = 182.0/255.0;
		green = 28.0/255.0;
		blue = 38.0/255.0;
	}
	else if (color == kYellowColor)
	{
		red = 0.659;
		green = 0.647;
		blue = 0.235;
	}
	else if (color == kGreenColor)
	{
		red = 0.0;
		green = 0.611;//663;
		blue = 0.250;//271;
	}
	else // kBlueColor
	{
		red = 0.192;
		green = 0.337;
		blue = 0.624;
	}
	drawCurvedGloss(context, CGRectMake(0, 0, 1, height), height, red, green, blue );
	
	UIImage* img = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	return img;
}

@end



@implementation UIColor (Shadow)

+ (UIColor *)darkShadowColor
{
	return [UIColor colorWithWhite:0.0 alpha:0.75];
}

+ (UIColor *)lightShadowColor
{
	return [UIColor colorWithWhite:1.0 alpha:0.75];
}

@end


@implementation NSString (Data)

+ (NSString *)stringWithData:(NSData *)data
{
	NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	return string;
}

@end

@implementation UIView (General)

- (void)setBackgroundImage:(UIImage *)image
{
	if (image == nil)
	{
		NSLog(@"ERR in UIView::setBackgroundImage: image == nil");
		return;
	}
	
	UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:image];
	backgroundImage.frame = self.frame;
	[self addSubview:backgroundImage];
	[self sendSubviewToBack:backgroundImage];
}

- (void)removeAllSubviews
{
	while ([self.subviews count] > 0)
		[[self.subviews objectAtIndex:0] removeFromSuperview];
}

@end

@implementation UIView (FindFirstResponder)

- (UIView *)findFirstResponder
{
    if (self.isFirstResponder) {        
        return self;     
    }
	
    for (UIView *subView in self.subviews) {
        UIView *firstResponder = [subView findFirstResponder];
		
        if (firstResponder != nil) {
            return firstResponder;
        }
    }
	
    return nil;
}

@end

@implementation UIViewController (Background)

- (void)setBackgroundImage:(UIImage *)image
{
	[self.view setBackgroundImage:image];
}

@end

@implementation UIViewController (NumberPad)

- (void)beginModifyingNumberPad
{
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(keyboardWillShow:) 
												 name:UIKeyboardWillShowNotification 
											   object:nil];
}

- (void)endModifyingNumberPad
{
	[[NSNotificationCenter defaultCenter] removeObserver:self 
													name:UIKeyboardWillShowNotification 
												  object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification 
{  
	[self performSelector:@selector(addDoneButton:) 
			   withObject:notification 
			   afterDelay:0];
}

- (void)addDoneButton:(NSNotification *)notification
{
	UITextField *textField = (UITextField *)[self.view findFirstResponder];
	if (textField != nil && textField.keyboardType == UIKeyboardTypeNumberPad)
	{
		// create custom button
		UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
		doneButton.frame = CGRectMake(0, 163, 106, 53);
		doneButton.adjustsImageWhenHighlighted = NO;
		[doneButton setImage:[UIImage imageNamed:@"doneup.png"] forState:UIControlStateNormal];
		[doneButton setImage:[UIImage imageNamed:@"donedown.png"] forState:UIControlStateHighlighted];
		[doneButton addTarget:self action:@selector(doneButton:) forControlEvents:UIControlEventTouchUpInside];
		
		// Locate non-UIWindow.
		UIWindow *keyboardWindow = nil;
		for (UIWindow *testWindow in [[UIApplication sharedApplication] windows]) {
			if (![[testWindow class] isEqual:[UIWindow class]]) {
				keyboardWindow = testWindow;
				break;
			}
		}
		if (!keyboardWindow) return;
		
		// Locate UIKeyboard.
		UIView *foundKeyboard = nil;
		for (__strong UIView *possibleKeyboard in [keyboardWindow subviews]) {
			
			// iOS 4 sticks the UIKeyboard inside a UIPeripheralHostView.
			if ([[possibleKeyboard description] hasPrefix:@"<UIPeripheralHostView"]) {
				possibleKeyboard = [[possibleKeyboard subviews] objectAtIndex:0];
			}
			
			if ([[possibleKeyboard description] hasPrefix:@"<UIKeyboard"]) {
				foundKeyboard = possibleKeyboard;
				break;
			}
		}
		
		if (foundKeyboard) {
			[foundKeyboard addSubview:doneButton];
		}
	}
}

- (void)doneButton:(id)sender
{
	[self.view endEditing:YES];
}

@end

@implementation NSArray (Random)

- (id)objectAtRandom
{
	srand(time(NULL));
	int index = rand()%[self count];
	return [self objectAtIndex:index];
}

@end

@implementation UIWebView (NoBounce)

- (void)setBounces:(BOOL)bounces
{
	for (id subview in self.subviews)
		if ([[subview class] isSubclassOfClass:[UIScrollView class]])
			((UIScrollView *)subview).bounces = bounces;
}

@end

@implementation NSMutableArray (Stack)

- (id)pop
{
	id object = [self lastObject];
	[self removeLastObject];
	return object;
}

@end

// http://stackoverflow.com/questions/791232/canonical-way-to-randomize-an-nsarray-in-objective-c
static NSUInteger random_below(NSUInteger n) {
	NSUInteger m = 1;
	srand ( time(NULL) );
	
	do {
		m <<= 1;
	} while(m < n);
	
	NSUInteger ret;
	
	do {
		ret = rand() % m;
	} while(ret >= n);
	
	return ret;
}

@implementation NSMutableArray (Various)

- (void)shuffle {	
    for(NSUInteger i = [self count]; i > 1; i--) {
        NSUInteger j = random_below(i);
        [self exchangeObjectAtIndex:i-1 withObjectAtIndex:j];
    }
}

- (id)getAndRemoveFirst
{
	if ([self count] == 0)
		return nil;
	
	id first = [self objectAtIndex:0];
	[self removeObjectAtIndex:0];
	return first;
}

- (id)popAndRotate
{
	if ([self count] == 0)
		return nil;
	
	id first = [self getAndRemoveFirst];
	[self addObject:first];
	
	return first;
}

@end

@implementation UIAlertView (Factory)

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message 
				  cancelButtonTitle:(NSString *)cancelTitle
{
	UIAlertView *alert = [[self alloc] initWithTitle:title 
													message:message 
												   delegate:nil 
										  cancelButtonTitle:cancelTitle 
										  otherButtonTitles:nil];
	[alert show];
}

@end


@implementation NSString (Paths)

+ (NSString *)pathForResourceInBundleNamed:(NSString *)path
{
	return [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:path];
}

@end


//
// Courtesy of Adam Preble
// http://www.informit.com/blogs/blog.aspx?uk=Ask-Big-Nerd-Ranch-Blocks-in-Objective-C
//
@implementation NSThread (BlocksAdditions)
- (void)performBlock:(void (^)())block
{
	if ([[NSThread currentThread] isEqual:self])
		block();
	else
		[self performBlock:block waitUntilDone:NO];
}
- (void)performBlock:(void (^)())block waitUntilDone:(BOOL)wait
{
    [NSThread performSelector:@selector(ng_runBlock:)
                     onThread:self
                   withObject:[block copy]
                waitUntilDone:wait];
}
+ (void)ng_runBlock:(void (^)())block
{
	@autoreleasepool {
		block();
	}
}

+ (void)performBlockOnMainThread:(void (^)())block
{
    [NSThread performSelector:@selector(ng_runBlock:)
                     onThread:[NSThread mainThread]
                   withObject:[block copy]
                waitUntilDone:wait];
}

+ (void)performBlockInBackground:(void (^)())block
{
	[NSThread performSelectorInBackground:@selector(ng_runBlock:)
	                           withObject:[block copy]];
}
@end

/*
 Courtesy of jivadevoe
 https://github.com/jivadevoe/NSTimer-Blocks/blob/master/NSTimer+Blocks.h
 
 LICENSE (applies to NSTimer (Blocks) Category)
 
 Copyright (C) 2011 by Random Ideas, LLC
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of 
 this software and associated documentation files (the "Software"), to deal in 
 the Software without restriction, including without limitation the rights to 
 use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies 
 of the Software, and to permit persons to whom the Software is furnished to do 
 so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all 
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE 
 SOFTWARE.
 
 */
@implementation NSTimer (Blocks)

+(id)scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval 
							  block:(void (^)())inBlock 
							repeats:(BOOL)inRepeats
{
    void (^block)() = [inBlock copy];
    id ret = [self scheduledTimerWithTimeInterval:inTimeInterval 
										   target:self 
										 selector:@selector(jdExecuteSimpleBlock:) 
										 userInfo:block repeats:inRepeats];
    return ret;
}

+(id)timerWithTimeInterval:(NSTimeInterval)inTimeInterval
					 block:(void (^)())inBlock 
				   repeats:(BOOL)inRepeats
{
    void (^block)() = [inBlock copy];
    id ret = [self timerWithTimeInterval:inTimeInterval 
								  target:self 
								selector:@selector(jdExecuteSimpleBlock:) 
								userInfo:block 
								 repeats:inRepeats];
    return ret;
}

+(void)jdExecuteSimpleBlock:(NSTimer *)inTimer;
{
    if([inTimer userInfo])
    {
        void (^block)() = (void (^)())[inTimer userInfo];
        block();
    }
}

@end

