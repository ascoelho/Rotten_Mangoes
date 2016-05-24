//
//  MapViewController.m
//  Rotten Mangoes
//
//  Created by Anthony Coelho on 2016-05-24.
//  Copyright © 2016 Anthony Coelho. All rights reserved.
//

#import "MapViewController.h"
#import "Theatre.h"
@import MapKit;

@interface MapViewController () <CLLocationManagerDelegate, MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (assign, nonatomic) BOOL shouldZoomToUserLocation;

@property (strong, nonatomic) NSArray *theatres;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.shouldZoomToUserLocation = YES;
    self.mapView.delegate = self;
    
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = 0;
        
        if ([CLLocationManager authorizationStatus] ==
            kCLAuthorizationStatusNotDetermined) {
            [self.locationManager requestWhenInUseAuthorization];
        }
    }
    
    

}


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        
        [self.locationManager startUpdatingLocation];
        
    } else if (status == kCLAuthorizationStatusDenied) {
        NSLog(@"Access Denied");
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D userCoordinate = location.coordinate;
    //NSLog(@"lat: %f, lng: %f", userCoordinate.latitude, userCoordinate.longitude);
    
    if (self.shouldZoomToUserLocation) {
        self.shouldZoomToUserLocation = NO;
        // Zoom to user's location
        
        MKCoordinateRegion userRegion = MKCoordinateRegionMake(userCoordinate, MKCoordinateSpanMake(0.005, 0.005));
        [self.mapView setRegion:userRegion animated:YES];
        [self.mapView setShowsUserLocation:YES];
      
        
        
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        
        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            CLPlacemark *placemark = placemarks[0];
            
            
            [self findTheatresNearPostalCode:placemark.postalCode];
        }];
        

    }
    
}

- (void)findTheatresNearPostalCode:(NSString *)postalCode {
    
    NSString *urlWithoutSpaces =[[NSString stringWithFormat:@"http://lighthouse-movie-showtimes.herokuapp.com/theatres.json?address=%@&movie=%@", postalCode, self.movie.title]  stringByReplacingOccurrencesOfString:@" " withString:@"%20"];

    
    NSURL *theatresURL = [NSURL URLWithString:urlWithoutSpaces];;
    
    NSURLRequest *apiRequest = [NSURLRequest requestWithURL:theatresURL];
    
    NSURLSession *sharedSession = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *apiTask = [sharedSession dataTaskWithRequest:apiRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSLog(@"completed response");
        
        if (!error) {
            NSError *jsonError;
            
            
            NSDictionary *parsedData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            
            if (!jsonError) {
                
                NSArray *theatres = parsedData[@"theatres"];
                NSMutableArray *tempArray = [NSMutableArray array];

                for (NSDictionary *theatre in theatres) {
                    Theatre *newTheatre = [[Theatre alloc] initWithDictionary:theatre];
                    [tempArray addObject:newTheatre];
                }
            
                self.theatres = tempArray;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self addTheatres];
                    
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

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Error getting location: %@", [error localizedDescription]);
}

- (void)addTheatres {

    
    for (Theatre *theatre in self.theatres) {

        [self.mapView addAnnotation:theatre];
    }

}


@end
