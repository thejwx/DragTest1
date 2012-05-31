//
//  ViewController.h
//  DragTest1
//
//  Created by frogTemplate on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (retain, nonatomic) IBOutlet UIView *dropZone;
@property (retain, nonatomic) IBOutlet UIControl *control;
@property float touchPointDifference_x;
@property float touchPointDifference_y;
@property int simpleTracker;

- (void)addDragger:(NSString *)theImage startingPoint:(CGPoint)startingPoint endingPoint:(CGPoint)endingPoint width:(float)width height:(float)height;
- (void)checkIfOverTarget:(id) sender;
- (void)imageMoveEnded:(id) sender;
- (void)handlePan:(UIPanGestureRecognizer *)recognizer;
    
@end
