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
#import "MapViewController.h"

@interface MovieCollectionViewController ()

@property (strong, nonatomic) NSArray *objects;
@property (strong, nonatomic) NSIndexPath *currentCellIndexPath;

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

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    MovieCollectionViewCell *cell = (MovieCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    cell.movie = self.objects[indexPath.row];
    self.currentCellIndexPath = indexPath;
    
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
                   
                    [cell configureCell:cell atIndex:indexPath withReviews:reviews];
                   
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


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showMapVC"]) {
        
        
        MapViewController *mapVC = (MapViewController*)[segue destinationViewController];
        mapVC.movie = self.objects[self.currentCellIndexPath.row];
        
    }
}




@end
