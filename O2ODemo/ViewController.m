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

#import "ViewController.h"

//NotificatonManagerをインポート
#import "NotificationManager.h"

@interface ViewController ()
- (IBAction)updateLocationNotification:(id)sender;

@end

//static変数を追加
static NotificationManager *manager = nil;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //static変数にNotificationManagerのインスタンスを代入
    manager = [[NotificationManager alloc] init];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)updateLocationNotification:(id)sender {
    
    //NotificatonManagerの店舗情報取得メソッドを呼び出す
    [manager searchLocations:@"LOCATION_ID" block:^(NSError *error) {
        if (error){
            NSLog(@"error:%@",error);
        }
    }];
}

@end
