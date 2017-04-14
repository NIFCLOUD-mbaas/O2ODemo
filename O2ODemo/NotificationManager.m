/*
 Copyright 2017 FUJITSU CLOUD TECHNOLOGIES LIMITED All Rights Reserved.
 
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

@interface NotificationManager()

//CLLocationManagerクラスのプロパティを作成

@end

@implementation NotificationManager

-(instancetype)init{
    
    //CLLocationManagerのインスタンスを作成
    
    //位置情報を使用する許可画面を表示
    
    return self;
}

- (void)searchLocations:(NSString*)locationId block:(void (^)(NSError *error))blk{
    
    //LocationクラスのNCMBObjectを作成

    //店舗情報のIDを設定

    //設定されたIDをもとにクラウドからデータを取得

}

- (void)updateLocation:(NCMBGeoPoint*)geoPoint block:(void (^)(NSError *error))blk{
    
    //以前に登録されたNotificationをキャンセル

    //再設定用のNotificationを作成

    //CLCircularRegionの変数を用意
    
    //regionに設定するCLLocationCoordinate2Dを作成

    //CLLocationCoordinate2Dが有効な値かを確認
    if (CLLocationCoordinate2DIsValid(location)){
        
        //リージョン作成(中心点、そこからの半径、regionの識別子を設定)
        
        //リージョンから外に出た場合には通知が行われないようにNOを設定
        
        //リージョンを設定してLocation Notificationを登録
        
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
