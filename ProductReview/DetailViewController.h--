//
//  DetailViewController.h
//  ProductReview
//
//  Created by nxvinh@gmail.com on 6/3/16.
//  Copyright © 2016 vnguyen2015. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceAPI.h"

@interface DetailViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>

@property Product* productItem;
@property Brand* brandItem;


@property (weak, nonatomic) IBOutlet UILabel *productName;

@property (weak, nonatomic) IBOutlet UILabel *productDescription;

@property (weak, nonatomic) IBOutlet UILabel *brandName;

@property (weak, nonatomic) IBOutlet UICollectionView *reviewColletionView;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIcon;
@property (weak, nonatomic) IBOutlet UILabel *recentViewLabel;
@end
