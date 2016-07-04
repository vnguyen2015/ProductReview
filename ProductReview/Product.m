//
//  Product.m
//  ProductReview
//
//  Created by nxvinh@gmail.com on 5/27/16.
//  Copyright © 2016 vnguyen2015. All rights reserved.
//

#import "Product.h"

@implementation Product


+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"objectId": @"ID",
                                                       @"productName": @"Name",
                                                       @"description": @"Description",
                                                       @"price": @"Price",
                                                       @"colour":@"Colour",
                                                       @"dateCreated.iso":@"DateCreated",
                                                       @"availabilityStatus":@"AvailableStatus"
                                                       }];
}


@end

@implementation ProductList

@end
