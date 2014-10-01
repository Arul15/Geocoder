//
//  GCViewController.m
//  Geocoder
//
//  Created by dev27 on 5/27/13.
//  Copyright (c) 2013 codigator. All rights reserved.
//
//add mapkit framework, add corelocation
#import "GCViewController.h"

@interface GCViewController ()
@property (weak, nonatomic) IBOutlet UITextField *addressOutlet;
@property (weak, nonatomic) IBOutlet UITextField *cityOutlet;
@property (weak, nonatomic) IBOutlet UITextField *stateOutlet;
@property (weak, nonatomic) IBOutlet UITextField *zipOutlet;
@property (weak, nonatomic) IBOutlet UITextField *placeOutlet;
@property (weak, nonatomic) IBOutlet UITextField *subthroughOutlet;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
//2
@property (strong, nonatomic) CLLocation *selectedLocation;
@property (strong, nonatomic) NSMutableDictionary *placeDictionary;


@end

@implementation GCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  //3
  self.addressOutlet.delegate = self;
  self.cityOutlet.delegate = self;
  self.stateOutlet.delegate =self;
  self.zipOutlet.delegate =self;
  self.mapView.delegate = self;
  //4
    
    
  self.placeDictionary = [[NSMutableDictionary alloc] init];
  CLLocationCoordinate2D zoomLocation;
  zoomLocation.latitude = 40.740848;
  zoomLocation.longitude= -73.991134;
/*  MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 1609.344,1609.344);
  [self.mapView setRegion:viewRegion animated:YES];*/
    
    
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
    
    location = [locationManager location];
    
    // Configure the new event with information from the location
    coordinate = [location coordinate];
    
    coordinate.latitude = locationManager.location.coordinate.latitude;
    NSLog(@"coordinate.latitude %f",coordinate.latitude);
    coordinate.longitude = locationManager.location.coordinate.longitude;
    NSLog(@"coordinate.longitude %f",coordinate.longitude);
    
    annotationPoint = [[MKPointAnnotation alloc] init];
    annotationPoint.coordinate = coordinate;
    annotationPoint.title = @"Current Place";
    annotationPoint.subtitle = @"";
    
    _mapView.showsUserLocation=YES;
    [_mapView addAnnotation:annotationPoint];
    
  
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    @try {
        
        [locationManager stopUpdatingLocation];
        coordinate.latitude = newLocation.coordinate.latitude;
        coordinate.longitude = newLocation.coordinate.longitude;
        [self showAnnotation];
        
        CLLocation *currentLocation = newLocation;
        
        
        // Stop Location Manager
        [locationManager stopUpdatingLocation];
        
        CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
        [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
            NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
            if (error == nil && [placemarks count] > 0) {
                
                placemark = [placemarks objectAtIndex:0];
                
                placemark = [placemarks lastObject];
                //
                /*  NSLog(@"Get current Details %@",[NSString stringWithFormat:@"%@ %@\n%@ %@\n%@\n%@",
                 placemark.subThoroughfare, placemark.thoroughfare,
                 placemark.postalCode, placemark.locality,
                 placemark.administrativeArea,
                 placemark.country]);*/
                
                NSString *pStrCurrentAddress = [NSString stringWithFormat:@"%@ ,%@ ,%@ ,%@ ,%@",
                                                placemark.thoroughfare,placemark.subLocality,placemark.locality,placemark.administrativeArea,placemark.country];
                
                
                
                NSLog(@"name value %@",placemark.name);
                NSLog(@"placemark.thoroughfare %@",placemark.thoroughfare);
                NSLog(@"placemark.subThoroughfare %@",placemark.subThoroughfare);
                NSLog(@"placemark.locality %@",placemark.locality);
                NSLog(@"placemark.subLocality %@",placemark.subLocality);
                NSLog(@"placemark.administrativeArea %@",placemark.administrativeArea);
                NSLog(@"placemark.subAdministrativeArea %@",placemark.subAdministrativeArea);
                NSLog(@"placemark.postalCode %@",placemark.postalCode);
                NSLog(@"placemark.ISOcountryCode %@",placemark.ISOcountryCode);
                NSLog(@"placemark.country %@",placemark.country);
                NSLog(@"placemark.inlandWater %@",placemark.inlandWater);
                NSLog(@"placemark.ocean %@",placemark.ocean);

                
                NSLog(@"pStrCurrentAddress %@",pStrCurrentAddress);
                
                
            } else {
                NSLog(@"~~~~~~~~~~~~ %@", error.debugDescription);
            }
        } ];
    }
    @catch (NSException *exception) {
        
    } @finally {
        
    }
    
}


- (void)showAnnotation
{
	MKCoordinateRegion region;
	region.center = coordinate;
	MKCoordinateSpan span;
	span.latitudeDelta = 0.005;
	span.longitudeDelta = 0.005;
	region.span=span;
	[_mapView setRegion:region animated:TRUE];
	
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}
#pragma mark - Custom Methods

- (void)updatePlaceDictionary {
  //5
  [self.placeDictionary setValue:self.addressOutlet.text forKey:@"Street"];
  [self.placeDictionary setValue:self.cityOutlet.text forKey:@"City"];
  [self.placeDictionary setValue:self.stateOutlet.text forKey:@"State"];
  [self.placeDictionary setValue:self.zipOutlet.text forKey:@"subThoroughfare"];
  [self.placeDictionary setValue:self.zipOutlet.text forKey:@"SubLocality"];
    
}

- (void)updateMaps {
    //6
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressDictionary:self.placeDictionary completionHandler:^(NSArray *placemarks, NSError *error) {
      if([placemarks count]) {
        placemark = [placemarks objectAtIndex:0];
        location = placemark.location;
        coordinate = location.coordinate;
        [self.mapView setCenterCoordinate:coordinate animated:YES];
      } else {
        NSLog(@"error");
      }
    }];

}

- (void)delayedReverseGeocodeLocation {
  //8
  [NSObject cancelPreviousPerformRequestsWithTarget:self];
  
  [self reverseGeocodeLocation];

}

- (void)reverseGeocodeLocation {
  //9
  CLGeocoder *geocoder = [[CLGeocoder alloc] init];
  [geocoder reverseGeocodeLocation:self.selectedLocation completionHandler:^(NSArray *placemarks, NSError *error) {
    //10
      
      
    NSDictionary *dictionary = [[placemarks objectAtIndex:0] addressDictionary];
      
    if(placemarks.count) {
        
      [self.addressOutlet setText:[dictionary valueForKey:@"Street"]];
      [self.cityOutlet setText:[dictionary valueForKey:@"City"]];
      [self.stateOutlet setText:[dictionary valueForKey:@"State"]];
      [self.zipOutlet setText:[dictionary valueForKey:@"subThoroughfare"]];
      [self.placeOutlet setText:[dictionary valueForKey:@"SubLocality"]];
        
        NSLog(@"come here or not");
        
        NSLog(@"name value %@",[dictionary valueForKey:@"name"]);
        NSLog(@"placemark.thoroughfare %@",[dictionary valueForKey:@"thoroughfare"]);
        NSLog(@"placemark.subThoroughfare %@",[dictionary valueForKey:@"subThoroughfare"]);
        NSLog(@"placemark.locality %@",[dictionary valueForKey:@"locality"]);
        NSLog(@"placemark.subLocality %@",[dictionary valueForKey:@"subLocality"]);
        NSLog(@"placemark.administrativeArea %@",[dictionary valueForKey:@"administrativeArea"]);
        NSLog(@"placemark.subAdministrativeArea %@",[dictionary valueForKey:@"subAdministrativeArea"]);
        NSLog(@"placemark.postalCode %@",[dictionary valueForKey:@"postalCode"]);
        NSLog(@"placemark.ISOcountryCode %@",[dictionary valueForKey:@"ISOcountryCode"]);
        NSLog(@"placemark.country %@",[dictionary valueForKey:@"country"]);
        NSLog(@"placemark.inlandWater %@",[dictionary valueForKey:@"inlandWater"]);
        NSLog(@"placemark.ocean %@",[dictionary valueForKey:@"ocean"]);
        NSLog(@"Welcome to india %@",[dictionary valueForKey:@"areasOfInterest"]);
        
    }
  }];

}
#pragma mark - MapView Delegate Methods
//7
-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
  self.selectedLocation =
  [[CLLocation alloc] initWithLatitude:mapView.centerCoordinate.latitude
                             longitude:mapView.centerCoordinate.longitude];
  [self performSelector:@selector(delayedReverseGeocodeLocation)
             withObject:nil
             afterDelay:0.3];
}
#pragma mark - TextField Delegate Methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
  [textField resignFirstResponder];
  return YES;
}
- (IBAction)submitTapped:(id)sender {
  [self updatePlaceDictionary];
  [self updateMaps];
}
@end
