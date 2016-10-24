//
//  ViewController.h
//  MNWeatherApp
//
//  Created by Mrunalini on 17/10/16.
//  Copyright © 2016 Mrunalini Nemade. All rights reserved.
//


#define kWeatherAPIKey @"5db0671fa48f3e642ddea4d8910bd3cb"

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController<CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    CLLocationManager *locationManager;
    NSString *kLatitude;
    NSString *kLongitude;
    
    NSMutableArray *forcast;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;



@property (weak, nonatomic) IBOutlet UILabel *labelCity;

@property (weak, nonatomic) IBOutlet UILabel *labelTempurature;

@property (weak, nonatomic) IBOutlet UILabel *labelCondition;

- (IBAction)getWeatherAction:(id)sender;

@end

