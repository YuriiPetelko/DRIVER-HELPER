//
//  FuelViewController.h
//  BMW_Client
//
//  Created by Yurii Petelko on 20.01.14.
//  Copyright (c) 2014 Yurii Petelko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FuelViewController : UIViewController
{
    UITableViewCell *fuelCell;
    NSArray * tableData;
    NSString * tankSpare;
    NSString * tankRange;
    NSString * coolantSpare;
    BOOL dataReceived;
    NSIndexPath * index;
    
}
@property (strong, nonatomic) IBOutlet UINavigationItem *navBarFuel;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *sideBar;
-(void)setTankSpare:(NSString *) level;
-(void)setTankRange:(NSString *) level;
-(void)setCoolantSpare:(NSString *) level;
@end
