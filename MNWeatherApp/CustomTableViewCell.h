//
//  CustomTableViewCell.h
//  MNWeatherApp
//
//  Created by Mrunalini on 20/10/16.
//  Copyright © 2016 Mrunalini Nemade. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelDays;

@property (weak, nonatomic) IBOutlet UILabel *labelMaxTempurature;

@property (weak, nonatomic) IBOutlet UILabel *labelMinTempurature;

@end
