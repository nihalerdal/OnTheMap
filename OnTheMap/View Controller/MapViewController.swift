//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Nihal Erdal on 5/28/21.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var students : [StudentLocation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        data that you can download from parse.
        UdacityClient.getStudentLocations { studentlocationresults, error in
            self.students = studentlocationresults
        }
        
//        The point annotations will be stored in this array, and then provided to the map view.
        var annotations = [MKPointAnnotation]()
        
        // The "student" array is loaded with the sample data below. We are using the dictionaries
        // to create map annotations. This would be more stylish if the dictionaries were being
        // used to create custom structs. Perhaps StudentLocation structs.
        for student in students {
            
            let lat = CLLocationDegrees(student.latitude )
            let long = CLLocationDegrees(student.longitude)
            
            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D( latitude:lat, longitude: long)
            annotation.title = "\(student.firstName)" + "" + "\(student.lastName)"
            annotation.subtitle = student.mediaURL
            
            // Finally we place the annotation in an array of annotations.
            annotations.append(annotation)
            self.mapView.addAnnotation(annotation)
        }
        
//        When the array is complete, we add the annotations to the map.

//        self.mapView.addAnnotation(annotations)
    }
    
    // MARK: - MKMapViewDelegate

    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        
        if  pinView == nil {
            pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            pinView?.tintColor = .red
            pinView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }else{
            pinView?.annotation = annotation
        }
        return pinView
    }
    
    
    
    
    @IBAction func addLocation(_ sender: Any) {
    }
    
    
    @IBAction func refreshData(_ sender: Any) {
    }
    
    @IBAction func logOut(_ sender: Any) {
    }
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

