//
//  AppDelegate.m
//  WeiXinProject
//
//  Created by 徐丽 on 17/4/26.
//  Copyright © 2017年 徐丽. All rights reserved.
//

#import "AppDelegate.h"
#import "XLFinderViewController.h"
#import "XLMainViewController.h"
#import "XLMessageViewController.h"
#import "XLAddressListViewController.h"
#import "XLMineViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    XLFinderViewController *finderVc = [[XLFinderViewController alloc]init];
    UINavigationController *finderNav = [[UINavigationController alloc]initWithRootViewController:finderVc];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:tintGreenColor,NSForegroundColorAttributeName, nil]forState:UIControlStateSelected];
    finderNav.tabBarItem.title = @"发现";
    finderNav.tabBarItem.image = [[UIImage imageNamed:@"tabbar_discover"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    finderNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_discoverHL"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    XLMessageViewController *messageVc = [[XLMessageViewController alloc]init];
    UINavigationController *messageNav = [[UINavigationController alloc]initWithRootViewController:messageVc];
    messageNav.tabBarItem.title = @"消息";
    messageNav.tabBarItem.image = [[UIImage imageNamed:@"tabbar_mainframe"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    messageNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_mainframeHL"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    XLMineViewController *mineVc = [[XLMineViewController alloc]init];
    UINavigationController *mineNav = [[UINavigationController alloc]initWithRootViewController:mineVc];
    mineNav.tabBarItem.title = @"我的";
    mineNav.tabBarItem.image = [[UIImage imageNamed:@"tabbar_me"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mineNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_meHL"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    XLAddressListViewController *addressListVc = [[XLAddressListViewController alloc]init];
    UINavigationController *addressNav = [[UINavigationController alloc]initWithRootViewController:addressListVc];
    addressNav.tabBarItem.title = @"通讯录";
    addressNav.tabBarItem.image = [[UIImage imageNamed:@"tabbar_contacts"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    addressNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_contactsHL"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    XLMainViewController *mainTabbarVc = [[XLMainViewController alloc]init];
    [mainTabbarVc addChildViewController:messageNav];
    [mainTabbarVc addChildViewController:addressNav];
    [mainTabbarVc addChildViewController:finderNav];
    [mainTabbarVc addChildViewController:mineNav];
    self.window.rootViewController = mainTabbarVc;
    [self.window makeKeyAndVisible];
   
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"WeiXinProject"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
