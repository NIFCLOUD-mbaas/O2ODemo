/*webview-panel:webview-panel/webview-f6ea6b5e-6151-4f82-87a7-0d5de8aa22dd
 Copyright 2019 FUJITSU CLOUD TECHNOLOGIES LIMITED All Rights Reserved.
 
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
//ニフティクラウド mobile backendのSDKをインポート
#import <NCMB/NCMB.h>

#import "NotificationManager.h"

@interface AppDelegate ()

@end

static NotificationManager *manager = nil;

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //SDKの初期化
    [NCMB setApplicationKey:@"0730e01abce99ac3d5400690cb658a25f79e8f0bac8895dd67283e9b98077d1e"
                  clientKey:@"d4175a28a524d55c47057f6f77b47c0c654842521b94488442867c82deb83dac"];
    
    //プッシュ通知の許可画面を表示させる
    UIUserNotificationType types = UIUserNotificationTypeBadge |
                                   UIUserNotificationTypeSound |
                                   UIUserNotificationTypeAlert;
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    manager = [[NotificationManager alloc] init];
    
    return YES;
}

//デバイストークンがAPNsから発行された時に呼び出されるデリゲートメソッド


//APNsから配信されたプッシュ通知を受信した時に呼び出されるデリゲートメソッド
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    //ペイロードから位置情報を保持しているデータのobjectIdを取得
    NSString *locationId = nil;
    locationId = [userInfo objectForKey:@"locationId"];

    if (locationId){
        //このあとここに処理を書いていきます
        [manager searchLocations:locationId block:^(NSError *error) {
            if (error){
                NSLog(@"error:%@",error);
            }
            completionHandler(UIBackgroundFetchResultNewData);
        }];
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NCMBInstallation *installation = [NCMBInstallation currentInstallation];

    //デバイストークンをセット
    [installation setDeviceTokenFromData:deviceToken];

    //ニフクラ mobile  backendのデータストアに登録
    [installation saveInBackgroundWithBlock:^(NSError *error) {
        if(!error){
            //端末情報の登録が成功した場合の処理
        } else {
            //端末情報の登録が失敗した場合の処理
        }
    }];
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
