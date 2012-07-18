//
//  Place+Create.h
//  VirtualVacation
//
//  Created by d71941 on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Place.h"

@interface Place (Create)
+ (Place *)placeWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context;
@end
