//
//  ObjectListViewController.h
//  BMW_Client
//
//  Created by Yurii Petelko on 10.02.14.
//  Copyright (c) 2014 Yurii Petelko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ObjectListViewController : UITableViewController
{
    struct placePin{
        float distance;
        __unsafe_unretained NSString * name;
        __unsafe_unretained NSString * vicinity;
    };
    struct placePin listOfPlaces[255];
}
@end
