//
//  Review.h
//  ProductReview
//
//  Created by nxvinh@gmail.com on 5/27/16.
//  Copyright © 2016 vnguyen2015. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface Review : JSONModel

@property (strong, nonatomic) NSString* ID;
@property (strong, nonatomic) NSString<Optional>* Comment;
@property (strong, nonatomic) NSString<Optional>* ProductID;
@property (strong, nonatomic) NSString<Optional>* UserID;
@property (strong, nonatomic) NSNumber<Optional>* Rate;
@property (strong, nonatomic) NSString* Date;
@property (strong, nonatomic) NSString<Optional>* UserName;

@end

@protocol Review <NSObject>
@end

@interface ReviewList : JSONModel

@property (strong, nonatomic) NSArray <Review> *results;

@end
