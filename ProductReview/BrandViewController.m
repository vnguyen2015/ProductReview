//
//  BrandViewController.m
//  ProductReview
//
//  Created by nxvinh@gmail.com on 6/1/16.
//  Copyright © 2016 vnguyen2015. All rights reserved.
//

#import "BrandViewController.h"
#import "ServiceAPI.h"
#import "BrandItemCell.h"
#import "ProductViewController.h"


@interface BrandViewController()
{
    NSMutableArray<Brand>* resultList;// actual list to display data
}

@property NSMutableArray<Brand>* brandList;

@end

@implementation BrandViewController


static NSString* brandItemCellIdentifier = @"BrandItemCell";
static NSString* segueShowProductViewController = @"showProductViewController";


- (void) showAlertViewWhenNoData: (NSString*) reason
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Not found data"  message:reason  preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)loadData
{
    NSLog(@"%s enter ", __FUNCTION__);

    ServiceAPI* api = [ServiceAPI serviceAPI];
    
    self.brandList = nil;
    resultList = nil;
    
    void (^completeBlock)(NSArray<id>* result);
    void (^failBlock)(NSError* err);

    completeBlock = ^(NSArray<id>* result) {
        [self.loadDataActivity stopAnimating];
    
        self.brandList = [[NSMutableArray<Brand> alloc] initWithArray:result];
        resultList =  [[NSMutableArray<Brand> alloc] initWithArray:result];
        NSLog(@"Nrand list returned count=%ld", (unsigned long)[self.brandList count]);
        
        //NSLog(@"response details: %@", self.brandList);
        //dispatch_async(dispatch_get_main_queue(), ^{
        [self.brandCollectionView reloadData];
        //});
    
        if (!result || [result count] == 0)
        {
            [self showAlertViewWhenNoData:@"There is no brand was found!"];
        }
    };
    
    failBlock = ^(NSError* err){
        NSLog(@"failure returned");
        [self.loadDataActivity stopAnimating];
        [self showAlertViewWhenNoData:[err localizedDescription]];
    };
    

    [self.loadDataActivity startAnimating];

    // all brands
    [api getDataByType:DATA_BRAND parameters:nil completion:completeBlock fail:failBlock];

    NSLog(@"%s end ", __FUNCTION__);
}

- (void)loadView
{
    [super loadView];

    // more
    NSLog(@"%s enter ", __FUNCTION__);
    [self loadData];
//    dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    
//    dispatch_async(aQueue, ^{
//        [self loadData];
//    });
    NSLog(@"%s end ", __FUNCTION__);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // more
    resultList = [[NSMutableArray<Brand> alloc] init];

    [self setTitle:@"Brand"];
    NSLog(@"%s enter ", __FUNCTION__);
    
    //self.brandCollectionView be
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // more
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // more
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    // more
}


#pragma mark - DataSource Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if ([collectionView isEqual:self.brandCollectionView])
    {
        return [resultList count];
    }

    NSLog(@"%s ERROR: collectionView unknown %p", __FUNCTION__, collectionView);
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([collectionView isEqual:self.brandCollectionView])
    {
        return 1;
    }
    
    NSLog(@"%s ERROR: collectionView unknown %p", __FUNCTION__, collectionView);
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    if ([collectionView isEqual:self.brandCollectionView])
    {
        BrandItemCell* cell = (BrandItemCell*)[collectionView dequeueReusableCellWithReuseIdentifier:brandItemCellIdentifier forIndexPath:indexPath];
        cell.backgroundColor = (indexPath.section %2 ==0 ? [UIColor colorWithRed:40.0f/255.0f green:40.0f/255.0f blue:40.0f/255.0f alpha:0.1f] : [UIColor whiteColor]);
        
        Brand* brandItem = [resultList objectAtIndex:indexPath.section];

        // TODO: UIImageView to load brand icon if any
        //UIImageView* icon = (UIImageView*) [cell viewWithTag:BRAND_ITEM_IMAGE_VIEW_TAG];
        //icon setImage:
        
        // Brand Name
        [cell.brandName setText:brandItem.Name];

        // Brand Description
        [cell.brandDescription setText:brandItem.Description];
        
        NSLog(@"%s, indexPath=(section=%ld,row=%ld)", __FUNCTION__, (long)indexPath.section, (long)indexPath.row);
        return cell;
    }

//    NSLog(@"ERROR: collectionView unknown %p", collectionView);
//    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize cellSize = CGSizeMake(collectionView.frame.size.width - 4, 60);
   // NSLog(@"sizeForItemAtIndexPath: cellSize = %@  view: frame=%@ bounds=%@", NSStringFromCGSize(cellSize), NSStringFromCGRect(collectionView.frame), NSStringFromCGRect(collectionView.bounds));
    return cellSize;
}

# pragma mark - Search Bar

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [resultList removeAllObjects];
    if (searchText.length > 0) {
        
        // search and reload data source
        for (Brand* brand in self.brandList)
        {
            if ([brand.Name rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound)
            {
                [resultList addObject:brand];
                //NSLog(@"FOUND %@ -> %@ in brandList", searchText, brand.Name);
            }
        }
    }
    else
    {
        [resultList addObjectsFromArray:self.brandList];
        NSLog(@"Search Bar contains nothing.");
    }
    
    [self.brandCollectionView reloadData];
    //NSLog(@"Reload the collection view.");
}

# pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:segueShowProductViewController]){
        
        ProductViewController *nextController = segue.destinationViewController;
        [nextController setTitle:@"Product list"];
        [nextController setBrandItem:(Brand *)sender];
    }
}

# pragma mark - View Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Brand* brandItem = [resultList objectAtIndex:indexPath.section];
    NSLog(@"current selected idx %ld, item name %@", (long)indexPath.section, brandItem.Name);

    [self performSegueWithIdentifier:segueShowProductViewController sender:brandItem];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self.brandCollectionViewLayout invalidateLayout];
}
@end
