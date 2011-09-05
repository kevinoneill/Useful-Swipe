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

#import "ArraySamplesController.h"

@interface ArraySamplesController () <UITableViewDataSource>

@property (nonatomic, copy) NSArray *names;
@property (nonatomic, copy) NSArray *current;

@property (nonatomic, retain) UITableView *table;

@end

@implementation ArraySamplesController

@synthesize names = names_;
@synthesize current = current_;

@synthesize table = table_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
  {
    [self setTitle:@"Arrays"];
    
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
    [self setCurrent:[self names]];
  }
  
  return self;
}

- (void)dealloc
{
  UBRELEASE(table_);
  
  UBRELEASE(names_);
  UBRELEASE(current_);
  
  [super dealloc];
}

- (void)update:(id (^) (NSArray *source))action
{
  id result = action([self names]);
  
  NSArray *update = [result isKindOfClass:[NSArray class]] ? result : [NSArray arrayWithObject:result];
  
  [self setCurrent:update];
  [[self table] reloadData];
}

#pragma mark - Filter

static BOOL (^LongName) (id item) = ^ BOOL (id item) {
  return [item length] > 12;
};

- (void)doFilter;
{
  [self update:^ NSArray *(NSArray *source) {
    return [[self names] filter:LongName];
  }];
}

- (void)doPick;
{
  [self update:^ NSArray *(NSArray *source) {
    return [[self names] pick:LongName];
  }];
}

- (void)doFirst;
{
  [self update:^ NSString *(NSArray *source) {
    return [[self names] first:LongName];
  }];
}

- (void)doLast;
{
  [self update:^ NSString *(NSArray *source) {
    return [[self names] last:LongName];
  }];
}

#pragma mark - Transform

- (NSArray * (^) (NSArray *source))map;
{
  return [[^ NSArray *(NSArray *source) {
    return [[self names] map:^id(id item) {
      return [[item componentsSeparatedByString:@" "] last];
    }];
  } copy] autorelease];
}

- (void)doMap;
{
  [self update:^ NSArray *(NSArray *source) {
    return [[self names] map:^id(id item) {
      return [[item componentsSeparatedByString:@" "] last];
    }];
  }];
}

- (void)doReduce;
{
  [self update:^ NSString *(NSArray *source) {
    return [[[self names] reduce:^id(id current, id item) {
      return [NSNumber numberWithInteger:[current integerValue] + [item length]];
    } initial:[NSNumber numberWithInteger:0]] stringValue];
  }];
}

- (void)doChain;
{
  [self update:^ NSArray *(NSArray *source) {
    return [[[self names] map:^id(id item) {
      return [item componentsSeparatedByString:@" "];
    }] map:^id(id item) {
      return [[item reverse] componentsJoinedByString:@", "];
    }];
  }];
}

#pragma mark - Reset

- (void)doReset;
{
  [self update:^ NSArray *(NSArray *source) {
    return source;
  }];
}

#pragma mark - View lifecycle

- (void)loadView
{
  static const CGFloat kToolbarHeight = 50.;
  
  CGRect bounds = [[UIScreen mainScreen] bounds];
  
  UIView *container = [[UIView alloc] initWithFrame:bounds];
  [container setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
  [container setBackgroundColor:[UIColor redColor]];
  
  UIToolbar *tools = [[UIToolbar alloc] initWithFrame:CGRectInsetTop(bounds, bounds.size.height - kToolbarHeight)];
  [tools setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
  
//  NSArray *button_names = [NSArray arrayWithObjects:@"Map", @"Reduce", @"Chain", @"Reset", nil];
  NSArray *button_names = [NSArray arrayWithObjects:@"Filter", @"Pick", @"First", @"Last", @"Reset", nil];
    
  __block ArraySamplesController * _self_ = self; 
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
  
  [container addSubview:tools];
  
  UITableView *table = [[UITableView alloc] initWithFrame:CGRectInsetBottom(bounds, [tools height])];
  [table setDataSource:self];
  [table setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
  [self setTable:table];
  
  [container addSubview:table];
  
  UBRELEASE(table);
  UBRELEASE(tools);
  
  [self setView:container];
  UBRELEASE(container);
}

- (void)viewDidUnload
{
  UBRELEASE_NIL(table_);
  
  [super viewDidUnload];
}

#pragma make - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
  return [[self current] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
  static NSString *resuse_identifier = @"bob";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:resuse_identifier];
  if (nil == cell)
  {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:resuse_identifier] autorelease];
  }
  
  [[cell textLabel] setText:[[self current] objectAtIndex:[indexPath row]]];
  
  return cell;
}

@end
