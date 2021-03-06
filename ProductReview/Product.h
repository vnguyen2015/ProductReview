//
//  Product.h
//  ProductReview
//
//  Created by nxvinh@gmail.com on 5/27/16.
//  Copyright © 2016 vnguyen2015. All rights reserved.
//

#import "JSONModel.h"
#import "Review.h"

@interface Product : JSONModel

@property (strong, nonatomic) NSString* ID;
@property (strong, nonatomic) NSString* Name;
@property (strong, nonatomic) NSString* Description;
@property (strong, nonatomic) NSNumber* Price;
@property (strong, nonatomic) NSString* Colour;
@property (strong, nonatomic) NSString* DateCreated;
@property (strong, nonatomic) NSString* AvailableStatus;


// additional properties
//@property (strong, nonatomic) NSArray<Ignore> *reviews;
@property (strong, nonatomic) NSNumber<Ignore> *averageRating;

@end

@protocol Product
@end

@interface ProductList : JSONModel

@property (strong, nonatomic) NSArray <Product> *results;

@end
