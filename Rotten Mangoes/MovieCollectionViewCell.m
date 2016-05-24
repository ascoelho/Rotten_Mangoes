//
//  MovieCollectionViewCell.m
//  Rotten Mangoes
//
//  Created by Anthony Coelho on 2016-05-23.
//  Copyright © 2016 Anthony Coelho. All rights reserved.
//

#import "MovieCollectionViewCell.h"
#import "MapViewController.h"

@implementation MovieCollectionViewCell


- (void)configureCell:(MovieCollectionViewCell *)cell atIndex:(NSIndexPath *)indexPath withReviews:(NSArray *)reviews {
    
    UILabel *yearLabel = (UILabel *)[cell viewWithTag:4];
    UILabel *ratingLabel = (UILabel *)[cell viewWithTag:5];
    UILabel *synopsisLabel = (UILabel *)[cell viewWithTag:6];
    synopsisLabel.numberOfLines = 0;
    UILabel *reviewsLabel = (UILabel *)[cell viewWithTag:7];
    reviewsLabel.numberOfLines = 0;
    
    yearLabel.text = [NSString stringWithFormat:@"Year: %@",[self.movie releaseYear]];
    ratingLabel.text = [NSString stringWithFormat:@"Rated: %@",[self.movie mpaaRating]];
    synopsisLabel.text = [NSString stringWithFormat:@"Synopsis: %@",[self.movie synopsis]];
    
    NSMutableString *reviewsString = [NSMutableString new];
    for (int i = 0; i < reviews.count; i++) {
        [reviewsString appendString:[NSString stringWithFormat:@"Review %d: %@\n\n",i+1, [reviews[i] objectForKey:@"quote"]]];
    }
    reviewsLabel.text = reviewsString;
    
    UIView *backView = (UIView *)[cell viewWithTag:3];
    
    [UIView transitionWithView:cell.contentView
                      duration:1.0
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations: ^{
                        
                        if (backView.hidden == YES) {
                            backView.hidden = NO;
                            
                            [cell.contentView addSubview:backView];
                            
                        }
                        else {
                            backView.hidden = YES;
                            
                        }
                        
                    }
                    completion:NULL];
    
}

@end
