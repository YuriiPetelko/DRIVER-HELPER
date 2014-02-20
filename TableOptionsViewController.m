//
//  TableOptionsViewController.m
//  BMW_Client
//
//  Created by Yurii Petelko on 17.01.14.
//  Copyright (c) 2014 Yurii Petelko. All rights reserved.
//

#import "TableOptionsViewController.h"
#import "MileageViewController.h"
#import "TemperatureViewController.h"
#import <sys/socket.h>
#import <arpa/inet.h>
#import <netinet/in.h>


@interface TableOptionsViewController ()

@end

@implementation TableOptionsViewController

@synthesize tableData = _tableData;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    fuel = [[FuelViewController alloc] init];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //_tableData = [NSArray arrayWithObjects:@"Fluel", @"Mileage", @"Temperature", nil];
    //[self.model coneectToBMW];
    /*[fuel setTankRange:[NSString stringWithFormat:@"%d",data.tank.tankRange]];*/
    //NSLog([NSString stringWithFormat:@"%d",data.tank.tankRange]);
}

-(void)coneectToBMW
{
    int portno, n , opt = 1;
    //struct sockaddr_in serv_addr;
    //struct hostent *server;
    
    
    printf("call\n");
    /* Create a socket point */
    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd < 0)
    {
        perror("ERROR opening socket");
        exit(1);
    }
    
    bzero((char *) &serv_addr, sizeof(serv_addr));
    serv_addr.sin_family = AF_INET;
    
    serv_addr.sin_addr.s_addr = inet_addr("172.16.222.1");
    serv_addr.sin_port = htons(67);
    
    /* Now connect to the server */
    if (connect(sockfd,(struct sockaddr*)&serv_addr,sizeof(serv_addr)) < 0)
    {
        perror("ERROR connecting");
        char * error = strerror(errno);
        NSString * err = [NSString stringWithFormat:@"%s", error];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection failed!"
                                                        message:err
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        
        [alert show];
        //exit(1);
        return ;
    }
    
    /* Now read server response */
    
    n = read(sockfd, &data, sizeof(data));
    [fuel setTankRange:[NSString stringWithFormat:@"%d",data.tank.tankRange]];
    if (n < 0)
    {
        perror("ERROR reading from socket");
        char * error = strerror(errno);
        NSString * err = [NSString stringWithFormat:@"%s", error];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Receiving data failed!"
                                                        message:err
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        
        [alert show];
        //exit(1);
        return;
    }
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You are successfully connected!"
                                                    message:@"All fresh data from BMW was received!"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    
    [alert show];
    
}

- (IBAction)UpdateData:(UIBarButtonItem *)sender {
    [self coneectToBMW];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)deviceLocation {
    NSString *theLocation = [NSString stringWithFormat:@"latitude: %f longitude: %f", _locationManager.location.coordinate.latitude, _locationManager.location.coordinate.longitude];
    return theLocation;}

/*- (void)viewDidLoad
{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    
    
    [locationManager startUpdatingLocation];
}*/
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"goToFuel"])
    {
        // Get reference to the destination view controller
        FuelViewController *fc = [segue destinationViewController];
        NSString * postfix = @" liters";
        // Pass any objects to the view controller here, like...
        
        [fc setTankRange:[[NSString stringWithFormat:@"%d", data.tank.tankRange] stringByAppendingString:postfix]];
        [fc setTankSpare:[[NSString stringWithFormat:@"%d", data.tank.levelTankSpare] stringByAppendingString:postfix]];
        [fc setCoolantSpare:[[NSString stringWithFormat:@"%d", data.tank.coolantSpare] stringByAppendingString:postfix]];

    }
    
    if ([[segue identifier] isEqualToString:@"goToMileage"])
    {
        MileageViewController * miles = [segue destinationViewController];
        NSString * postfix = @" km";
        
        [miles setMileage:[[NSString stringWithFormat:@"%d", data.milleage] stringByAppendingString:postfix]];
    }
    
    if ([[segue identifier] isEqualToString:@"goToTemperature"])
    {
        TemperatureViewController * temp = [segue destinationViewController];
        
        [temp setEngTemp:[[NSString stringWithFormat:@"%d", data.temp.engine] stringByAppendingString:@"˚"]];
        [temp setOutdoorTemp:[[NSString stringWithFormat:@"%d", data.temp.otdoor] stringByAppendingString:@"˚"]];
    }
    
    if ([[segue identifier] isEqualToString:@"goToMap"])
    {
        
    }
}

@end
