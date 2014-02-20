//
//  FuelViewController.m
//  BMW_Client
//
//  Created by Yurii Petelko on 20.01.14.
//  Copyright (c) 2014 Yurii Petelko. All rights reserved.
//

#import "FuelViewController.h"
#import "SWRevealViewController.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface FuelViewController ()

@end

@implementation FuelViewController
@synthesize navBarFuel = _navBarFuel;
@synthesize sideBar = _sideBar;

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem = self.editButtonItem
    
    //[[self navigationController] setNavigationBarHidden:YES];
    
    //[[self.navigationItem appearance] setBarTintColor:UIColorFromRGB(0x067AB5)];
    
    self.navigationItem.leftBarButtonItem = _sideBar;
    tableData = @[@"level", @"range", @"coolant", @"status"];
    
    _sideBar.tintColor = [UIColor colorWithWhite:0.1f alpha:0.9f];
 
    _sideBar.target = self.revealViewController;
    _sideBar.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setTankRange:(NSString *)level
{
    tankRange = level;
}

-(void)setTankSpare:(NSString *)level
{
    tankSpare = level;
}

-(void)setCoolantSpare:(NSString *)level
{
    coolantSpare = level;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [tableData objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    cell.userInteractionEnabled = NO;
    return cell;
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

}



@end
