//
//  GCViewController.h
//  Geocoder
//
//  Created by dev27 on 5/27/13.
//  Copyright (c) 2013 codigator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
//1
@interface GCViewController : UIViewController <UITextFieldDelegate, MKMapViewDelegate,CLLocationManagerDelegate> {


CLLocationManager *locationManager;
CLLocation *location;
CLPlacemark *placemark;
CLLocationCoordinate2D coordinate;
    MKPointAnnotation *annotationPoint;
    //IBOutlet MKMapView *pMapView;


    
}

@end
