/*
 Copyright 2020 FUJITSU CLOUD TECHNOLOGIES LIMITED All Rights Reserved.
 
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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//NIFCLOUD mobile backendのSDKをインポート
#import <NCMB/NCMB.h>

//CLLocationManagerDelegateの宣言を行う
@interface NotificationManager : NSObject<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *mLocationManager;

//与えられた店舗のIDをもとにクラウドから店舗情報を取得し、updateLocationを呼び出す
- (void)searchLocations:(NSString*)locationId block:(void (^)(NSError *error))blk;
//与えられた位置情報をもとにLocation Notificationを再設定する
- (void)updateLocation:(NCMBGeoPoint*)geoPoint block:(void (^)(NSError *error))blk;
@end
