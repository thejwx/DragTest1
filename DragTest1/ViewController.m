//
//  ViewController.m
//  DragTest1
//
//  Created by frogTemplate on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

#define DROPDISTANCE 10

@implementation ViewController

@synthesize dropZone = _dropZone;
@synthesize control = _control;
@synthesize touchPointDifference_x, touchPointDifference_y;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    // DEFINE A COUPLE POINTS
    CGPoint startingPoint = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height);
    CGPoint endingPoint = CGPointMake(100,100);

    // ADD THE DROPZONE
    _dropZone = [[UIView alloc] initWithFrame:CGRectMake(500, 500, 200, 200)];
    [_dropZone setBackgroundColor:[UIColor blueColor]];
    [self.view addSubview:_dropZone];
    
    // ADD THE DRAGGABLE BUTTON
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(startingPoint.x, startingPoint.y, 120, 120)];
    [button addTarget:self action:@selector(imageTouched:withEvent:) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(imageMoveEnded:) forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:self action:@selector(imageMovingOopsLostIt:withEvent:) forControlEvents:UIControlEventTouchDragExit];
    [button addTarget:self action:@selector(imageMovedLogged:withEvent:) forControlEvents:UIControlEventTouchDragExit];
    [button setImage:[UIImage imageNamed:@"vehicle.png"] forState:UIControlStateNormal];
    [self.view addSubview:button];    
    
    // ASSIGN PAN GESTURE RECOGNIZER
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [panGesture setMaximumNumberOfTouches:2];
    [button addGestureRecognizer:panGesture];
    [panGesture release];
    
    // MOVE THE DRAGGABLE BUTTON INTO VIEW
    [UIButton animateWithDuration:.3
                            delay:0
                          options: UIViewAnimationCurveEaseInOut
                       animations: ^{ button.center = endingPoint; }
                       completion: nil];
    
    }


- (void)viewDidUnload

{
    [self setDropZone:nil];
    [self setControl:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [_dropZone release];
    [_control release];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}


#pragma mark - TOUCH AND DRAG HANDLERS

- (IBAction) imageTouched:(id) sender withEvent:(UIEvent *) event
{
    CGPoint point = [[[event allTouches] anyObject] locationInView:self.view];
    UIControl *control = sender;
    touchPointDifference_x = point.x-control.center.x;
    touchPointDifference_y = point.y-control.center.y;
}

- (IBAction) imageMoving:(id) sender
{
    UIControl *control = sender;
    if (CGRectContainsPoint(_dropZone.frame, control.center)) {
        _dropZone.backgroundColor = [UIColor redColor];
    } else {
        _dropZone.backgroundColor = [UIColor blueColor];        
    }
}

- (IBAction) imageMoveEnded:(id) sender
{
    UIControl *control = sender;
    if (CGRectContainsPoint(_dropZone.frame, control.center)) {
        [UIButton animateWithDuration:.2
                                delay:0
                              options: UIViewAnimationCurveEaseIn
                           animations: ^{ control.center = _dropZone.center; }
                           completion:^ (BOOL finished) {
                                [UIButton animateWithDuration:.4
                                    delay:1
                                    options: UIViewAnimationCurveEaseInOut
                                    animations: ^{ control.center = CGPointMake(100,100); }
                                                   completion: ^(BOOL finished) {
                                                       [self imageMoving:control];
                                                   }];
                           }];
    } else {
        [UIButton animateWithDuration:.4
                                delay:0
                              options: UIViewAnimationCurveEaseInOut
                           animations: ^{ control.center = CGPointMake(100,100); }
                           completion: nil];
    }
}

- (IBAction) imageMovedLogged:(id) sender withEvent:(UIEvent *) event
{
    NSLog(@"Duely (dooly?) (duley?) noted.");
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    if(recognizer.state == UIGestureRecognizerStateBegan || 
       recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [recognizer translationInView:recognizer.view.superview];
        
        recognizer.view.center = 
        CGPointMake(recognizer.view.center.x + translation.x, 
                    recognizer.view.center.y + translation.y);
        [self imageMoving:recognizer.view];
        [recognizer setTranslation:CGPointZero inView:recognizer.view.superview];
    }
    if(recognizer.state == UIGestureRecognizerStateEnded) {
        [self imageMoveEnded:recognizer.view];
    }
}

@end
