//
//  suruga_homeAppDelegate.m
//  suruga_home
//
//  Created by Ted Tomlinson on 12/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "suruga_homeAppDelegate.h"
#import "StartUpViewController.h"
#import "FinancialAdviceViewController.h"
#import "TabBarController.h"

#import "HomeTableViewController.h"
#import "HomeMapViewController.h"
#import "FinancialHomeViewController.h"
 
@implementation suruga_homeAppDelegate

@synthesize window = _window;
@synthesize startUpViewController = _startUpViewController;
@synthesize tabBarController = _tabBarController;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}
#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"suruga" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
    return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil) {
		return __persistentStoreCoordinator;
	}
	NSURL *storeUrl = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"suruga.sqlite"];
    // Put down default db if it doesn't already exist
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:[storeUrl path]]) {
        NSString *defaultStorePath = [[NSBundle mainBundle] 
                                      pathForResource:@"suruga_en" ofType:@"sqlite"];
        if (defaultStorePath) {
            //[fileManager copyItemAtPath:defaultStorePath toPath:[storeUrl path] error:NULL];
        }
    }
    
	__persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
	
	NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
							 [NSNumber numberWithBool:YES],
							 NSMigratePersistentStoresAutomaticallyOption,
							 [NSNumber numberWithBool:YES],
							 NSInferMappingModelAutomaticallyOption, nil];
	NSError *error;
	if(![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {
		/*Error for store creation should be handled in here*/
	}
	
	return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Set up Three20 url navigation:
    TTNavigator *navigator = [TTNavigator navigator];
    [navigator setSupportsShakeToReload:YES];
    [navigator setPersistenceMode:TTNavigatorPersistenceModeAll];
    navigator.window = self.window;
    TTURLMap *map = navigator.URLMap;
    // A navigator will default to TTWebController class when no URL match will be met
    [map from:@"*" toViewController:[TTWebController class]];
    // My controller maps.
    // Tab Bar
    [map from:@"suruga://tabbar" toSharedViewController:[TabBarController class]];
    // Individual Tabs
    [map from:@"suruga://comparisonTab" toViewController:[HomeTableViewController class]];
    [map from:@"suruga://budgetTab" toViewController:[FinancialHomeViewController class]];
    [map from:@"suruga://mapTab" toViewController:[HomeMapViewController class]];
    [map from:@"suruga://guideTab" toViewController:[StartUpViewController class]];
    [map from:@"suruga://startUpView" toViewController:[StartUpViewController class]];
    [map from:@"suruga://FinancialAdviceViewController" toViewController:[FinancialAdviceViewController class]];
    
    // Add the tab bar controller's current view as a subview of the window
    UserData *ud = [UserData fetchUserDataWithContext:self.managedObjectContext];
    //[self.managedObjectContext deleteObject:ud];
    //[self.managedObjectContext save:nil];
    ud = [UserData fetchUserDataWithContext:self.managedObjectContext];
    if (ud == nil) {
        self.startUpViewController.userData = (UserData*) [NSEntityDescription insertNewObjectForEntityForName:@"UserData" inManagedObjectContext:self.managedObjectContext];
        //[navigator openURLAction:[TTURLAction actionWithURLPath:@"suruga://startUpView"]];
        self.window.rootViewController = self.startUpViewController;
    } else {
        // Try restoring
        if (! [navigator restoreViewControllers]) {
            [[TTNavigator navigator] openURLAction: [[TTURLAction actionWithURLPath:@"suruga://tabbar"] applyAnimated:YES]];
        }
        //self.window.rootViewController = self.tabBarController;
    }
    // Let us download large images
    [[TTURLRequestQueue mainQueue] setMaxContentLength:0];
    //make window visible.
    //[self.window makeKeyAndVisible];
    return YES;
}

- (BOOL)application:(UIApplication*)application handleOpenURL:(NSURL*)URL {
    TTOpenURL([URL absoluteString]);
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
    NSError *error;
    if (__managedObjectContext != nil) {
        if ([__managedObjectContext hasChanges] && ![__managedObjectContext save:&error]) {
            // Handle the error.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            exit(-1);  // Fail
        } 
    }
}

- (void)dealloc
{
    [_window release];
    [_tabBarController release];
    [_startUpViewController release];
    [super dealloc];
}

@end
