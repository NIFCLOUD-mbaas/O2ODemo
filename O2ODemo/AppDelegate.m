/*
 Copyright 2014 NIFTY Corporation All Rights Reserved.
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import "AppDelegate.h"
#import <NCMB/NCMB.h>

#import "NotificationManager.h"

@interface AppDelegate ()

@end

static NotificationManager *manager = nil;

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //SDKの初期化
    [NCMB setApplicationKey:@"YOUR_APP_KEY"
                  clientKey:@"YOUR_CLIENT_KEY"];
    
    //プッシュ通知の許可画面を表示させる
    UIUserNotificationType types = UIUserNotificationTypeBadge |
    UIUserNotificationTypeSound |
    UIUserNotificationTypeAlert;
    UIUserNotificationSettings *mySettings =
    [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    //リモートプッシュ通知を受信するためのdeviceTokenを要求
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    //application:didFinishLaunchingWithOptions:のreturn文前に追加
    manager = [[NotificationManager alloc] init];
    
    return YES;
}

-(void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    //NCMBInstallation作成
    NCMBInstallation *installation = [NCMBInstallation currentInstallation];
    //デバイストークンをセット
    [installation setDeviceTokenFromData:deviceToken];
    //ニフティクラウド mobile  backendのデータストアに登録
    [installation saveInBackgroundWithBlock:^(NSError *error) {
        if(!error){
            //端末情報の登録が成功した場合の処理
        } else {
            //端末情報の登録が失敗した場合の処理
        }
    }];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    //ペイロードからセール店舗のIDを取得
    NSString *locationId = nil;
    locationId = [userInfo objectForKey:@"locationId"];
    if (locationId){
        //Locaton Notificationの設定
        [manager searchLocations:locationId block:^(NSError *error) {
            if (error){
                NSLog(@"error:%@",error);
            }
            completionHandler(UIBackgroundFetchResultNewData);
        }];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
