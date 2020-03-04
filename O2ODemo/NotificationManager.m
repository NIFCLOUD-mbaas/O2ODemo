/*
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

#import "NotificationManager.h"
#import <UserNotifications/UserNotifications.h>
#define OS_10_0_0_OR_NEWER [[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){10, 0, 0}]


@interface NotificationManager()

//CLLocationManagerクラスのプロパティを作成

@end

@implementation NotificationManager

-(instancetype)init{
    
    //CLLocationManagerのインスタンスを作成
    self = [super init];
    self.mLocationManager = [[CLLocationManager alloc] init];
    self.mLocationManager.delegate = self;
    
    //位置情報を使用する許可画面を表示
    [self.mLocationManager requestWhenInUseAuthorization];
    
    return self;
}

- (void)searchLocations:(NSString*)locationId block:(void (^)(NSError *error))blk{
    
    //LocationクラスのNCMBObjectを作成
    NCMBObject *location = [NCMBObject objectWithClassName:@"Location"];
    
    //店舗情報のIDを設定
    location.objectId = locationId;
    
    //設定されたIDをもとにクラウドからデータを取得
    [location fetchInBackgroundWithBlock:^(NSError *localError) {
        if (localError){
            blk(localError);
        } else {
            
            //このあとここに処理を書いていきます
            NCMBGeoPoint *point = [location objectForKey:@"geo"];
            [self updateLocation:point block:^(NSError *error) {
                if (error){
                    blk(error);
                } else {
                    blk(nil);
                }
            }];
        }
    }];
    
}

- (void)updateLocation:(NCMBGeoPoint*)geoPoint block:(void (^)(NSError *error))blk{
    
    //以前に登録されたNotificationをキャンセル
    //再設定用のNotificationを作成
    
    //CLCircularRegionの変数を用意
    CLCircularRegion *region = nil;
    //regionに設定するCLLocationCoordinate2Dを作成
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(geoPoint.latitude,
                                                                 geoPoint.longitude);
    
    //CLLocationCoordinate2Dが有効な値かを確認
    if (CLLocationCoordinate2DIsValid(location)){
        
        //リージョン作成(中心点、そこからの半径、regionの識別子を設定)
        region = [[CLCircularRegion alloc] initWithCenter:location
                                                   radius:50.0
                                               identifier:@"salePoint"];
        region.notifyOnEntry = YES;
        
        //リージョンを設定してLocation Notificationを登録
        if (OS_10_0_0_OR_NEWER){
            UNMutableNotificationContent *content = [UNMutableNotificationContent new];
            content.body = [NSString stringWithFormat:@"近くでセール開催中！"];
            content.sound = [UNNotificationSound defaultSound];
            content.badge = [NSNumber numberWithInteger:1];
            UNLocationNotificationTrigger *trigger = [UNLocationNotificationTrigger triggerWithRegion:region repeats:YES];
            UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"NotificationIdentifier" content:content trigger:trigger];
            
            UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
            UNAuthorizationOptions options = UNAuthorizationOptionAlert + UNAuthorizationOptionSound + UNAuthorizationOptionAlert;
            [center requestAuthorizationWithOptions:options
                                  completionHandler:^(BOOL granted, NSError * _Nullable error) {
                if (!error) {
                    NSLog(@"request authorization succeeded!");
                } else {
                    NSLog(@"request authorization fail!");
                }
            }];
            [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                if (!error) {
                    NSLog(@"Local Notification succeeded");
                }
                else {
                    NSLog(@"Local Notification failed");
                }
            }];
        } else {
            UILocalNotification *localNotif = [[UILocalNotification alloc] init];
            if (localNotif == nil)
                return;
            localNotif.alertBody = [NSString stringWithFormat:@"近くでセール開催中！"];
            localNotif.soundName = UILocalNotificationDefaultSoundName;
            localNotif.applicationIconBadgeNumber = 1;
            localNotif.region = region;
            localNotif.regionTriggersOnce = YES;
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
        }
        
        //コールバックを実行
        blk(nil);
    } else {
        NSDictionary *info = @{NSLocalizedDescriptionKey:@"Invalid coordinate info."};
        NSError *error = [NSError errorWithDomain:@"InvalidCLLocationError"
                                             code:1999
                                         userInfo:info];
        //コールバックを実行
        blk(error);
    }
}

@end
