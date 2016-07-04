//
//  BrandItemCell.h
//  ProductReview
//
//  Created by nxvinh@gmail.com on 6/2/16.
//  Copyright © 2016 vnguyen2015. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrandItemCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *brandName;
@property (weak, nonatomic) IBOutlet UILabel *brandDescription;

@end
