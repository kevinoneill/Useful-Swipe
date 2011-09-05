//
//  GestureController.m
//  UsefulSwipe
//
//  Created by Kevin O'Neill on 5/09/11.
//  Copyright (c) 2011 Kevin O'Neill. All rights reserved.
//

#import "GestureController.h"

#import <UsefulBits/UIView+Actions.h>
#import <UsefulBits/UIGestureRecognizer+Blocks.h>
#import <UsefulBits/Layout.h>

@interface GestureController ()

@property (nonatomic, copy) NSArray *names;
@property (nonatomic, retain) ManagedLayoutView *managed;

@end


@implementation GestureController

@synthesize names = names_;
@synthesize managed = managed_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
  {
    [self setTitle:@"Gestures"];
    
    [self setNames:[NSArray arrayWithObjects:
                    @"Mike Rundle",
                    @"Matt Gallagher",
                    @"Cathy Shive",
                    @"Josh Clark",
                    @"Alan Rogers",
                    @"Marc Edwards",
                    @"Russell Ivanovic",
                    @"Max Wheeler",
                    @"Oliver Weidlich",
                    @"Danny Gorog",
                    @"Duncan Bucknell",
                    @"Ben Britten Smith",
                    @"Toby Vincent",
                    @"Kevin O'Neill",
                    @"Paris Buttfield-Addison",
                    @"Stewart Gleadow",
                    nil]];
  }
  
  return self;
}

- (void)dealloc
{
  UBRELEASE(names_);
  
  [super dealloc];
}

#pragma mark - Layouts

- (void)showNames:(BOOL)reverse;
{
  UIView *view = [self managed];
  
  [view removeSubviews];
  
  NSArray *names = reverse ? [[self names] reverse] : [self names];
  
  [view addSubviews:[names map:^ id (id name) {
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    [label setFont:[UIFont boldSystemFontOfSize:14]];
    [label setText:name];
    [label setNumberOfLines:0];
    return label;
  }]];
  
  [view setWidth:[[self view] width]];
  [view sizeToFit];
  
  [[self view] removeSubviews];
  [[self view] addSubview:view];
}

#pragma mark - View lifecycle

- (void)loadView
{
  CGRect bounds = [[UIScreen mainScreen] bounds];
  
  ManagedLayoutView *managed = [[ManagedLayoutView alloc] initWithFrame:CGRectMake(0, 0, bounds.size.width, 0)];
  [managed setLayoutManager:[VerticalStackLayout instance]];
  [managed setBackgroundColor:[UIColor redColor]];
  [self setManaged:managed];
  
  UIView *container = [[UIView alloc] initWithFrame:bounds];
  [container setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
  [container setBackgroundColor:[UIColor blackColor]];

  __block GestureController *_self_ = self;
  __block UIView *_container_ = container;
  
  [container onTap:^(id sender) {
    [_self_ showNames:NO];
  }];
  
  [container onDoubleTap:^(id sender) {
    [_self_ showNames:YES];
  }];
  
  [container onTap:^(id sender) {
    [_container_ removeSubviews];
    [_container_ setBackgroundColor:[UIColor blackColor]];
  } touches:2];
  
  UISwipeGestureRecognizer *swipe_left = [UISwipeGestureRecognizer instanceWithActionBlock:^(UIGestureRecognizer *gesture) {
    [_container_ setBackgroundColor:[UIColor yellowColor]];
  }];
  [swipe_left setDirection:UISwipeGestureRecognizerDirectionLeft];
  [container addGestureRecognizer:swipe_left];

  UISwipeGestureRecognizer *swipe_right = [UISwipeGestureRecognizer instanceWithActionBlock:^(UIGestureRecognizer *gesture) {
    [_container_ setBackgroundColor:[UIColor blueColor]];
  }];
  [swipe_right setDirection:UISwipeGestureRecognizerDirectionRight];
  [container addGestureRecognizer:swipe_right];

  UILongPressGestureRecognizer *long_press = [UILongPressGestureRecognizer instanceWithActionBlock:^(UIGestureRecognizer *gesture) {
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"swipe-logo.png"]];
    [image setAlpha:0];
    [_container_ removeSubviews];
    [_container_ addSubview:image];
    [image centerInSuperView];
    
    [UIView animateWithDuration:2. animations:^{
      [_container_ setBackgroundColor:[UIColor blackColor]];
      [image setAlpha:1];
    }];
    
    UBRELEASE(image);
  }];
  [long_press setMinimumPressDuration:1];
  
  [container addGestureRecognizer:long_press];
  
  [container addSubview:managed];
  UBRELEASE(managed);
  
  [self setView:container];
}

@end