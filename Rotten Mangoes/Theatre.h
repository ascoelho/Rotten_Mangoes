//
//  Theatre.h
//  Rotten Mangoes
//
//  Created by Anthony Coelho on 2016-05-24.
//  Copyright © 2016 Anthony Coelho. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MapKit;

@interface Theatre : NSObject <MKAnnotation>


@property (assign, nonatomic) CLLocationCoordinate2D coordinate;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *address;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
