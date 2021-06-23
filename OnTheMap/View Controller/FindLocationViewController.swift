//
//  FindLocationViewController.swift
//  OnTheMap
//
//  Created by Nihal Erdal on 5/28/21.
//

import UIKit
import MapKit

class FindLocationViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var finishButton: UIButton!
    
    var link : String = ""
    var location : String = ""
    var latitude : Double = 0.0
    var longitude: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createMapAnnotation()
        tabBarController?.tabBar.isHidden = true

    }
    

    @IBAction func finishTapped(_ sender: Any) {
        if UdacityClient.User.createdAt == "" {
            UdacityClient.getUserData(completion: handleGetUserData(firstName:lastName:error:))
        }else {
            UdacityClient.updateLocation(firstName: UdacityClient.User.firstName, lastName: UdacityClient.User.lastName, mapString: location, mediaURL: link, latitude: latitude, longitude: longitude, completion: handleUpdateLocation(success:error:))
        }
    }
    
    func handleGetUserData(firstName: String?, lastName: String?, error: Error?){
        if error == nil{
            UdacityClient.postLocation(firstName: firstName ?? "", lastName: lastName ?? "", mapString: location, mediaURL: link, latitude: latitude, longitude: longitude, completion: handlePostLocation(success:error:))
        }else{
            print("user data can not be handled.")
        }
    }
    
    
    func handlePostLocation(success: Bool, error: Error?){
        if success {
            dismiss(animated: true, completion: nil)
            UdacityClient.User.location = location
            print(UdacityClient.User.location)
            UdacityClient.User.link = link
            print("student added")
//            dismiss(animated: true, completion: nil)
            navigationController?.popToRootViewController(animated: true)
        }else{
            let alert = UIAlertController(title: "Error", message: "Student could not added. Try again", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            print("student could not be added.")
        }
    }
    
    func handleUpdateLocation(success: Bool, error: Error?){
        if success{
            UdacityClient.User.location = location
            UdacityClient.User.link = link
            print("student updates")
            navigationController?.popToRootViewController(animated: true)
        }else{
            print("student can not be updated.")
        }
    }
    
    func createMapAnnotation(){
        let annotation = MKPointAnnotation()
        annotation.coordinate.latitude = self.latitude
        annotation.coordinate.longitude = self.longitude
        annotation.title = location
        self.mapView.addAnnotation(annotation)
        
        self.mapView.setCenter(annotation.coordinate, animated: true) //--> to place pin the center of the mapView
        let region = MKCoordinateRegion(center: annotation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)) //-> create geographical region display. binalar, parklar vs.
        self.mapView.setRegion(region, animated: true)
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if  pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
        }else{
            pinView?.annotation = annotation
        }
        return pinView
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
