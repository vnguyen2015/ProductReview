//
//  ServiceAPI.m
//  ProductReview
//
//  Created by nxvinh@gmail.com on 5/27/16.
//  Copyright © 2016 vnguyen2015. All rights reserved.
//

#import "ServiceAPI.h"

#pragma mark - Service constants
static NSString* host                       = @"https://api.parse.com";
static NSString* baseRequest                = @"/1/classes/";
static NSString* applicationIdHeader        = @"X-Parse-Application-Id";
static NSString* applicationAPIKeyHeader    = @"X-Parse-REST-API-Key";
static NSString* contentTypeHeader          = @"Content-Type";
static NSString* cacheControlHeader         = @"Cache-Control";
static NSString* apiKey                     = @"7BTXVX1qUXKUCnsngL8LxhpEHKQ8KKd798kKpD9W";
static NSString* appId                      = @"MlR6vYpYvLRxfibxE5cg0e73jXojL6jWFqXU6F8L";
static NSString* contentTypeValue           = @"application/json";
static NSString* cacheControlValue          = @"no-cache";




@interface ServiceAPI ()
{
}

@property AFHTTPSessionManager *manager;


# pragma mark - Declarations


@end



@implementation ServiceAPI

static ServiceAPI* sharedServiceAPI = Nil;


#pragma mark - Init
- (id) init
{
    if (self = [super init] )
    {
        _manager = [AFHTTPSessionManager manager];
    }
    
    return self;
}


+(instancetype) serviceAPI
{
    if (!sharedServiceAPI)
    {
        sharedServiceAPI = [[ServiceAPI alloc] init];
    }
    
    return sharedServiceAPI;
}

#pragma mark - Utility functions

- (void) setHTTPHeaderField:(NSDictionary*)dict
{
    NSEnumerator *enumerator = [dict keyEnumerator];
    id key;
    
    while (key = [enumerator nextObject])
    {
        [self.manager.requestSerializer setValue:[dict valueForKey:(NSString*)key] forHTTPHeaderField:(NSString*)key];
    }
}


#pragma mark - GET methods
-(void) getDataByType: (DataType)type
            parameters:(NSDictionary*)dict
            completion:(void (^)(NSArray<id>* result))completeBlock
            fail:(void (^)(NSError* err))failBlock
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSDictionary* httpHeader = @
    {
    contentTypeHeader: contentTypeValue,
    applicationIdHeader: appId,
    applicationAPIKeyHeader: apiKey,
    cacheControlHeader: cacheControlValue
    };
    
    [self setHTTPHeaderField:httpHeader];
    
    NSString* baseURLPath = [host stringByAppendingString:baseRequest];
    switch (type)
    {
        case DATA_BRAND:
            baseURLPath = [baseURLPath stringByAppendingString:@"Brand"];
            break;
        case DATA_PRODUCT:
            baseURLPath = [baseURLPath stringByAppendingString:@"Product"];
            break;
        case DATA_REVIEW:
            baseURLPath = [baseURLPath stringByAppendingString:@"Review"];
            break;
        case DATA_USER:
            baseURLPath = [baseURLPath stringByAppendingString:@"User"];
            break;
        default:
            break;
    }

    NSString* requestString = baseURLPath;

    if (dict != nil && [dict count] > 0)
    {
        NSString *paramsstring = [[NSString alloc]
                              initWithData:[NSJSONSerialization
                                            dataWithJSONObject:dict
                                            options:0
                                            error:nil]
                              encoding:NSUTF8StringEncoding];
        requestString = [NSString stringWithFormat:@"%@?where=%@", baseURLPath, paramsstring];
        
        NSCharacterSet *URLCombinedCharacterSet = [NSCharacterSet URLQueryAllowedCharacterSet];
        requestString= [requestString stringByAddingPercentEncodingWithAllowedCharacters:URLCombinedCharacterSet];
        requestString = [requestString stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
        
        requestString = [requestString stringByAppendingString:@"&order=-createdAt&limit=10"];
    }

    [self.manager GET:requestString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

         //NSLog(@"result: %@", responseObject);
         BrandList* brandList = Nil;
         ProductList* productList = Nil;
         ReviewList* reviewList = Nil;
         UserList* userList = Nil;
         
         switch (type)
         {
             case DATA_BRAND:
                 brandList = [[BrandList alloc] initWithDictionary:responseObject error:nil];
                 completeBlock(brandList.results);
                 break;

             case DATA_PRODUCT:
                 productList = [[ProductList alloc] initWithDictionary:responseObject error:nil];
//                 NSLog(@"ProductList %@", productList);
                 
                 completeBlock(productList.results);

                 break;

             case DATA_REVIEW:

                 //NSLog(@"result: %@", responseObject);
                 reviewList = [[ReviewList alloc] initWithDictionary:responseObject error:nil];
                 completeBlock(reviewList.results);

                 break;

             case DATA_USER:
                 //NSLog(@"result: %@", responseObject);
                 userList = [[UserList alloc] initWithDictionary:responseObject error:nil];
                 completeBlock(userList.results);
                 break;
                 
             default:
                 break;
         }
     }
     failure:^(NSURLSessionTask *task, NSError* error)
     {
         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
         NSLog(@"%s ERROR: %@", __FUNCTION__, error);
         failBlock(error);
     }];
}


#pragma mark - POST methods

- (void) postDataByType: (DataType) type
             parameters:(NSDictionary* _Nullable)params
             completion:(nullable void (^)(NSArray<id>* _Nullable result))completeBlock
                   fail:(nullable void (^)(NSError* _Nullable err))errorBlock
{
    self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSDictionary* httpHeader = @
    {
    contentTypeHeader: contentTypeValue,
    applicationIdHeader: appId,
    applicationAPIKeyHeader: apiKey,
    cacheControlHeader: cacheControlValue,
    };
    
    [self setHTTPHeaderField:httpHeader];
    
    NSString* baseURLPath = [host stringByAppendingString:baseRequest];
    switch (type)
    {
        case DATA_BRAND:
            baseURLPath = [baseURLPath stringByAppendingString:@"Brand"];
            break;
        case DATA_PRODUCT:
            baseURLPath = [baseURLPath stringByAppendingString:@"Product"];
            break;
        case DATA_REVIEW:
            baseURLPath = [baseURLPath stringByAppendingString:@"Review"];
            break;
        case DATA_USER:
            baseURLPath = [baseURLPath stringByAppendingString:@"User"];
            break;
        default:
            break;
    }
    
    
    [self.manager POST:baseURLPath parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject)
    {
        NSLog(@"%@", task.currentRequest);
        NSLog(@"OK: %@", responseObject);
        completeBlock(nil);
    }
    failure:^(NSURLSessionTask *task, NSError* error)
    {
        NSLog(@"%s ERROR: %@", __FUNCTION__, error);
        errorBlock(error);
    }];
}




@end
