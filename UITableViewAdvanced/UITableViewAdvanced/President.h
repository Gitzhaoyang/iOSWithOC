//
//  President.h
//  UITableViewAdvanced01
//
//  Created by mungo on 19/03/16.
//  Copyright © 2016 mungo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface President : NSObject

@property (nonatomic, retain) NSString *firstName;
@property (nonatomic, retain) NSString *lastName;


+ (President *) presidentWithFirstName: (NSString *)firstname lastName: (NSString *)lastname;

@end
