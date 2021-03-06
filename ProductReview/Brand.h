//
//  Brand.h
//  ProductReview
//
//  Created by nxvinh@gmail.com on 5/27/16.
//  Copyright © 2016 vnguyen2015. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import "JSONModel.h"

@protocol Brand
@end

@interface Brand : JSONModel

@property (strong, nonatomic) NSString* ID;
@property (strong, nonatomic) NSString* Name;
@property (strong, nonatomic) NSString* Description;

@end

@interface BrandList : JSONModel

@property (strong, nonatomic) NSArray <Brand> *results;

@end
