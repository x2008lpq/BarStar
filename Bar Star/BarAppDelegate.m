//  Created by Newline Analutics Inc. on 01/08/13.
//  Copyright (c) 2013 Connor Curran. All rights reserved.

#import "BarAppDelegate.h"
#import "BarSplashViewController.h"
#import "BarListViewController.h"





@interface BarAppDelegate ()


@end
@implementation BarAppDelegate



@synthesize mainNc;
@synthesize viewController = _viewController;
@synthesize window = _window;
@synthesize session = _session;

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:self.session];
    //  fallbackHandler:^(FBAppCall *call) {
    //     NSLog(@"In fallback handler");
    // }];
}




- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UIWindow *tempWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] ;
    self.window = tempWindow;
    [tempWindow release];
    
    [BarUtility InitializeScreen];
    
    // Override point for customization after application launch.
    BarSplashViewController *splashVc = [[BarSplashViewController alloc] init];
    self.viewController =splashVc;
    [splashVc release];
    
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}


-(void) initializeNavigationController
{
    BarListViewController *barListVc = [[BarListViewController alloc]init];
    
    
    UINavigationController *navC = [[UINavigationController alloc]initWithRootViewController:barListVc];
    self.mainNc = navC;
    [navC release];
    [barListVc release];
    
    mainNc.navigationBar.backgroundColor = [UIColor blackColor];
    
     self.window.rootViewController = self.mainNc;
    
    
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    [FBAppCall handleDidBecomeActiveWithSession:self.session];
    
    // [FBAppCall handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
    
    [FBSession.activeSession close];
    
}

@end