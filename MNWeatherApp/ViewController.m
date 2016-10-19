//
//  ViewController.m
//  MNWeatherApp
//
//  Created by Mrunalini on 17/10/16.
//  Copyright © 2016 Mrunalini Nemade. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self startLocating];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)startLocating {
    
    locationManager = [[CLLocationManager alloc]init];
    locationManager.delegate = self;
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];
    
}

-(void)getUserLocation {
    [locationManager startUpdatingLocation];
}


-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    CLLocation *currentLocation = [locations lastObject];
    
    
    NSLog(@"Latitude : %f",currentLocation.coordinate.latitude);
    
    NSLog(@"Longitude : %f",currentLocation.coordinate.longitude);
    
     kLatitude= [NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude];
    
    kLongitude = [NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];

    
    if (currentLocation != nil) {
        [locationManager stopUpdatingLocation];
    }
    

    
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    NSLog(@"%@",error.localizedDescription);
}
-(void)getCurrentWeatherDataWithLatitude:(double) latitude
                               longitude:(double) longitude
                                  APIKey:(NSString *)key {
    
    
    NSString *urlString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&appid=%@&units=metric",latitude,longitude,key];
    
    NSLog(@"%@",urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLSession *mySession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionDataTask *task = [mySession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            //alert
        }
        else {
            if (response) {
                
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                
                if (httpResponse.statusCode == 200) {
                    
                    if (data) {
                        //start json parsing
                        
                        
                        NSError *error;
                        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                        
                        if (error) {
                            //alert
                        }
                        else{
                            
                            [self performSelectorOnMainThread:@selector(updateUI:) withObject:jsonDictionary waitUntilDone:NO];
                        }
                    }
                    else {
                        //alert
                    }
                }
                else {
                    //alert
                }
            }
            else {
                //alert
            }
        }
    }];
    
    [task resume];
    
}

-(void)updateUI:(NSDictionary *)resultDictionary {
    
    NSLog(@"%@",resultDictionary);
    
    
    
    NSString *temperature = [NSString stringWithFormat:@"%@",[resultDictionary valueForKeyPath:@"main.temp"]];
    
    NSLog(@"\n\nTEMPERATURE BEFORE : %@",temperature);
    
    int temp = temperature.intValue;
    
    temperature = [NSString stringWithFormat:@"%d °C",temp];
    
    
    NSLog(@"\n\nTEMPERATURE AFTER: %@",temperature);
    
    NSArray *weather = [resultDictionary valueForKey:@"weather"];
    
    NSLog(@"%@",weather);
    
    NSDictionary *weatherDictionary = weather.firstObject;
    
    
    
    NSString *condition = [NSString stringWithFormat:@"%@",[weatherDictionary valueForKey:@"description"]];
    
    NSLog(@"%@",condition);
    
    
    NSString *city = [NSString stringWithFormat:@"%@",[resultDictionary valueForKey:@"name"]];
    
    
    self.labelCity.text = city;
    self.labelCondition.text = condition.capitalizedString;
    self.labelTempurature.text = temperature;
    
    
}

- (IBAction)getWeatherAction:(id)sender {
    [locationManager startUpdatingLocation];
    [self getCurrentWeatherDataWithLatitude:kLatitude.intValue longitude:kLongitude.intValue APIKey:kWeatherAPIKey];
}
@end
