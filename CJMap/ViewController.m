//
//  ViewController.m
//  CJMap
//
//  Created by mac on 16/6/2.
//  Copyright © 2016年 Cijian.Wu. All rights reserved.
//

#import "ViewController.h"
#import "CustomView.h"

@interface ViewController ()<MKMapViewDelegate,CLLocationManagerDelegate>

@property(nonatomic,strong)MKMapView *mapView;

@property(nonatomic,assign)CLLocationCoordinate2D coor;

@property(nonatomic,strong)CLLocationManager *locationManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    
    //显示定位坐标
    _mapView.showsUserLocation = YES;
    
    _mapView.delegate = self;
    
    [_mapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(22.579911, 113.960739), MKCoordinateSpanMake(0.1, 0.1)) animated:YES];
    
    [self.view addSubview:_mapView];
    
    self.locationManager = [[CLLocationManager alloc] init];
    
    //精确度 越高  越耗电
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    //定位的频率  单位米
    self.locationManager.distanceFilter = 10;
    
    //设置代理
    self.locationManager.delegate = self;
    
    //ios8 以后设置访问定位的权限
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        //NSLocationAlwaysUsageDescription plist中加入该key
        [self.locationManager requestAlwaysAuthorization];
    }
    
    //开启定位
    [self.locationManager startUpdatingLocation];
    
    UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longClick:)];
    
    longpress.minimumPressDuration = 2.0f;
    [self.mapView addGestureRecognizer:longpress];
}

//定位完成后的代理方法
//location 定位完成的位置会放到最后一个元素中.
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)location
{
    CLLocation *newLocation = [location lastObject];
    
    //停止定位
    [self.locationManager stopUpdatingLocation];
    
    [self.mapView setRegion:MKCoordinateRegionMake(newLocation.coordinate, MKCoordinateSpanMake(0.05, 0.05)) animated:YES];
}
#pragma mark -
-(void)getAnnotation
{
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:_coor.latitude longitude:_coor.longitude];
    //设置地图的center,把点击的CGPoint移动屏幕中间
    [_mapView setRegion:MKCoordinateRegionMake(_coor, MKCoordinateSpanMake(0.05, 0.05)) animated:YES];
    //清除其他annotation
    [_mapView removeAnnotations:_mapView.annotations];
    //反向解析geocode坐标
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        CLPlacemark *placeMark = placemarks.lastObject;
        
        MKPointAnnotation *ann = [[MKPointAnnotation alloc] init];
        
        ann.title = placeMark.name;
        ann.subtitle = [placeMark.locality stringByAppendingString:placeMark.subLocality];
        ann.coordinate = _coor;
        [_mapView addAnnotation:ann];
        
    }];
}
#pragma mark - 设置annotation
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKPointAnnotation class]]) {
        MKPinAnnotationView *view = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"anno"];
        if (view == nil) {
            
            view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"anno"];
        }
        
        view.pinTintColor = [UIColor blueColor];
        
        view.animatesDrop = NO;
        
        view.canShowCallout = YES;
        return view;
        
    }
    return nil;
}

-(void)longClick:(UILongPressGestureRecognizer *)longpress
{
    longpress.enabled = NO;
    
    CGPoint p = [longpress locationInView:self.mapView];
    //CGPoint 转 CLLocationCoordinate2D
    _coor = [self.mapView convertPoint:p toCoordinateFromView:self.mapView];
    [self getAnnotation];
    
    longpress.enabled  = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
