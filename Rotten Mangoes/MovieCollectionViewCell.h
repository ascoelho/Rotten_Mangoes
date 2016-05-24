//
//  MovieCollectionViewCell.h
//  Rotten Mangoes
//
//  Created by Anthony Coelho on 2016-05-23.
//  Copyright © 2016 Anthony Coelho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

@interface MovieCollectionViewCell : UICollectionViewCell

@property (nonatomic) UIStoryboard *storyboard;
@property (strong, nonatomic) Movie *movie;

- (void)configureCell:(MovieCollectionViewCell *)cell atIndex:(NSIndexPath *)indexPath withReviews:(NSArray *)reviews;

@end
