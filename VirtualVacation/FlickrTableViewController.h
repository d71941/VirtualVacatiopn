//
//  TopPlacesTableViewController.h
//  TopPlaces
//
//  Created by admin on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FlickrTableViewController : UITableViewController
@property (nonatomic, strong) NSArray *dataArray;
- (NSDictionary *)getInforForRow:(NSInteger)row;
@end
