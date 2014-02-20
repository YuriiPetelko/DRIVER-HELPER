//
//  MapPlacesViewController.h
//  BMW_Client
//
//  Created by Yurii Petelko on 24.01.14.
//  Copyright (c) 2014 Yurii Petelko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MapPoint.h"
#import "LeveyPopListView/LeveyPopListView.h"
#import "NavigationMenuView/SINavigationMenuView.h"

#define kGOOGLE_API_KEY @"AIzaSyChM3pCcszanPEhzJ2ER6vKWREvwXMKBrk"
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)




@interface MapPlacesViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, LeveyPopListViewDelegate >
{
    CLLocationManager *locationManager;
    
    CLLocationCoordinate2D currentCentre;
    
    CLLocationCoordinate2D destination[255];
    CLLocationCoordinate2D routeStart;
    NSMutableArray * routesList;
    int currenDist;
    BOOL firstLaunch;
    
}

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) IBOutlet UINavigationItem *navItem;
-(void)setDataAboutPlaces:(NSString*) type;
-(void) queryGooglePlaces: (NSString *) googleType;

@end
