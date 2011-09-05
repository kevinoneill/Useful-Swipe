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

#import "UsefulSwipeAppDelegate.h"

#import <UsefulBits/UsefulBits.h>

#import "ArraySamplesController.h"
#import "LayoutsController.h"
#import "GestureController.h"

#ifdef TARGET_IPHONE_SIMULATOR
  #import "DCIntrospect.h"
#endif

@interface UsefulSwipeAppDelegate ()

@property (nonatomic, retain) UIViewController *root;

@end

@implementation UsefulSwipeAppDelegate

@synthesize window = window_;
@synthesize root = root_;

- (void)dealloc
{
  UBRELEASE(window_);
  UBRELEASE(root_);
  
  [super dealloc];
}

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  window_ = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  
  ArraySamplesController *array_controller = [[ArraySamplesController alloc] initWithNibName:nil bundle:nil];
  UINavigationController *array_samples = [[UINavigationController alloc] initWithRootViewController:array_controller];
  UBRELEASE(array_controller);
  
  LayoutsController *layout_controller = [[LayoutsController alloc] initWithNibName:nil bundle:nil];
  UINavigationController *layout_samples = [[UINavigationController alloc] initWithRootViewController:layout_controller];
  UBRELEASE(layout_controller);
  
  GestureController *gesture_controller = [[GestureController alloc] initWithNibName:nil bundle:nil];
  UINavigationController *gesture_samples = [[UINavigationController alloc] initWithRootViewController:gesture_controller];
  UBRELEASE(gesture_controller);

  NSArray *controllers = [NSArray arrayWithObjects:
                          array_samples,
                          layout_samples,
                          gesture_samples,
                          nil];
  
  UBRELEASE(array_samples);
  UBRELEASE(layout_samples);
  UBRELEASE(gesture_samples);
  
  UITabBarController *tab_controller = [[UITabBarController alloc] initWithNibName:nil bundle:nil];
  [tab_controller setViewControllers:controllers];
  UBRELEASE(controllers);
   
  root_ = tab_controller;
  [window_ addSubview:[root_ view]];
  
  [window_ makeKeyAndVisible];
  
    // always call after makeKeyAndDisplay.
#ifdef TARGET_IPHONE_SIMULATOR
  [[DCIntrospect sharedIntrospector] start];
#endif
  
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  /*
   Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
   Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
   */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  /*
   Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
   If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
   */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  /*
   Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
   */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  /*
   Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
   */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  /*
   Called when the application is about to terminate.
   Save data if appropriate.
   See also applicationDidEnterBackground:.
   */
}

@end
