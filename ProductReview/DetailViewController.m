//
//  DetailViewController.m
//  ProductReview
//
//  Created by nxvinh@gmail.com on 6/3/16.
//  Copyright © 2016 vnguyen2015. All rights reserved.
//

#import "DetailViewController.h"
#import "ReviewItemCell.h"
#import "AddReviewController.h"

@interface DetailViewController ()
{
}

@property NSMutableArray<Review> *recentReviewList;
@property NSMutableArray<User> *allUserList;

@end

static NSString* reviewItemCellReuseIdentifier = @"ReviewItemCell";
static NSString* segueShowAddReviewController = @"showAddReviewController";

@implementation DetailViewController


# pragma mark - Internal functions

- (void) goBack: (id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) addReview:(id)sender
{
    NSArray* data = [[NSArray alloc] initWithObjects:self.productItem, self.allUserList, nil];
    [self performSegueWithIdentifier:segueShowAddReviewController sender:data];
}

# pragma mark - Data query

- (void) getReviewDataByProduct
{
    self.recentReviewList= nil;
    
    NSDictionary* filter = @{
                             @"productID":@{
                                     @"__type"      :   @"Pointer",
                                     @"className"   :   @"Product",
                                     @"objectId"    :   self.productItem.ID
                                     },
                             };
    void (^reviewListResultHandler)(NSArray<id>* result) = ^(NSArray<id>* result) {
        
        self.recentReviewList = [[NSMutableArray<Review> alloc] initWithArray:result];
        
        NSLog(@"Recent Reviews count=%ld", (unsigned long)[self.recentReviewList count]);
        
        if (!self.allUserList || [self.allUserList count] == 0)
        {
            [self getAllUsers];
        }
        else
        {
            [self updateReviewList];
            [self.loadingIcon stopAnimating];
        }
    };
    
    void (^reviewListFailureHandler)(NSError* err) = ^(NSError* err){
        NSLog(@"Reviews failure returned");
        [self.loadingIcon stopAnimating];
    };
    
    [self.loadingIcon startAnimating];
    
    // all reviews
    [[ServiceAPI serviceAPI] getDataByType:DATA_REVIEW parameters:filter completion:reviewListResultHandler fail:reviewListFailureHandler];
}

- (void) updateReviewList
{
    if (!self.recentReviewList)
    {
        NSLog(@"%s WARNING: no recentReviewList found", __FUNCTION__);
        return;
    }
    
    // Update UserName for each review item
    for (Review* review in self.recentReviewList)
    {
        for (User* user in self.allUserList)
        {
            if ([review.UserID isEqual:user.ID])
            {
                review.UserName = user.Name;
            }
        }
    }

    [self.reviewColletionView reloadData];
}

- (void) getAllUsers
{
    self.allUserList = Nil;
 
    void (^userListResultHandler)(NSArray<id>* result) = ^(NSArray<id>* result) {
        
        self.allUserList = [[NSMutableArray<User> alloc] initWithArray:result];
        
        NSLog(@"All Users count=%ld", (unsigned long)[self.allUserList count]);
        
        [self updateReviewList];
        [self.loadingIcon stopAnimating];
    };
    
    void (^userListFailureHandler)(NSError* err) = ^(NSError* err){
        NSLog(@"Users failure returned");
        [self.loadingIcon stopAnimating];
    };

    // all users
    [[ServiceAPI serviceAPI] getDataByType:DATA_USER parameters:nil completion:userListResultHandler fail:userListFailureHandler];
}

# pragma mark - Overriden View controller

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Back button on the left of nativegation bar
    UIButton* backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back-icon.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBarButton;

    // Add review button on the right of nativegation bar
    UIButton* addBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [addBtn setBackgroundImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addReview:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:addBtn];
    self.navigationItem.rightBarButtonItem = rightBarButton;

    [self.productName setText:self.productItem.Name];
    [self.productDescription setText:self.productItem.Description];
    [self.brandName setText:[NSString stringWithFormat:@"Band: %@", self.brandItem.Name]];
    [self.recentViewLabel setText:[NSString stringWithFormat:@"Recent Reviews (%lu)", (unsigned long)[self.recentReviewList count]]];
    
    NSLog(@"product: %@", _productItem.Name);
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"product: %@", _productItem.Name);

    // reloadData recentReviewList which might be added by users
    [self getReviewDataByProduct];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // more
    
}

# pragma mark - Collection view delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    [self.recentViewLabel setText:[NSString stringWithFormat:@"Recent Reviews (%lu)", (unsigned long)[self.recentReviewList count]]];

    NSLog(@"%s items count=%ld", __FUNCTION__, (unsigned long)[_recentReviewList count]);
    return [self.recentReviewList count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ReviewItemCell* cell = (ReviewItemCell*)[collectionView dequeueReusableCellWithReuseIdentifier:reviewItemCellReuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = (indexPath.section %2 ==0 ? [UIColor colorWithRed:10.0f/255.0f green:10.0f/255.0f blue:10.0f/255.0f alpha:0.2f] : [UIColor whiteColor]);
    
    
    Review* reviewItem = [self.recentReviewList objectAtIndex:indexPath.section];
    [cell.userName setText:reviewItem.UserName];
    [cell.dateComment setText:reviewItem.Date];
    [cell.comment setText:reviewItem.Comment];

    [cell.ratingView setValue:[reviewItem.Rate floatValue]];
    
    //NSLog(@"%s ReviewItemCell %@, %@", __FUNCTION__, reviewItem.Comment, reviewItem.Rate);
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize cellSize = CGSizeMake(collectionView.frame.size.width - 4, 60);
    //NSLog(@"sizeForItemAtIndexPath: cellSize = %@  view: frame=%@ bounds=%@", NSStringFromCGSize(cellSize), NSStringFromCGRect(collectionView.frame), NSStringFromCGRect(collectionView.bounds));
    return cellSize;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self.reviewColletionView.collectionViewLayout invalidateLayout];
}

# pragma mark - Segue

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:segueShowAddReviewController]){
        
        AddReviewController *nextController = segue.destinationViewController;
        [nextController setTitle:@"Add Review"];
        
        Product* product = (Product*)[(NSArray*) sender objectAtIndex:0];
        NSMutableArray<User>* userList = (NSMutableArray<User>*)[(NSArray*) sender objectAtIndex:1];
        [nextController setProductItem:product];
        [nextController setAllUserList:userList];
    }
}

@end
