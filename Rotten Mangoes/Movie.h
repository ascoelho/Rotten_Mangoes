//
//  Movie.h
//  Rotten Mangoes
//
//  Created by Anthony Coelho on 2016-05-23.
//  Copyright © 2016 Anthony Coelho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Movie : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSString *releaseYear;
@property (strong, nonatomic) NSString *mpaaRating;
@property (strong, nonatomic) NSString *synopsis;
@property (strong, nonatomic) NSString *reviewsURL;




- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
