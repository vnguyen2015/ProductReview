//
//  ProductViewController.m
//  ProductReview
//
//  Created by nxvinh@gmail.com on 5/31/16.
//  Copyright © 2016 vnguyen2015. All rights reserved.
//

#import "ProductViewController.h"
#import "HCSStarRatingView.h"
#import "DetailViewController.h"

@interface ProductViewController ()
{
    NSMutableArray<Product> *resultList;
}

@property NSMutableArray<Product> *productList;
@property NSMutableArray<Review> *reviewList;

@end

@implementation ProductViewController

static NSString* productItemCellReuseIdentifier = @"ProductItemCell";
static NSString* segueShowDetaiViewController = @"showDetailViewController";

#pragma mark - view actions
- (void) goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void) showAlertViewWhenNoData: (NSString*) reason
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Not found data"  message:reason  preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }]];

    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Service data request
- (void) calculateAverageReview
{
    NSLog(@"%s enter", __FUNCTION__);
    if (!self.productList)
    {
        NSLog(@"%s WARNING: no productList found", __FUNCTION__);
        return;
    }
    
    for (Product* product in self.productList)
    {
        float sumOfRatings = 0;
        NSUInteger count = 0;

        for (Review* review in self.reviewList)
        {
            if (review.UserID != Nil && review.ProductID!=Nil && [review.ProductID isEqual:product.ID])
            {
                sumOfRatings += [review.Rate floatValue];
                count++;
            }
        }
        product.averageRating = [[NSNumber alloc] initWithFloat:(count > 0 ? sumOfRatings/count : 0)];
    }

    [self.productCollectionView reloadData];
    NSLog(@"%s end", __FUNCTION__);
}

- (void) getProductsByBrand:(Brand*)brandItem //dispatchGroup:(dispatch_group_t)taskGroup
{
    NSLog(@"%s enter", __FUNCTION__);
    self.productList = nil;
    resultList = nil;
    
    NSDictionary* filter = @{
                             @"brandID":@{
                                     @"$inQuery":@{
                                             @"where":@{
                                                     @"name":brandItem.Name},
                                             @"className":@"Brand"
                                             }
                                     },
                             };

    void (^productListResultHandler)(NSArray<Product>* result) = ^(NSArray<Product>* result) {
        self.productList = [[NSMutableArray<Product> alloc] initWithArray:result];
        resultList = [[NSMutableArray<Product> alloc] initWithArray:result];
        NSLog(@"Product List count=%ld", (unsigned long)[self.productList count]);
        
        // query all review items
        [self getAllReviews];

        [self.productCollectionView reloadData];

        if ([self.productList count] == 0)
        {
            [self showAlertViewWhenNoData:@"There is no product in the selected brand"];
        }
       // dispatch_group_leave(taskGroup);
    };
    
    void (^productListFailureHandler)(NSError* err) = ^(NSError* err){
        NSLog(@"Product failure returned");
        [self.loadingIcon stopAnimating];
        
        [self showAlertViewWhenNoData:[err localizedDescription]];
        //dispatch_group_leave(taskGroup);
    };

   // dispatch_group_enter(taskGroup);
    [self.loadingIcon startAnimating];
    [[ServiceAPI serviceAPI] getDataByType:DATA_PRODUCT parameters:filter completion:productListResultHandler fail:productListFailureHandler];
}

- (void) getAllReviews//: (dispatch_group_t)taskGroup
{
    NSLog(@"%s enter", __FUNCTION__);
    self.reviewList = nil;

    void (^reviewListResultHandler)(NSArray<id>* result) = ^(NSArray<id>* result) {
        self.reviewList = [[NSMutableArray<Review> alloc] initWithArray:result];

        NSLog(@"All Reviews count=%ld", (unsigned long)[self.reviewList count]);
        
        [self calculateAverageReview];
        [self.loadingIcon stopAnimating];
      //  dispatch_group_leave(taskGroup);
    };

    void (^reviewListFailureHandler)(NSError* err) = ^(NSError* err){
        NSLog(@"Reviews failure returned");
        [self.loadingIcon stopAnimating];
        //dispatch_group_leave(taskGroup);
    };

   // [self.loadingIcon startAnimating];
    
    //dispatch_group_enter(taskGroup);
    // all reviews
    [[ServiceAPI serviceAPI] getDataByType:DATA_REVIEW parameters:nil completion:reviewListResultHandler fail:reviewListFailureHandler];

}

#pragma mark - Overiden functions from UIViewCOntrollers
- (void) loadView
{
    [super loadView];
    
    // query product list by brand
    [self getProductsByBrand:self.brandItem];
//    NSLog(@"%s enter", __FUNCTION__);

// //   dispatch_queue_t currentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_group_t taskGroup = dispatch_group_create();
//    
//    [self getProductsByBrand:self.brandItem dispatchGroup:taskGroup];
//    [self getAllReviews:taskGroup];
//    
//    dispatch_group_notify(taskGroup, dispatch_get_main_queue(), ^{
//        [self calculateAverageReview];
//        //dispatch_sync(dispatch_get_main_queue(), ^{
//            NSLog(@"%s finally reloadData", __FUNCTION__);
//            [self.productCollectionView reloadData];
//            [self.loadingIcon stopAnimating];
//        //});
//    });
//    
//    [self.loadingIcon startAnimating];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Back button on the left of nativegation bar
    UIButton* backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back-icon.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBarButton;

    NSLog(@"%s BrandItem = %@", __FUNCTION__, self.brandItem.Name);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // more
    
}

#pragma mark - Data source colletion view and relayout

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [resultList count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1; // Display one product item in the section
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProductItemCell* cell = (ProductItemCell*)[collectionView dequeueReusableCellWithReuseIdentifier:productItemCellReuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = (indexPath.section %2 ==0 ? [UIColor colorWithRed:20.0f/255.0f green:20.0f/255.0f blue:20.0f/255.0f alpha:0.1f] : [UIColor whiteColor]);
    
    Product* productItem = [resultList objectAtIndex:indexPath.section];
    UILabel* productItemName = cell.productName;

    [productItemName setText:productItem.Name];

    UILabel* productBrandName = cell.productBrandName;
    [productBrandName setText:self.brandItem.Name];
 
    HCSStarRatingView* ratingView = cell.ratingView;
    float rate = [productItem.averageRating floatValue];// *5/10;
    [ratingView setValue:rate];
    
    UILabel* score = cell.rateScore;
    [score setText:[NSString stringWithFormat:@"%0.1f", rate]];

    //NSLog(@"%s ProductItemCell %@, %@", __FUNCTION__, productItem.Name, productItem.averageRating);
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize cellSize = CGSizeMake(collectionView.frame.size.width - 4, 72);
    //NSLog(@"sizeForItemAtIndexPath: cellSize = %@  view: frame=%@ bounds=%@", NSStringFromCGSize(cellSize), NSStringFromCGRect(collectionView.frame), NSStringFromCGRect(collectionView.bounds));
    return cellSize;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

    [self.productCollectionView.collectionViewLayout invalidateLayout];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:segueShowDetaiViewController])
    {
        DetailViewController *nextController = segue.destinationViewController;
        [nextController setTitle:@"Product Detail"];
        
        // enhance
//        NSArray <NSIndexPath *> *indexPaths = [[self productCollectionView] indexPathsForSelectedItems];
//        for (NSIndexPath* indexPath in indexPaths)
//        {
//            NSLog(@"%s: %@", __FUNCTION__, indexPath);
//        }

        Product* product = (Product*)[(NSArray*) sender objectAtIndex:0];
//        Brand* brand = (Brand*)[(NSArray*) sender objectAtIndex:1];
//        NSIndexPath *indexPath = [indexPaths objectAtIndex:0];
//        Product* product = [resultList objectAtIndex:indexPath.section];

        [nextController setProductItem:product];
        [nextController setBrandItem:self.brandItem];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Product* productItem = [resultList objectAtIndex:indexPath.section];
    NSLog(@"current selected idx %ld, item name %@", (long)indexPath.section, productItem.Name);
    NSArray* data = [[NSArray alloc] initWithObjects:productItem, _brandItem, nil];
    [self performSegueWithIdentifier:segueShowDetaiViewController sender:data];
}

#pragma mark - search bar
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [resultList removeAllObjects];
    if (searchText.length > 0)
    {
        // search and reload data source
        for (Product* product in self.productList)
        {
            if ([product.Name rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound)
            {
                [resultList addObject:product];
                //NSLog(@"FOUND %@ -> %@ in productList", searchText, product.Name);
            }
        }
    }
    else
    {
        [resultList addObjectsFromArray:self.productList];
        NSLog(@"Search Bar contains nothing.");
    }
    
    [self.productCollectionView reloadData];
    //NSLog(@"Reload the collection view.");
}

@end
