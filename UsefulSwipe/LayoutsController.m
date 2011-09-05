  //  Copyright (c) 2011, Kevin O'Neill
  //  All rights reserved.
  //
  //  Redistribution and use in source and binary forms, with or without
  //  modification, are permitted provided that the following conditions are met:
  //
  //  * Redistributions of source code must retain the above copyright
  //   notice, this list of conditions and the following disclaimer.
  //
  //  * Redistributions in binary form must reproduce the above copyright
  //   notice, this list of conditions and the following disclaimer in the
  //   documentation and/or other materials provided with the distribution.
  //
  //  * Neither the name UsefulSwipe nor the names of its contributors may be used
  //   to endorse or promote products derived from this software without specific
  //   prior written permission.
  //
  //  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  //  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  //  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  //  DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
  //  DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  //  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  //  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  //  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  //  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  //  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "LayoutsController.h"

#import <UsefulBits/Layout.h>

@interface LayoutsController ()

@property (nonatomic, copy) NSArray *names;

@property (nonatomic, retain) UIScrollView *scroller;
@property (nonatomic, retain) ManagedLayoutView *managed;

@end

@implementation LayoutsController

@synthesize names = names_;

@synthesize scroller = scroller_;
@synthesize managed = managed_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
  {
    [self setTitle:@"Layouts"];
    
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
                     @"Alex Johnston",
                     @"Nathan de Vries",
                     @"Jake MacMullin",
                     @"Hilary Cinis",
                     @"Aaron Vernon",
                     @"Scott Brewer",
                     nil]];
  }
  
  return self;
}

- (void)dealloc
{
  UBRELEASE(scroller_);
  UBRELEASE(managed_);
  
  UBRELEASE(names_);
  
  [super dealloc];
}

#pragma mark - Layouts

- (void)updateLayout:(id <LayoutManager>)layout;
{
  [[self managed] setLayoutManager:layout];
  [[self managed] sizeToFit];
  [[self scroller] setContentSize:[[self managed] size]];  
}

- (void)doOne;
{
  ColumnLayout *layout = [ColumnLayout instance];
  [layout setPadding:5.];
  [layout setGutter:0.];
  [layout setColumns:1];
  
  [self updateLayout:layout];
}

- (void)doTwo;
{
  ColumnLayout *layout = [ColumnLayout instance];
  [layout setPadding:5.];
  [layout setGutter:10.];
  [layout setColumns:2];
  
  [self updateLayout:layout];
}

- (void)doThree;
{
  ColumnLayout *layout = [ColumnLayout instance];
  [layout setPadding:5.];
  [layout setGutter:10.];
  [layout setColumns:3];
  
  [self updateLayout:layout];
}

#pragma mark - Reset

- (void)doReset;
{
  [[self managed] setWidth:[[self scroller] bounds].size.width];
  VerticalStackLayout *layout = [VerticalStackLayout instance];
  [self updateLayout:layout];
}

#pragma mark - View lifecycle

- (void)loadView
{
  static const CGFloat kToolbarHeight = 50.;
  
  CGRect bounds = [[UIScreen mainScreen] bounds];
    
  UIToolbar *tools = [[UIToolbar alloc] initWithFrame:CGRectInsetTop(bounds, bounds.size.height - kToolbarHeight)];
  [tools setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
  
  NSArray *button_names = [NSArray arrayWithObjects:@"One", @"Two", @"Three", @"Reset", nil];
  
  __block id _self_ = self; 
  NSArray *buttons = [button_names map:^ id (id title) {
    SEL action = NSSelectorFromString([@"do" stringByAppendingString:title]);
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:title
                                                               style:UIBarButtonItemStylePlain
                                                              target:_self_
                                                              action:action];
    return [button autorelease];
  }];
  
  [tools setItems:[buttons intersperse: ^ (id ignore_current, id ignore_next) {
    return [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                          target:nil
                                                          action:nil] autorelease];
  }] animated:NO];
  
  ManagedLayoutView *managed = [[ManagedLayoutView alloc] initWithFrame:CGRectMake(0, 0, bounds.size.width, 0)];
  [managed setLayoutManager:[VerticalStackLayout instance]];
  [managed setBackgroundColor:[UIColor redColor]];
  
  [managed addSubviews:[[self names] map:^ id (id name) {
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    [label setText:name];
    [label setNumberOfLines:0];
    return label;
  }]];
  [managed sizeToFit];
  
  UIScrollView *scroller = [[UIScrollView alloc] initWithFrame:CGRectInsetBottom(bounds, [tools height])];
  [scroller setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
  [scroller addSubview:managed];
  [scroller setContentSize:[managed size]];
  
  UIView *container = [[UIView alloc] initWithFrame:bounds];
  [container addSubview:scroller];
  [container addSubview:tools];
  
  [self setManaged:managed];
  [self setScroller:scroller];
  [self setView:container];

  UBRELEASE(scroller);
  UBRELEASE(tools);
  UBRELEASE(container);
}

- (void)viewDidUnload
{
  UBRELEASE_NIL(scroller_);
  UBRELEASE_NIL(managed_);
  
  [super viewDidUnload];
}

@end
