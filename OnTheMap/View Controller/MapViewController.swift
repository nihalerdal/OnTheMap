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
        showPins()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        showPins()
    }
    
    func showPins(){
//        data that you can download from parse.
             UdacityClient.getStudentLocations { studentlocationresults, error in
                 self.students = studentlocationresults
                 
                 //        The point annotations will be stored in this array, and then provided to the map view.
                 var annotations = [MKPointAnnotation]()
                 
                 // The "student" array is loaded with the sample data below. We are using the dictionaries
                 // to create map annotations. This would be more stylish if the dictionaries were being
                 // used to create custom structs. Perhaps StudentLocation structs.
                 for student in self.students {
                     
                    let lat = CLLocationDegrees(student.latitude )
                    let long = CLLocationDegrees(student.longitude)
                    
                    // Here we create the annotation and set its coordiate, title, and subtitle properties
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2D( latitude:lat, longitude: long)
                    annotation.title = "\(student.firstName)" + " " + "\(student.lastName)"
                    annotation.subtitle = student.mediaURL
                    
                    // Finally we place the annotation in an array of annotations.
                    annotations.append(annotation)
                    self.mapView.addAnnotation(annotation)
                 }
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
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if  pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            pinView?.tintColor = .red
            pinView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }else{
            pinView?.annotation = annotation
        }
        return pinView
    }
    
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView{
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle!{
                app.canOpenURL(URL(string: toOpen)!)
            }
            
        }
        
    }
    
    func showAlert(){
        let alert = UIAlertController(title: "Warning", message: "You have already posted a student location.Would you like to overwrite your current location?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Overwrite", style: .default) { action in
            if let vc = self.storyboard?.instantiateViewController(identifier: "AddLocationViewController") as? AddLocationViewController { // -- performsegue de ayni sekilde calisir mi ? yoksa baslangic noktasi farkli diye sacmalar mi segue ile buranin tetikleyicisi -> + butonundan segue yi kaldirdim yoksa if i gormedi.
//                vc.linkTextField.text = UdacityClient.User.link
//                vc.locationTextField.text = UdacityClient.User.location
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else{
                fatalError("alert error")
            }
        }
        
        let okACtion2 = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(okACtion2)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func addLocation(_ sender: Any) {
        if UdacityClient.User.createdAt == "" {
            performSegue(withIdentifier: "AddStudentFromMapView", sender: nil)
        }else{
            showAlert()
        }
    }
    
    
    @IBAction func refreshData(_ sender: Any) {
        showPins()
    }
    
    @IBAction func logOut(_ sender: Any) {
        UdacityClient.logout { success, error in
            if success{
                self.dismiss(animated: true, completion: nil)
                print("logged out")
            }else {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Failed", message: "Could not log out. Try again", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
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

