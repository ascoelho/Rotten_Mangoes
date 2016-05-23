//
//  Movie.m
//  Rotten Mangoes
//
//  Created by Anthony Coelho on 2016-05-23.
//  Copyright © 2016 Anthony Coelho. All rights reserved.
//

#import "Movie.h"

@implementation Movie

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    
    self = [super init];
    if (self) {
        _title = dict[@"title"];

        _image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dict[@"posters"] objectForKey:@"thumbnail"]]]];
        _releaseYear = [NSString stringWithFormat:@"%@",dict[@"year"]];
        _mpaaRating = dict[@"mpaa_rating"];
        _synopsis = dict[@"synopsis"];
        _reviewsURL = [dict[@"links"] objectForKey:@"reviews"];
        
    }
    return self;
}

@end
