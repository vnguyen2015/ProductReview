//
//  AddReviewController.m
//  ProductReview
//
//  Created by nxvinh@gmail.com on 6/7/16.
//  Copyright © 2016 vnguyen2015. All rights reserved.
//

#import "AddReviewController.h"

@interface AddReviewController()

- (void) commitReview: (id) sender;

@end

@implementation AddReviewController

NSString* cachedEmailString = @"";

- (IBAction)rateScoreChanged:(id)sender {
    [self.rateValue setText:[NSString stringWithFormat:@"%0.1f", self.rateScore.value]];
}

- (void) goBack
{
    NSLog(@"goBack to precvious screen");
    [self.navigationController popViewControllerAnimated:YES];
}


- (void) addReview:(NSNumber*)rate productID:(NSString*) productObjectID userID:(NSString* )userObjectID
{
    NSDictionary* param = @{
                            @"comment": self.reviewComment.text,
                            @"rating": rate,
                            @"productID": @{ @"__type": @"Pointer",
                                             @"className": @"Product",
                                             @"objectId": productObjectID},
                            @"userID": @{
                                    @"__type": @"Pointer",
                                    @"className": @"User",
                                    @"objectId":  userObjectID
                                    },
                            };
    
    void (^addReviewResultHandler)(NSArray<id>* result) = ^(NSArray<id>* result) {
        NSLog(@"POST OK");

        //[self.savingDataIcon stopAnimating];
        [self goBack];
        
    };
    
    void (^addReviewFailureHandler)(NSError* err) = ^(NSError* err){
        NSLog(@"POST failure returned: %@", err);
        //[self.loadingIcon stopAnimating];
        //[self.savingDataIcon stopAnimating];
    };
    
    //[self.savingDataIcon startAnimating];
    
    [[ServiceAPI serviceAPI] postDataByType:DATA_REVIEW parameters:param completion:addReviewResultHandler fail:addReviewFailureHandler];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    // more
    
    // Back button on the left of nativegation bar
    UIButton* backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back-icon.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBarButton;

    // Add review button on the right of nativegation bar
    UIButton* addBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    [addBtn setTitle:@"Save" forState:UIControlStateNormal];
    [addBtn setBackgroundColor:[UIColor colorWithRed:40.0f/255.0f green:40.0f/255.0f blue:1 alpha:0.1f]];
    addBtn.layer.cornerRadius = 8;
    addBtn.layer.borderWidth = 0.5f;
    
    //[addBtn setBackgroundImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(commitReview:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:addBtn];
    self.navigationItem.rightBarButtonItem = rightBarButton;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // more
    [self.navigationItem.rightBarButtonItem.customView  setUserInteractionEnabled:YES];
    self.emailInputField.layer.borderWidth = 1.0f;
    self.emailInputField.layer.borderColor = [[UIColor blackColor] CGColor];
    
    [self.productName setText:self.productItem.Name];
    self.reviewComment.layer.borderWidth = 1.0f;
    self.reviewComment.layer.borderColor = [[UIColor grayColor] CGColor];
    self.reviewComment.layer.cornerRadius = 8;
    
    [self.rateScore setValue:0]; // 0 by default
    [self.rateValue setText:[NSString stringWithFormat:@"%0.1f", self.rateScore.value]];

    [self.emailInputField setText:cachedEmailString];
    [self.reviewComment setText:@""];
}

- (BOOL) validateUserEmail:(NSString*) emailString
{
    for (User *user in self.allUserList)
    {
        if ([user.Email isEqualToString:emailString])
        {
            return TRUE;
        }
    }

    return FALSE;
}

# pragma mark - TextField Delegate


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.emailInputField)
    {
        //
        if (![self validateUserEmail:textField.text])
        {
            NSLog(@"invalid email address!!!");
            
            self.emailInputField.layer.borderColor = [[UIColor redColor] CGColor];
            [self.emailInputField setPlaceholder:@"Re-enter email address (e.g.: david@gmail.com)"];
            [self.emailInputField setText:@""];
            
            return NO;
        }
        cachedEmailString = textField.text;
        self.emailInputField.layer.borderColor = [[UIColor blackColor] CGColor];

        [textField resignFirstResponder];
        [self.reviewComment becomeFirstResponder];
    }
    
    return YES;
}

# pragma mark - Text View Delegate


- (void) commitReview: (id) sender
{
    NSLog(@"rate = %0.1f email: %@,\ncomment:%@", [self.rateScore value], self.emailInputField.text, self.reviewComment.text);
    NSString* userObjID = nil;
    
    
    NSNumber* rate = [NSNumber numberWithInt:(int)self.rateScore.value];

    if (![self validateUserEmail:self.emailInputField.text])
    {
        NSLog(@"invalid email address!!!");

        self.emailInputField.layer.borderColor = [[UIColor redColor] CGColor];
        [self.emailInputField setPlaceholder:@"Re-enter email address (e.g.: david@gmail.com)"];
        [self.emailInputField setText:@""];
        
        return;
    }

    cachedEmailString = self.emailInputField.text;
    self.emailInputField.layer.borderColor = [[UIColor blackColor] CGColor];

    for (User *user in self.allUserList)
    {
        if ([user.Email isEqualToString:self.emailInputField.text])
        {
            userObjID = user.ID;
        }
    }
   
    if (!userObjID)
    {
        NSLog(@"ERROR unknown USERID");
        return;
    }

    UIButton* button = (UIButton*) sender;
    [button setUserInteractionEnabled:NO];
    
    [self addReview:rate productID:self.productItem.ID userID:userObjID];
    //[self goBack];
}

@end
