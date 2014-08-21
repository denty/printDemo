//
//  PrintTable.m
//  printDemo
//
//  Created by broy denty on 14-8-12.
//  Copyright (c) 2014年 denty. All rights reserved.
//

#import "PrintTable.h"

@implementation PrintTable
{
    CGContextRef imageContext;
    CGColorSpaceRef colorSpace;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.image = [UIImage imageNamed:@"table.png"];
        // Initialization code
        
        // initalize bitmap context
		colorSpace = CGColorSpaceCreateDeviceRGB();
		imageContext = CGBitmapContextCreate(0,frame.size.width,
												  frame.size.height,
												  8,
												  frame.size.width*4,
												  colorSpace,
												  kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big	);
		CGContextDrawImage(imageContext, CGRectMake(0, 0, frame.size.width, frame.size.height), self.image.CGImage);
		
		int blendMode = kCGBlendModeClear;
		CGContextSetBlendMode(imageContext, (CGBlendMode) blendMode);
    }
    [self setUserInteractionEnabled:YES];
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [super drawRect:rect];

}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches)
    {
        CGContextBeginPath(imageContext);
        CGPoint point = [touch locationInView:self];
        CGRect rect = CGRectMake(point.x, self.frame.size.height-point.y, 15, 15);
        if (touch.phase == UITouchPhaseBegan)
        {
            CGContextAddEllipseInRect(imageContext, rect);
            CGContextFillPath(imageContext);
            //        CGContextStrokePath(imageContext);
        }
        else if (touch.phase == UITouchPhaseMoved)
        {
            // then touch moved, we draw superior-width line
            CGPoint prevPoint = [touch previousLocationInView:self];
            CGContextSetStrokeColor(imageContext,CGColorGetComponents([UIColor yellowColor].CGColor));
            CGContextSetLineCap(imageContext, kCGLineCapRound);
            CGContextSetLineWidth(imageContext, 15);
            CGContextMoveToPoint(imageContext, prevPoint.x, self.frame.size.height-prevPoint.y);
            CGContextAddLineToPoint(imageContext, rect.origin.x, rect.origin.y);
            CGContextStrokePath(imageContext);
        }
    }
    CGImageRef cgImage = CGBitmapContextCreateImage(imageContext);
	UIImage *image = [UIImage imageWithCGImage:cgImage];
	CGImageRelease(cgImage);
    self.image = image;
}

@end
