//
//  AddReviewController.h
//  ProductReview
//
//  Created by nxvinh@gmail.com on 6/7/16.
//  Copyright © 2016 vnguyen2015. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCSStarRatingView.h"
#import "ServiceAPI.h"

@interface AddReviewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *rateValue;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *rateScore;
@property (weak, nonatomic) IBOutlet UITextField *emailInputField;

@property (weak, nonatomic) IBOutlet UITextView *reviewComment;

@property Product* productItem;
@property NSMutableArray<User> *allUserList;

@end
