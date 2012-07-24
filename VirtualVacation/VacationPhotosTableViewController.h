//
//  VacationPhotosTableViewController.h
//  VirtualVacation
//
//  Created by d71941 on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "Place.h"

@interface VacationPhotosTableViewController : CoreDataTableViewController
@property (nonatomic, strong) NSString *placeName;
@end
