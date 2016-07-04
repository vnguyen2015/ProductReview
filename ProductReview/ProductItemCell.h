//
//  ProductItemCell.h
//  ProductReview
//
//  Created by nxvinh@gmail.com on 6/2/16.
//  Copyright © 2016 vnguyen2015. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCSStarRatingView.h"

@interface ProductItemCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *productBrandName;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *ratingView;
@property (weak, nonatomic) IBOutlet UILabel *rateScore;
@end
