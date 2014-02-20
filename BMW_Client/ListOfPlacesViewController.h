//
//  ListOfPlacesViewController.h
//  BMW_Client
//
//  Created by Yurii Petelko on 10.02.14.
//  Copyright (c) 2014 Yurii Petelko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListOfPlacesViewController : UIViewController
{
    NSMutableArray * namesOfObjects;
    NSMutableArray * vicinitiesOfObjects;
}
-(void)setNames:(NSMutableArray*)objName vicinity:(NSMutableArray*)vicObject;
@end
