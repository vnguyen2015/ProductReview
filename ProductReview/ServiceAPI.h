//
//  ServiceAPI.h
//  ProductReview
//
//  Created by nxvinh@gmail.com on 5/27/16.
//  Copyright © 2016 vnguyen2015. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "Brand.h"
#import "Product.h"
#import "Review.h"
#import "User.h"

typedef enum _DataType
{
    DATA_BRAND       = 0,
    DATA_PRODUCT,
    DATA_REVIEW,
    DATA_USER
} DataType;


@interface ServiceAPI : NSObject


+(_Nonnull instancetype) serviceAPI;


//  Design
//    Constants: host, http string/key
//    Enummerations: data type -> {brand, product, review, user}
//
//    API service is a singleton instance for accessing from controllers
//      + API for quering data:
//        -- getDataByType: type parameters:filter completeBlock failBlock
//      + API for posting data
//        -- postDataByType
//
//    Internal function:
//      - make http header by each kind of query



- (void) getDataByType: (DataType) type
             parameters:(NSDictionary* _Nullable)params
             completion:(nullable void (^)(NSArray<id>* _Nullable result))completeBlock
             fail:(nullable void (^)(NSError* _Nullable err))errorBlock;

- (void) setHTTPHeaderField:(NSDictionary* _Nonnull)dict;

- (void) postDataByType: (DataType) type
             parameters:(NSDictionary* _Nullable)params
             completion:(nullable void (^)(NSArray<id>* _Nullable result))completeBlock
                   fail:(nullable void (^)(NSError* _Nullable err))errorBlock;



@end
