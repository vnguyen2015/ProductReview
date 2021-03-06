//
//  User.h
//  ProductReview
//
//  Created by nxvinh@gmail.com on 5/27/16.
//  Copyright © 2016 vnguyen2015. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface User : JSONModel

@property (strong, nonatomic) NSString* ID;
@property (strong, nonatomic) NSNumber<Optional>* UserType;
@property (strong, nonatomic) NSString<Optional>* Name;
@property (strong, nonatomic) NSString<Optional>* Email;
@property (strong, nonatomic) NSString<Optional>* DateOfBirth;

@end

@protocol User
@end


@interface UserList : JSONModel

@property (strong, nonatomic) NSArray <User> *results;

@end


