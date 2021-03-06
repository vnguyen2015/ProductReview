//
//  User.m
//  ProductReview
//
//  Created by nxvinh@gmail.com on 5/27/16.
//  Copyright © 2016 vnguyen2015. All rights reserved.
//

#import "User.h"

@implementation User


+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"objectId": @"ID",
                                                       @"IsCustomer": @"UserType",
                                                       @"dateOfBirth.iso": @"DateOfBirth",
                                                       @"email":@"Email",
                                                       @"userName":@"Name",
                                                       }];
}



@end


@implementation UserList



@end
