//
//  MovieCollectionViewController.m
//  Rotten Mangoes
//
//  Created by Anthony Coelho on 2016-05-23.
//  Copyright © 2016 Anthony Coelho. All rights reserved.
//

#import "MovieCollectionViewController.h"
#import "MovieCollectionViewCell.h"
#import "Movie.h"
#import "CoverFlowLayout.h"

@interface MovieCollectionViewController ()

@property (strong, nonatomic) NSArray *objects;

@end

@implementation MovieCollectionViewController

static NSString * const reuseIdentifier = @"MovieCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    NSURL *rottenTomatoesURL = [NSURL URLWithString:@"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json?apikey=sr9tdu3checdyayjz85mff8j&page_limit=50"];
    NSURLRequest *apiRequest = [NSURLRequest requestWithURL:rottenTomatoesURL];
    
    NSURLSession *sharedSession = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *apiTask = [sharedSession dataTaskWithRequest:apiRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSLog(@"completed response");
        
        if (!error) {
            NSError *jsonError;
            
    
            NSDictionary *parsedData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            
            if (!jsonError) {
                //NSLog(@"%@", parsedData);
                
                NSArray *moviesArray = parsedData[@"movies"];
                NSMutableArray *tempArray = [NSMutableArray array];
                
                for (NSDictionary *inTheatreMovieDict in moviesArray) {
                    
                    Movie *newMovie = [[Movie alloc] initWithDictionary:inTheatreMovieDict];

                    [tempArray addObject:newMovie];
                }
                
                self.objects = tempArray;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.collectionView reloadData];
                });
                
            } else {
                NSLog(@"Error parsing JSON: %@", [jsonError localizedDescription]);
            }
            
            
        } else {
            NSLog(@"%@", [error localizedDescription]);
        }
        
    }];
    
    //NSLog(@"Before resume");
    [apiTask resume];
    //NSLog(@"After resume");
    

}





#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.objects.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MovieCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    UIImageView *movieImageView = (UIImageView *)[cell viewWithTag:1];
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:2];
    UIView *backView = (UIView *)[cell viewWithTag:3];
    backView.hidden = YES;
        

    
    // Configure the cell
    titleLabel.text = [self.objects[indexPath.row] title];
    movieImageView.image = (UIImage *)[self.objects[indexPath.row] image];
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    MovieCollectionViewCell *cell = (MovieCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    NSURL *rottenTomatoesURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?apikey=sr9tdu3checdyayjz85mff8j&page_limit=3",[self.objects[indexPath.row] reviewsURL]]];
    
    NSURLRequest *apiRequest = [NSURLRequest requestWithURL:rottenTomatoesURL];
    
    NSURLSession *sharedSession = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *apiTask = [sharedSession dataTaskWithRequest:apiRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSLog(@"completed response");
        
        if (!error) {
            NSError *jsonError;
            
            
            NSDictionary *parsedData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            
            if (!jsonError) {
                

                NSArray *reviews = parsedData[@"reviews"];

                dispatch_async(dispatch_get_main_queue(), ^{
                    [self configureCell:cell atIndex:indexPath withReviews:reviews];
                    //[self.collectionView reloadData];
                });
                
            } else {
                NSLog(@"Error parsing JSON: %@", [jsonError localizedDescription]);
            }
    
        } else {
            NSLog(@"%@", [error localizedDescription]);
        }
        
    }];
    

    [apiTask resume];

    

    

    


}


- (void)configureCell:(MovieCollectionViewCell *)cell atIndex:(NSIndexPath *)indexPath withReviews:(NSArray *)reviews {
    
    UILabel *yearLabel = (UILabel *)[cell viewWithTag:4];
    UILabel *ratingLabel = (UILabel *)[cell viewWithTag:5];
    UILabel *synopsisLabel = (UILabel *)[cell viewWithTag:6];
    synopsisLabel.numberOfLines = 0;
    UILabel *reviewsLabel = (UILabel *)[cell viewWithTag:7];
    reviewsLabel.numberOfLines = 0;
    
    yearLabel.text = [NSString stringWithFormat:@"Year: %@",[self.objects[indexPath.row] releaseYear]];
    ratingLabel.text = [NSString stringWithFormat:@"Rated: %@",[self.objects[indexPath.row] mpaaRating]];
    synopsisLabel.text = [NSString stringWithFormat:@"Synopsis: %@",[self.objects[indexPath.row] synopsis]];
    
    NSMutableString *reviewsString = [NSMutableString new];
    for (int i = 0; i < reviews.count; i++) {
        [reviewsString appendString:[NSString stringWithFormat:@"Review %d: %@\n\n",i+1, [reviews[i] objectForKey:@"quote"]]];
    }
    reviewsLabel.text = reviewsString;
    
    UIImageView *movieImageView = (UIImageView *)[cell viewWithTag:1];
    UIView *backView = (UIView *)[cell viewWithTag:3];
    
    [UIView transitionWithView:movieImageView
                      duration:1.0
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations: ^{
                        
                        if (backView.hidden == YES) {
                            backView.hidden = NO;
                            [movieImageView addSubview:backView];
                        }
                        else {
                            backView.hidden = YES;
                            
                        }
                        
                    }
                    completion:NULL];
    
}



@end
