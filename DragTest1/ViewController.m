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

@synthesize dropZone    = _dropZone;
@synthesize control     = _control;
@synthesize touchPointDifference_x, touchPointDifference_y;
@synthesize simpleTracker;

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
    
    // ADD THE DROPZONE
    _dropZone = [[UIView alloc] initWithFrame:CGRectMake(500, 500, 200, 200)];
    [_dropZone setBackgroundColor:[UIColor blueColor]];
    [self.view addSubview:_dropZone];
    
    // SET DROPZONE TRACKER
    [self setSimpleTracker:0];
    
    //ADD THE BUTTONS
    [self addDragger:@"vehicle.png" startingPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height) endingPoint:CGPointMake(100,100) width:120 height:120];
    [self addDragger:@"vehicle.png" startingPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height) endingPoint:CGPointMake(150,240) width:120 height:120];
    [self addDragger:@"vehicle.png" startingPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height) endingPoint:CGPointMake(400,255) width:120 height:120];
    [self addDragger:@"vehicle.png" startingPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height) endingPoint:CGPointMake(120,300) width:120 height:120];
    [self addDragger:@"vehicle.png" startingPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height) endingPoint:CGPointMake(90,340) width:120 height:120];
    
}

- (void) addDragger:(NSString *)theImage startingPoint:(CGPoint)startingPoint endingPoint:(CGPoint)endingPoint width:(float)width height:(float)height {
    // ADD THE DRAGGABLE BUTTON
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(startingPoint.x, startingPoint.y, width, height)];
    [button setImage:[UIImage imageNamed:theImage] forState:UIControlStateNormal];
    [self.view addSubview:button];    

    // ASSIGN PAN GESTURE RECOGNIZER
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [panGesture setMaximumNumberOfTouches:2];
    [button addGestureRecognizer:panGesture];
    [panGesture release];
    [button.layer setValue:[NSValue valueWithCGPoint:endingPoint] forKey:@"originalCenter"];
    
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
    [self setControl:nil];;
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

- (void)checkIfOverTarget:(id) sender
{
    UIControl *control = sender;
    if (CGRectContainsPoint(_dropZone.frame, control.center) || simpleTracker>0) {
        _dropZone.backgroundColor = [UIColor redColor];
    } else {
        _dropZone.backgroundColor = [UIColor blueColor];        
    }
}

- (void)imageMoveEnded:(id) sender
{
    UIControl *control = sender;
    if (CGRectContainsPoint(_dropZone.frame, control.center)) {
        [UIButton animateWithDuration:.2
                  delay:0
                  options: UIViewAnimationCurveEaseIn
                  animations: ^{ simpleTracker++;
                                 control.center = _dropZone.center; 
                               }
                  completion:^ (BOOL finished) { [UIButton animateWithDuration:.4
                                                           delay:1
                                                           options: UIViewAnimationCurveEaseInOut
                                                           animations: ^{ control.center = [[control.layer valueForKey:@"originalCenter"] CGPointValue]; }
                                                           completion: ^(BOOL finished) { simpleTracker--;
                                                                                          [self checkIfOverTarget:control];
                                                                                        }];
                                               }];
    } else {
        [UIButton animateWithDuration:.4
                  delay:0
                  options: UIViewAnimationCurveEaseInOut
                  animations: ^{ control.center = [[control.layer valueForKey:@"originalCenter"] CGPointValue]; }
                  completion: nil];
    }
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    if(recognizer.state == UIGestureRecognizerStateBegan || recognizer.state == UIGestureRecognizerStateChanged) { 
        CGPoint translation = [recognizer translationInView:recognizer.view.superview];
        recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, 
        recognizer.view.center.y + translation.y);
        [self checkIfOverTarget:recognizer.view];
        [recognizer setTranslation:CGPointZero inView:recognizer.view.superview];
    }
    if(recognizer.state == UIGestureRecognizerStateEnded) {
        [self imageMoveEnded:recognizer.view];
    }
}

@end
