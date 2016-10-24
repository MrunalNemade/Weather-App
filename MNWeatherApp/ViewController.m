//
//  ViewController.m
//  MNWeatherApp
//
//  Created by Mrunalini on 17/10/16.
//  Copyright © 2016 Mrunalini Nemade. All rights reserved.
//

#import "ViewController.h"
#import "CustomTableViewCell.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    forcast = [[NSMutableArray alloc]init];
    
    //days = @[@"Sun",@"Mon",@"Tue",@"Wed",@"Thu",@"Fri",@"Sat"];
    
    //[self startLocating];
    
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
    
    [self getCurrentWeatherDataWithLatitude:kLatitude.doubleValue longitude:kLongitude.doubleValue APIKey:kWeatherAPIKey];
    
    [self getForcastDataWithLatitude:kLatitude.doubleValue longitude:kLongitude.doubleValue APIKey:kWeatherAPIKey];


    
    if (currentLocation != nil) {
        [locationManager stopUpdatingLocation];
    }
    

    
}


-(void)updateUIWithForcastDictionary:(NSDictionary *)forcastDictionary {
    
    // NSLog(@"%@",resultDictionary);
    
    NSArray *list = [forcastDictionary valueForKey:@"list"];
    
    for(NSDictionary *weatherDetail in list) {
        
        NSString *dt = [NSString stringWithFormat:@"%@",[weatherDetail valueForKeyPath:@"dt"]];
        NSString *max = [NSString stringWithFormat:@"%@",[weatherDetail valueForKeyPath:@"temp.max"]];
        max = [NSString stringWithFormat:@"MAX : %d °C",max.intValue];
        NSString *min = [NSString stringWithFormat:@"%@",[weatherDetail valueForKeyPath:@"temp.min"]];
        min = [NSString stringWithFormat:@"MIN : %d °C",min.intValue];
        
        NSDictionary *tempDictionary = @{
                                         @"max" : max,
                                         @"min" : min,
                                         @"dt" : dt
                                         };
        
        
        NSLog(@"%@",tempDictionary);
        [forcast addObject:tempDictionary];
        
        
    }
    
    if (forcast.count >0) {
        [self.tableView reloadData];
    }
}


-(void)getForcastDataWithLatitude:(double) latitude
                               longitude:(double) longitude
                                APIKey:(NSString *)key {


    NSString *urlString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast/daily?lat=%f&lon=%f&cnt=7&mode=json&appid=%@",latitude,longitude,key];

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
                        
                        [self performSelectorOnMainThread:@selector(updateUIWithForcastDictionary:) withObject:jsonDictionary waitUntilDone:NO];
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
   
    [self startLocating];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return 7;
    return forcast.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    
    NSDictionary *tempDictionary = [forcast objectAtIndex:indexPath.row];
    
    [tableView setSeparatorColor:[UIColor clearColor]];
    
    NSString *dt = [tempDictionary valueForKey:@"dt"];
    
    NSLog(@"%@",dt);
    
    NSTimeInterval time = dt.doubleValue;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    
    NSLog(@"%@",date);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    [dateFormatter setDateFormat:@"dd MMM yyyy HH:mm a Z EEEE"];
    
    NSString *day = [dateFormatter stringFromDate:date];
    
    NSLog(@"%@",day);
    
    cell.textLabel.text = day;
    cell.detailTextLabel.text = [[[tempDictionary valueForKey:@"max"]stringByAppendingString:@" "]stringByAppendingString:[tempDictionary valueForKey:@"min"]];
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return tableView.frame.size.height/7;
}

@end
