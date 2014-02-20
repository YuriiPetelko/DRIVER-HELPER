//
//  TableOptionsViewController.h
//  BMW_Client
//
//  Created by Yurii Petelko on 17.01.14.
//  Copyright (c) 2014 Yurii Petelko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ConnectionModel.h"
#import "FuelViewController.h"
#import <sys/socket.h>
#import <arpa/inet.h>
#import <netinet/in.h>

typedef unsigned char uint8;
struct temperature{
    uint8 otdoor;
    uint8 inside;
    uint8 engine;
};

struct tankOpt{
    uint8 tankRange;
    uint8 coolantSpare;
    uint8 levelTankSpare;
};

struct dataOpt{
    struct temperature temp;
    struct tankOpt tank;
    uint8 milleage;
};
@interface TableOptionsViewController : UITableViewController
{
    ConnectionModel * model;
    struct dataOpt data;
    FuelViewController * fuel;
    struct sockaddr_in serv_addr;
    int sockfd;
}
@property (nonatomic, strong) NSArray * tableData;
@property(nonatomic,retain) CLLocationManager *locationManager;

@end
