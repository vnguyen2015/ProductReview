//
//  Brand.m
//  ProductReview
//
//  Created by nxvinh@gmail.com on 5/27/16.
//  Copyright © 2016 vnguyen2015. All rights reserved.
//

#import "Brand.h"

@implementation Brand

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"objectId": @"ID",
                                                       @"name": @"Name",
                                                       @"description": @"Description"
                                                       }];
}

@end

@implementation BrandList

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                   @"results": @"results",
                                                   }];
}

@end
