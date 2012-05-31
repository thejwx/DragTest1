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

- (IBAction) imageTouched:(id) sender withEvent:(UIEvent *) event;
- (IBAction) imageMoving:(id) sender;
- (IBAction) imageMoveEnded:(id) sender;
- (IBAction) imageMovedLogged:(id) sender withEvent:(UIEvent *) event;
- (void)handlePan:(UIPanGestureRecognizer *)recognizer;
    
@end
