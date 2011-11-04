//
//  LAAdditions.h
//  AbWorkout
//
//  Created by Lewis Anderson on 9/2/11.
//  Copyright 2011 Lewis Anderson. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FRAME_IN_NAV		CGRectMake(0,0,320,416)
#define FRAME_IN_NAV_TOOLBAR CGRectMake(0,0,320,372)

#define APP_NAME [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]

@interface NSObject (Math)

- (bool)isInRange:(double)input min:(double)min max:(double)max;

@end 


@interface NSData (String)

- (NSString *)stringValue;
- (NSString *)stringBinaryValue;

@end


@interface NSString (Data)

+ (NSString *)stringWithData:(NSData *)data;

@end


@interface UIView (General)

- (void)setBackgroundImage:(UIImage *)image;
- (void)removeAllSubviews;

@end


@interface UIView (FindFirstResponder)

- (UIView *)findFirstResponder;

@end

@interface UIButton (Image)

// sets background using a scaled, resizeable image
- (void)setBackgroundImageNamed:(NSString *)name forState:(UIControlState)state;

@end

@interface UIButton (Glossy)

- (void)setBorderAndText;
- (void)setYellowBackgroundForState:(UIControlState)state;
- (void)setGreenBackgroundForState:(UIControlState)state;
- (void)setBlueBackgroundForState:(UIControlState)state;
- (void)setRedBackgroundForState:(UIControlState)state;

@end

@interface UIImage (Gradient)

void drawCurvedGloss(CGContextRef context, CGRect rect, float height, float r, float g, float b);
+ (UIImage *)gradientForColor:(int)color height:(float)height;

@end

@interface UIImage (Resize)

+ (UIImage *)resizableImageNamed:(NSString *)name forHeight:(float)height;

@end


@interface UIColor (Shadow)

+ (UIColor *)darkShadowColor;
+ (UIColor *)lightShadowColor;

@end

@interface UIScrollView (General)

- (void)removeAllSubviews;

@end


@interface UIViewController (Background)

- (void)setBackgroundImage:(UIImage *)image;

@end


@interface UIViewController (NumberPad)

- (void)beginModifyingNumberPad;
- (void)endModifyingNumberPad;
- (void)keyboardWillShow:(NSNotification *)notification;
- (void)addDoneButton:(NSNotification *)notification;

@end



@interface NSArray (Random)

- (id)objectAtRandom;

@end


@interface NSMutableArray (Stack)

- (id)pop;

@end




@interface NSMutableArray (Various)

- (id)getAndRemoveFirst;
- (void)shuffle;
- (id)popAndRotate;

@end



@interface UIWebView (NoBounce)

- (void)setBounces:(BOOL)bounces;

@end



@interface UIAlertView (Factory)

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message 
		 cancelButtonTitle:(NSString *)cancelTitle;

@end


@interface NSString (Data)

+ (NSString *)stringWithData:(NSData *)data;

@end


@interface NSString (Paths)

+ (NSString *)pathForResourceInBundleNamed:(NSString *)path;

@end


//
// Courtesy of Adam Preble
// http://www.informit.com/blogs/blog.aspx?uk=Ask-Big-Nerd-Ranch-Blocks-in-Objective-C
//
@interface NSThread (BlocksAdditions)
- (void)performBlock:(void (^)())block;
- (void)performBlock:(void (^)())block waitUntilDone:(BOOL)wait;
+ (void)performBlockOnMainThread:(void (^)())block;
+ (void)performBlockInBackground:(void (^)())block;
@end




//
// Courtesy of jivadevoe
// https://github.com/jivadevoe/NSTimer-Blocks/blob/master/NSTimer+Blocks.h
//
@interface NSTimer (Blocks)
+(id)scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats;
+(id)timerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats;
@end