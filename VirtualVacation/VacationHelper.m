//
//  VacationHelper.m
//  VirtualVacation
//
//  Created by d71941 on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VacationHelper.h"

#define VACATIONS_PATH @"Vavations"

static NSMutableDictionary *vacationsForName;

@implementation VacationHelper
+ (void)addVacation:(UIManagedDocument *)vacation withName:(NSString *)vacationName
{
    if(!vacationsForName)
    {
        vacationsForName = [[NSMutableDictionary alloc] init];
    }

    [vacationsForName setObject:vacation forKey:vacationName];
}

+ (void)openVacation:(NSString *)vacationName usingBlock:(completion_block_t)completionBlock
{
    NSFileManager *fileMgr = [[NSFileManager alloc] init];
    UIManagedDocument *vacation = [vacationsForName objectForKey:vacationName];
    NSURL *dirURL = [[[fileMgr URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:VACATIONS_PATH];

    if(!vacation)
    {
        vacation = [[UIManagedDocument alloc] initWithFileURL:[dirURL URLByAppendingPathComponent:vacationName]];
        [self addVacation:vacation withName:vacationName];
    }
    
    if (![fileMgr fileExistsAtPath:[vacation.fileURL path]])
    {
        BOOL isDir, isExist;
        isExist = [fileMgr fileExistsAtPath:[dirURL path] isDirectory:&isDir];
        if(!isDir || !isExist)
        {
            [fileMgr createDirectoryAtURL:dirURL withIntermediateDirectories:YES attributes:nil error:nil];
        }

        [vacation saveToURL:vacation.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success){
            if(success)
            {
                completionBlock(vacation);
            }
        }];
    }
    else if(vacation.documentState == UIDocumentStateClosed)
    {
        [vacation openWithCompletionHandler:^(BOOL success){
            if(success)
            {
                completionBlock(vacation);
            }
        }];
    }
    else if(vacation.documentState == UIDocumentStateNormal)
    {
        completionBlock(vacation);
    }
}
@end
