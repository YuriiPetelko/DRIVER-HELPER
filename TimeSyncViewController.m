//
//  TimeSyncViewController.m
//  BMW_Client
//
//  Created by Yurii Petelko on 21.01.14.
//  Copyright (c) 2014 Yurii Petelko. All rights reserved.
//

#import "TimeSyncViewController.h"
#import "TableOptionsViewController.h"
#import "SWRevealViewController.h"
#import <sys/socket.h>
#import <arpa/inet.h>
#import <netinet/in.h>

@interface TimeSyncViewController ()
@property (strong, nonatomic) IBOutlet UIBarButtonItem *sync;

@end

@implementation TimeSyncViewController

@synthesize sideBar = _sideBar;

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    tableData = [NSMutableArray arrayWithObjects:@"Current local time", @"Current TZ", @"Current Location", nil];
    self.navigationItem.leftBarButtonItem = _sideBar;
    self.navigationItem.rightBarButtonItem = _sync;
    //tableData = @[@"level", @"range", @"coolant"];
    
    _sideBar.tintColor = [UIColor colorWithWhite:0.1f alpha:0.9f];
    
    _sideBar.target = self.revealViewController;
    _sideBar.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];}

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
    return 3;
}

- (IBAction)syncTime:(UIBarButtonItem *)sender {
    int portno, n , opt = 1;
    struct sockaddr_in serv_addr;
    struct hostent *server;
    int sockfd;
    double data;
    
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
    
    /* Now write to server*/
    NSDate *date = [NSDate date];
    data = [[NSDate date] timeIntervalSince1970];
    n = write(sockfd, &data, sizeof(data));


    if (n < 0)
    {
        perror("ERROR reading from socket");
        char * error = strerror(errno);
        NSString * err = [NSString stringWithFormat:@"%s", error];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Time synchronization faled!"
                                                        message:err
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        
        [alert show];
        //exit(1);
        return;
    }
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Time was successfully set!"
                                                    message:@""
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    
    [alert show];
    

    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier /*forIndexPath:indexPath*/];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
    cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
    if (indexPath.row == 0)
    {
        NSDate * now = [NSDate date];
        NSDateFormatter * dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"hh:mm dd.MM.yyyy"];
        NSString * dataString = [dateFormat stringFromDate:now];
        
        cell.detailTextLabel.text = dataString;
    } else if (indexPath.row == 1)
    {
        NSTimeZone * tz = [NSTimeZone systemTimeZone];
        NSString * tzUTC = [tz abbreviation];

        cell.detailTextLabel.text = tzUTC;
    } else {
        NSTimeZone *timeZone = [NSTimeZone localTimeZone];
        NSString *tzName = [timeZone name];
        cell.detailTextLabel.text = tzName;
    }
    cell.userInteractionEnabled = NO;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
