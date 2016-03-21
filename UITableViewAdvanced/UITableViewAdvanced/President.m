//
//  President.m
//  UITableViewAdvanced01
//
//  Created by mungo on 19/03/16.
//  Copyright © 2016 mungo. All rights reserved.
//

#import "President.h"

@implementation President

+ (President *) presidentWithFirstName:(NSString *)firstname lastName:(NSString *)lastname {
    President *president = [[President alloc] init];
    president.firstName = firstname;
    president.lastName  = lastname;
    
    return president;
}

@end
