//
//  BrandViewController.h
//  ProductReview
//
//  Created by nxvinh@gmail.com on 6/1/16.
//  Copyright © 2016 vnguyen2015. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrandViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *brandCollectionView;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadDataActivity;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *brandCollectionViewLayout;

@end
