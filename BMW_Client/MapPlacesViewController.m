//
//  MapPlacesViewController.m
//  BMW_Client
//
//  Created by Yurii Petelko on 24.01.14.
//  Copyright (c) 2014 Yurii Petelko. All rights reserved.
//

#import "MapPlacesViewController.h"
#import "SWRevealViewController.h"
#import "SINavigationMenuView.h"
#import "ListOfPlacesViewController.h"
#import "Reachability.h"

@interface MapPlacesViewController () <MKMapViewDelegate, SINavigationMenuDelegate>
{

    MKPolyline * _routeOverlay;
    MKRoute * _currentRoute;
    int count;
    NSMutableArray * names;
    NSMutableArray * vicinities;
    NSMutableArray * _distance;

}
@property (strong, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@end

@implementation MapPlacesViewController
@synthesize mapView;
@synthesize sidebarButton = _sidebarButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    names = [[NSMutableArray alloc] init];
    vicinities = [[NSMutableArray alloc] init];
    routesList = [[NSMutableArray alloc] init];
    _distance = [[NSMutableArray alloc] init];
    _currentRoute = [[MKRoute alloc] init];
    
    //For navigation menu
    if (self.navigationItem)
    {
        CGRect frame = CGRectMake(0.0, 0.0, 200.0 ,self.navigationController.navigationBar.bounds.size.height);
        SINavigationMenuView * menu = [[SINavigationMenuView alloc] initWithFrame:frame title:@"Map"];
        [menu displayMenuInView:self.navigationController.view];
        menu.items = @[@"List of nearby objects", @"Another services", @"Add my place", @"Satellite", @"Hybrid", @"Map"];
    
        menu.delegate = self;
        self.navigationItem.titleView = menu;
        
    }
    
    //end for navigation menu

    //Make this controller the delegate for the map view.
    self.mapView.delegate = self;
    
    // Ensure that we can view our own location in the map view.
    [self.mapView setShowsUserLocation:YES];
 
    [self initLocation];
    
    //Set the first launch instance variable to allow the map to zoom on the user location when first launched.
    firstLaunch=YES;
    
    // Change button color
    _sidebarButton.tintColor = [UIColor colorWithWhite:0.1f alpha:0.9f];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
}
-(void)initLocation
{
    
    //Instantiate a location object.
    locationManager = [[CLLocationManager alloc] init];
    
    //Make this controller the delegate for the location manager.
    [locationManager setDelegate:self];
    
    //Set some paramater for the location object.
    [locationManager setDistanceFilter:kCLDistanceFilterNone];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
}
-(void)setPlaces:(NSString*) type
{
    //places = type;
    //NSLog(@"here");
}

-(void) queryGooglePlaces: (NSString *) googleType
{
    Reachability * abilityOfInet = [Reachability reachabilityForInternetConnection];
    NetworkStatus statusOfNet = [abilityOfInet currentReachabilityStatus];
    if (statusOfNet == NotReachable)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                                        message:@"No available internet connection!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    // Build the url string we are going to sent to Google. NOTE: The kGOOGLE_API_KEY is a constant which should contain your own API key that you can obtain from Google. See this link for more info:
    // https://developers.google.com/maps/documentation/places/#Authentication
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=%@&types=%@&sensor=true&key=%@", currentCentre.latitude, currentCentre.longitude,/*center.location.coordinate.latitude, center.location.coordinate.longitude,*/ [NSString stringWithFormat:@"%i", currenDist], googleType, kGOOGLE_API_KEY];
    
    //Formulate the string as URL object.
    NSURL *googleRequestURL=[NSURL URLWithString:url];
    
    // Retrieve the results of the URL.
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL: googleRequestURL];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
    //routeStart
}

- (void)fetchedData:(NSData *)responseData {
    //parse out the json data

    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          
                          options:kNilOptions
                          error:&error];
    
    //The results from Google will be an array obtained from the NSDictionary object with the key "results".
    NSArray* places = [json objectForKey:@"results"];
    
    //Write out the data to the console.
    NSLog(@"Google Data: %@", places);
    
    //Plot the data in the places array onto the map with the plotPostions method.
    [self plotPositions:places];
    
}

- (void)plotPositions:(NSArray *)data
{
    
    count = 0;
    
    //Remove any existing custom annotations but not the user location blue dot.
    for (id<MKAnnotation> annotation in mapView.annotations)
    {
        if ([annotation isKindOfClass:[MapPoint class]])
        {
            [mapView removeAnnotation:annotation];
        }
    }
    
    
    //Loop through the array of places returned from the Google API.
    for (int i=0; i<[data count]; i++)
    {
        
        //Retrieve the NSDictionary object in each index of the array.
        NSDictionary* place = [data objectAtIndex:i];
        
        //There is a specific NSDictionary object that gives us location info.
        NSDictionary *geo = [place objectForKey:@"geometry"];
        
        
        //Get our name and address info for adding to a pin.
        NSString *name=[place objectForKey:@"name"];
        NSString *vicinity=[place objectForKey:@"vicinity"];
        
        //Get the lat and long for the location.
        NSDictionary *loc = [geo objectForKey:@"location"];
        
        //Create a special variable to hold this coordinate info.
        CLLocationCoordinate2D placeCoord;
        destination[count] = placeCoord;
        
        //Set the lat and long.
        placeCoord.latitude=[[loc objectForKey:@"lat"] doubleValue];
        placeCoord.longitude=[[loc objectForKey:@"lng"] doubleValue];
        
        
        
        //count distance from current location to object
        MKDirectionsRequest *directionsRequest = [MKDirectionsRequest new];
        // Start at our current location
        MKMapItem *source = [MKMapItem mapItemForCurrentLocation];
        NSLog(@"curren center %f", currentCentre.latitude);

        [directionsRequest setSource:source];
        
        MKPlacemark *destinationPlacemark = [[MKPlacemark alloc] initWithCoordinate:placeCoord addressDictionary:nil];
        MKMapItem *destinationPoint = [[MKMapItem alloc] initWithPlacemark:destinationPlacemark];
        [directionsRequest setDestination:destinationPoint];
            
        MKDirections *directions = [[MKDirections alloc] initWithRequest:directionsRequest];
        [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
                
                if (error) {
                    NSLog(@"%@",[error localizedDescription]);
                    return;
                }
                
                _currentRoute = [response.routes firstObject];
                [_distance addObject:_currentRoute];
                [names addObject:name];
                [vicinities addObject:vicinity];
            
            }];
        NSLog(@"distance add to object %f", _currentRoute.distance);
        count++;

        //Create a new annotiation.
        MapPoint *placeObject = [[MapPoint alloc] initWithName:name address:vicinity coordinate:placeCoord];
        
        
        [mapView addAnnotation:placeObject];
    }
}

- (IBAction)GoToCurrentLocation:(id)sender {
    [self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate animated:YES];
}

- (IBAction)showPetrolStations:(UIBarButtonItem *)sender {
    
    //clean arrays for new objects
    [names removeAllObjects];
    [vicinities removeAllObjects];
    [_distance removeAllObjects];
    
    [self queryGooglePlaces:@"gas_station"];
    self.navigationController.title = @"Gas station";
    [self.mapView removeOverlay:_routeOverlay];
}

- (IBAction)showCarRepair:(UIBarButtonItem *)sender {
    
    //clean arrays for new objects
    [names removeAllObjects];
    [vicinities removeAllObjects];
    [_distance removeAllObjects];
    
    [self queryGooglePlaces:@"car_repair"];
    _navItem.title = @"Car repair";
    [self.mapView removeOverlay:_routeOverlay];
}
- (IBAction)showCarWashes:(UIBarButtonItem *)sender {
    //clean arrays for new objects
    [names removeAllObjects];
    [vicinities removeAllObjects];
    [_distance removeAllObjects];
    
    [self queryGooglePlaces:@"car_wash"];
    self.navigationController.title = @"Car wash";
    [self.mapView removeOverlay:_routeOverlay];
}


- (void)viewDidUnload
{
    [self setMapView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
}

#pragma mark - MKMapViewDelegate methods.

///
- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views
{
    //Zoom back to the user location after adding a new set of annotations.
    NSLog(@"3");
    //Get the center point of the visible map.
    CLLocationCoordinate2D centre = [mv centerCoordinate];
    
    MKCoordinateRegion region;
    
    //If this is the first launch of the app then set the center point of the map to the user's location.
    if (firstLaunch) {
        region = MKCoordinateRegionMakeWithDistance(locationManager.location.coordinate,1000,1000);
        firstLaunch=NO;
    }else {
        //Set the center point to the visible region of the map and change the radius to match the search radius passed to the Google query string.
        region = MKCoordinateRegionMakeWithDistance(centre,currenDist,currenDist);
    }
    
    //Set the visible region of the map.
    [mv setRegion:region animated:YES];
    
}
///
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    NSLog(@"4");
    static NSString *identifier = @"MapPoint";
    
    if ([annotation isKindOfClass:[MapPoint class]]) {
        
        MKAnnotationView *annotationView = (MKAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        } else {
            annotationView.annotation = annotation;
        }
        
        [annotation coordinate];
        
        UIButton * favoutite = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        //[favoutite addTarget:self action:@selector(makeRoute:) forControlEvents:UIControlEventTouchUpInside];
        annotationView.rightCalloutAccessoryView = favoutite;
        
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        //annotationView.animatesDrop = YES;
        annotationView.image = [UIImage imageNamed:@"pin.png"];
        
        return annotationView;
    }
    
    return nil;
}

- (IBAction)makeRoute:(id) sender {
    
    
    // Make a directions requests
    MKDirectionsRequest *directionsRequest = [MKDirectionsRequest new];
    // Start at our current location
    MKMapItem *source = [MKMapItem mapItemForCurrentLocation];
    NSLog(@"curren center %f", currentCentre.latitude);
    //MKPlacemark *sourcePlacemark = [[MKPlacemark alloc] initWithCoordinate:currentCentre addressDictionary:nil];
    
    //MKMapItem *source = [[MKMapItem alloc] initWithPlacemark:sourcePlacemark];    // Make the destination
    [directionsRequest setSource:source];
    int i = 0;
    while (i<count)
    {
        CLLocationCoordinate2D coord = destination[i];
        
    
        MKPlacemark *destinationPlacemark = [[MKPlacemark alloc] initWithCoordinate:coord addressDictionary:nil];
        MKMapItem *destinationPoint = [[MKMapItem alloc] initWithPlacemark:destinationPlacemark];
        [directionsRequest setDestination:destinationPoint];
        
        MKDirections *directions = [[MKDirections alloc] initWithRequest:directionsRequest];
        [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {

            if (error) {
                NSLog(@"%@",[error localizedDescription]);
                return;
            }
            
            _currentRoute = [response.routes firstObject];
            //[self plotRouteOnMap:_currentRoute];
            
        }];
        i++;
    }
}


//for route
/*-(void)plotRouteOnMap:(MKRoute *) route
{
    
    if (_routeOverlay){
        [self.mapView removeOverlay:_routeOverlay];
    }
    
    //update
    _routeOverlay = route.polyline;
    
    [_distance addObject:route];
}*/

#pragma mark - MKMapViewDelegate methods
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
    renderer.strokeColor = [UIColor redColor];
    renderer.lineWidth = 4.0;
    return  renderer;
}
//end for route

///EVERY TIME BY SCROLLING AND ZOOMING
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    NSLog(@"5");
    //Get the east and west points on the map so we calculate the distance (zoom level) of the current map view.
    MKMapRect mRect = self.mapView.visibleMapRect;
    MKMapPoint eastMapPoint = MKMapPointMake(MKMapRectGetMinX(mRect), MKMapRectGetMidY(mRect));
    MKMapPoint westMapPoint = MKMapPointMake(MKMapRectGetMaxX(mRect), MKMapRectGetMidY(mRect));
    
    //Set our current distance instance variable.
    currenDist = MKMetersBetweenMapPoints(eastMapPoint, westMapPoint);
    
    //Set our current centre point on the map instance variable.
    currentCentre = self.mapView.centerCoordinate;
}


/*
 *for pop up menu in the TOP of the screen
 */
- (void)didSelectItemAtIndex:(NSUInteger)index
{
    
    if (index == 0)
    {
        ListOfPlacesViewController * seg = [[ListOfPlacesViewController alloc] init];
        [seg setNames:names vicinity:vicinities];
        [self showListView];
    } else if (index == 3)
    {
        self.mapView.mapType = MKMapTypeSatellite;
    } else if (index == 4)
    {
        self.mapView.mapType = MKMapTypeHybrid;
    } else if (index == 5)
    {
        self.mapView.mapType = MKMapTypeStandard;
    }


    //[self performSegueWithIdentifier:@"placesList" sender:self];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ListOfPlacesViewController * seg = [segue destinationViewController];
    
    if ([[segue identifier] isEqualToString:@"placesList"])
    {
        NSLog(@"segue");
        [seg setNames:names vicinity:vicinities];
        NSLog(@"couNt of array %lu", (unsigned long)[names count]);
    }
}


/*
 *for pop up view in the middle of screen
 */
- (void)showListView {
    NSLog(@"distance to view %lu", (unsigned long)_distance.count);
    LeveyPopListView *lplv = [[LeveyPopListView alloc] initWithTitle:@"List of nearby places" options:names distance:_distance handler:^(NSInteger anIndex) {
        //_infoLabel.text = [NSString stringWithFormat:@"You have selected %@", _options[anIndex]];
    }];
    lplv.delegate = self;
    [lplv showInView:self.view animated:YES];
    NSLog(@"select pop up view");
}

#pragma mark - LeveyPopListView delegates
- (void)leveyPopListView:(LeveyPopListView *)popListView didSelectedIndex:(NSInteger)anIndex {
    
    MKRoute * route = [_distance objectAtIndex:anIndex];
    
    if (_routeOverlay){
        [self.mapView removeOverlay:_routeOverlay];
    }

    _routeOverlay = route.polyline;
  
    [self.mapView addOverlay:_routeOverlay];    //_infoLabel.text = [NSString stringWithFormat:@"You have
    //[self.mapView setCenterCoordinate:/*self.mapView.userLocation.coordinate*/[route  animated:YES];
}
- (void)leveyPopListViewDidCancel {
    NSLog(@"You have cancelled");
}

@end
