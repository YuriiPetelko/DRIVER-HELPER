//
//  ListOfPlacesViewController.m
//  BMW_Client
//
//  Created by Yurii Petelko on 10.02.14.
//  Copyright (c) 2014 Yurii Petelko. All rights reserved.
//

#import "ListOfPlacesViewController.h"

@interface ListOfPlacesViewController ()

@end

@implementation ListOfPlacesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"List of objects";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    //vicinitiesOfObjects = [[NSMutableArray alloc] init];
    [self.navigationController.navigationItem.backBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIColor blackColor],NSForegroundColorAttributeName,[UIFont fontWithName:@"HelveticaNeue" size:19.0], UITextAttributeFont,
                                        nil] forState:UIControlStateNormal];     //namesOfObjects = get
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //self.navigationItem.title = @"List of objects";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return [namesOfObjects count];
}

-(void)setNames:(NSMutableArray*)objName vicinity:(NSMutableArray*)vicObject;
{
    namesOfObjects = [[NSMutableArray alloc] initWithArray:objName];
    vicinitiesOfObjects = [[NSMutableArray alloc] initWithArray:vicObject];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    //NSString * name = [namesOfObjects objectAtIndex:1];
    if (namesOfObjects.count > 0)
    {
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        cell.textLabel.text = [namesOfObjects objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [vicinitiesOfObjects objectAtIndex:indexPath.row];
    }
    // Configure the cell...
   // NSString *CellIdentifier = listOfPlaces[indexPath.row].name;
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    return cell;
}

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
