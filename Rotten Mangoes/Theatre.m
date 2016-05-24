//
//  Theatre.m
//  Rotten Mangoes
//
//  Created by Anthony Coelho on 2016-05-24.
//  Copyright © 2016 Anthony Coelho. All rights reserved.
//

#import "Theatre.h"

@implementation Theatre

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    
    self = [super init];
    if (self) {
        _title = dict[@"name"];
        _address = dict[@"address"];
        _coordinate = CLLocationCoordinate2DMake([dict[@"lat"] doubleValue], [dict[@"lng"] doubleValue]);
        
    }
    return self;
    
}

@end
