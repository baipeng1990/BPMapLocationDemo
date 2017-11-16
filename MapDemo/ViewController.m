//
//  ViewController.m
//  MapDemo
//
//  Created by shese on 2017/11/16.
//  Copyright © 2017年 baipeng. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<CLLocationManagerDelegate>

{
    NSString * currentCity; //当前城市
}

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (weak, nonatomic) IBOutlet UILabel *coordinate;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationManager= [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    //        [locationManager requestAlwaysAuthorization];
    [_locationManager requestWhenInUseAuthorization];
    currentCity = [[NSString alloc] init];

    
}

- (IBAction)dingwei:(UIButton *)sender {
    
    [self locate];
    //[self findMe];
    [_activityView startAnimating];
}




- (void)locate {
    //判断定位功能是否打开
    if ([CLLocationManager locationServicesEnabled]) {

        NSLog(@"开始定位");

        [self.locationManager startUpdatingLocation];
    }

    else{
        UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"允许\"定位\"提示" message:@"请在设置中打开定位" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * ok = [UIAlertAction actionWithTitle:@"打开定位" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //打开定位设置
            NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [[UIApplication sharedApplication] openURL:settingsURL];
        }];
        UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

        }];
        [alertVC addAction:cancel];
        [alertVC addAction:ok];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
    

    
}



#pragma mark - CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    
    NSLog(@"------------");
    [_activityView stopAnimating];
    //1.获取用户位置的对象
    CLLocation *currentLocation = [locations lastObject];
    CLLocationCoordinate2D coordinate = currentLocation.coordinate;
    NSLog(@"纬度%f 经度%f",coordinate.latitude,coordinate.longitude);
    
    _coordinate.text = [NSString stringWithFormat:@"纬度%f 经度%f",coordinate.latitude,coordinate.longitude];
    
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    //反编码
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark *placeMark = placemarks[0];
            currentCity = placeMark.locality;
            if (!currentCity) {
                currentCity = @"无法定位当前城市";
            }
            //NSLog(@"%@",currentCity); //这就是当前的城市
            //NSLog(@"%@",placeMark.name);//具体地址:  xx市xx区xx街道
            
            _cityLabel.text = currentCity;
            _placeLabel.text = placeMark.name;
            
        }
        else if (error == nil && placemarks.count == 0) {
            NSLog(@"No location and error return");
        }
        else if (error) {
            NSLog(@"location error: %@ ",error);
        }
        
    }];
    

    
    [manager stopUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(nonnull NSError *)error{


    
    NSLog(@"error --%ld",(long)error.code);
    
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"允许\"定位\"提示" message:@"请在设置中打开定位" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * ok = [UIAlertAction actionWithTitle:@"打开定位" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //打开定位设置
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:settingsURL];
    }];
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVC addAction:cancel];
    [alertVC addAction:ok];
    [self presentViewController:alertVC animated:YES completion:nil];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
