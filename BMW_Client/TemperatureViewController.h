//
//  TemperatureViewController.h
//  BMW_Client
//
//  Created by Yurii Petelko on 21.01.14.
//  Copyright (c) 2014 Yurii Petelko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TemperatureViewController : UIViewController
{
    NSArray * tableData;
    NSString * engTempl;
    NSString * outdoorTemp;
}
@property (strong, nonatomic) IBOutlet UIBarButtonItem *sideBar;
-(void)setEngTemp:(NSString *) temp;
-(void)setOutdoorTemp:(NSString *) temp;
@end
