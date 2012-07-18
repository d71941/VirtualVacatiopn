//
//  Tag+Create.h
//  VirtualVacation
//
//  Created by d71941 on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Tag.h"

@interface Tag (Create)
+ (Tag *)tagWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context;
@end
