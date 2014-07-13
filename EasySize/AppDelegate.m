//
//  AppDelegate.m
//  EasySize
//
//  Created by User on 25.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "MasterViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import "Consts.h"

#define LOCALYTICS_KEY @"00fb78a21902e83de0fdc6a-88ab17d4-581c-11e2-3908-004b50a28849"
//test key
//#define LOCALYTICS_KEY @"d8722b8bedd61a7d9f9f6a3-414e236c-5827-11e2-3909-004b50a28849"


@implementation AppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;
@synthesize imagePickerControllerIsActive;
@synthesize rateController;
@synthesize backgroundView;



- (void)dealloc
{
    [_window release];
    [_navigationController release];
    [rateController release];
    [backgroundView release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Localytics
    [[LocalyticsSession shared] startSession:LOCALYTICS_KEY];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:self.window.frame];
    self.backgroundView = bgView;
    [bgView release];
    [self.window addSubview:self.backgroundView];
    // Override point for customization after application launch.
    MasterViewController *masterViewController = [[[MasterViewController alloc] initWithNibName:@"RootView" bundle:nil] autorelease];
    self.navigationController = [[[UINavigationController alloc] initWithRootViewController:masterViewController] autorelease];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navBar"] forBarMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                  [UIColor whiteColor], UITextAttributeTextColor,
                                  [UIFont fontWithName:NAV_BAR_FONT size:NAV_BAR_FONT_SIZE], UITextAttributeFont, nil]];
                                                           
    
    
    [[UIBarButtonItem appearance] setTintColor:[UIColor colorWithRed:0.5961f green:0.4196f blue:0.6745f alpha:1.0f]];
    [[UISegmentedControl appearance] setTintColor:[UIColor colorWithRed:0.5961f green:0.4196f blue:0.6745f alpha:1.0f]];
    [[UISlider appearance] setMinimumTrackTintColor:[UIColor colorWithRed:0.5961f green:0.4196f blue:0.6745f alpha:1.0f]];
    [[UISlider appearance] setMaximumTrackTintColor:[UIColor darkGrayColor]];
    
    
    [[UISegmentedControl appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys: [UIColor whiteColor], UITextAttributeTextColor,  [UIFont fontWithName:SEGMENTED_CONTROL_FONT size:SEGMENTED_CONTROL_FONT_SIZE], UITextAttributeFont, nil] forState:UIControlStateNormal];
    
    [[UISegmentedControl appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys: [UIColor colorWithRed:0.8431f green:0.5804f blue:0.9451f alpha:1.0f], UITextAttributeTextColor, [UIFont fontWithName:SEGMENTED_CONTROL_FONT size:SEGMENTED_CONTROL_FONT_SIZE], UITextAttributeFont, nil] forState:UIControlStateSelected];
    

    
    //[[UIBarButtonItem appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:BAR_BUTTON_FONT size:BAR_BUTTON_FONT_SIZE], UITextAttributeFont, [UIColor lightGrayColor], UITextAttributeTextColor, nil] forState:UIControlStateNormal];
    
    
    //[[UIBarButtonItem appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:BAR_BUTTON_FONT size:BAR_BUTTON_FONT_SIZE], UITextAttributeFont, [UIColor colorWithRed:0.8431f green:0.5804f blue:0.9451f alpha:1.0f], UITextAttributeTextColor, nil] forState:UIControlStateHighlighted];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                  [UIColor whiteColor], UITextAttributeTextColor, nil] forState:UIControlStateNormal];
    
    
    [[UIBarButtonItem appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                  [UIColor colorWithRed:0.8431f green:0.5804f blue:0.9451f alpha:1.0f], UITextAttributeTextColor, nil] forState:UIControlStateHighlighted];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    //addMob
    //[self performSelectorInBackground:@selector(reportAppOpenToAdMob) withObject:nil];
    
    //[[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    return YES;
     
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    [[LocalyticsSession shared] close];
    [[LocalyticsSession shared] upload];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    // if image picker controller is active don't pop to root controller
    //190213 - not the best way for user experience
    //if (!imagePickerControllerIsActive){
        //[self.navigationController popToRootViewControllerAnimated:NO];
    //}
    
    //Localytics
    [[LocalyticsSession shared] close];
    [[LocalyticsSession shared] upload];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    //Localytics
    [[LocalyticsSession shared] resume];
    [[LocalyticsSession shared] upload];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //when app become active, counter of enters in app increase on 1
    //when it will be equal NUMBER_OF_APP_LAUNCHES_TO_SHOW_RATE_POPUP, rate popup will be shown
    if ([[NSUserDefaults standardUserDefaults] objectForKey:NUMBER_OF_APP_LAUNCHES_FOR_RATE_POPUP]){
        
        NSInteger num = [[[NSUserDefaults standardUserDefaults] objectForKey:NUMBER_OF_APP_LAUNCHES_FOR_RATE_POPUP] integerValue];
        if (num != NUMBER_OF_APP_LAUNCHES_TO_SHOW_RATE_POPUP){
                    
            num = num + 1;
            //NSLog(@"%d",num);
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:num] forKey:NUMBER_OF_APP_LAUNCHES_FOR_RATE_POPUP];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        else{
            rateController = [[RateViewController alloc] initWithNibName:@"RateView" bundle:nil] ;
            //[[rateController view] setCenter:self.window.center];
            [[rateController view] setCenter:CGPointMake(self.window.center.x+[[rateController view] frame].size.width, self.window.center.y)];
            [[self window] addSubview:[rateController view]];
            
            
            [UIView animateWithDuration:1.0f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                [[rateController view] setAlpha:1.0f];
                [[rateController view] setCenter:self.window.center];
            }
                             completion:^(BOOL finished) {
                                 //
                             }];

            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0] forKey:NUMBER_OF_APP_LAUNCHES_FOR_RATE_POPUP];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
            
    }
    else{
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:NUMBER_OF_APP_LAUNCHES_FOR_RATE_POPUP];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [[LocalyticsSession shared] resume];
    [[LocalyticsSession shared] upload];    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    //Localytics
    [[LocalyticsSession shared] close];
    [[LocalyticsSession shared] upload];
}

/*
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
	//NSLog(@"My token is: %@", deviceToken);
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	//NSLog(@"Failed to get token, error: %@", error);
}
 */
/*
- (void) onPushAccepted:(PushNotificationManager *)pushManager withNotification:(NSDictionary *)pushNotification {
    //NSLog(@"Push notification received");
}
*/
#pragma mark - help functions
//add mob
/*
- (NSString *)hashedISU {
    
    NSString *result = nil;
    NSString *isu = [UIDevice currentDevice].uniqueIdentifier;
    //NSLog(@"%@", isu);
    
    if(isu) {
        unsigned char digest[16];
        NSData *data = [isu dataUsingEncoding:NSASCIIStringEncoding];
        CC_MD5([data bytes], [data length], digest);
        
        result = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                  digest[0], digest[1],
                  digest[2], digest[3],
                  digest[4], digest[5],
                  digest[6], digest[7],
                  digest[8], digest[9],
                  digest[10], digest[11],
                  digest[12], digest[13],
                  digest[14], digest[15]];
        result = [result uppercaseString];
    }
    return result;
}

- (void)reportAppOpenToAdMob {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init]; // we're in a new thread here, so we need our own autorelease pool
    // Have we already reported an app open?
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                        NSUserDomainMask, YES) objectAtIndex:0];
    NSString *appOpenPath = [documentsDirectory stringByAppendingPathComponent:@"admob_app_open"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:appOpenPath]) {
        // Not yet reported -- report now
        NSString *appOpenEndpoint = [NSString stringWithFormat:@"http://a.admob.com/f0?isu=%@&md5=1&app_id=%@",
                                     [self hashedISU], @"547895474"];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:appOpenEndpoint]];
        NSURLResponse *response;
        NSError *error = nil;
        
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        if((!error) && ([(NSHTTPURLResponse *)response statusCode] == 200) && ([responseData length] > 0)) {
            [fileManager createFileAtPath:appOpenPath contents:nil attributes:nil]; // successful report, mark it as such
            //NSLog(@"App download successfully reported.");
        } else {
            //NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            //NSLog(@"WARNING: App download not successfully reported. %@", responseString);
            //[responseString release];
        }
    }
    [pool release];
}
 */

@end
