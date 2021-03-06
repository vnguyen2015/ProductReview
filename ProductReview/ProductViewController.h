//
//  ProductViewController.h
//  ProductReview
//
//  Created by nxvinh@gmail.com on 5/31/16.
//  Copyright © 2016 vnguyen2015. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceAPI.h"
#import "ProductItemCell.h"

@interface ProductViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property Brand* brandItem;

@property (weak, nonatomic) IBOutlet UICollectionView *productCollectionView;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIcon;

@end
