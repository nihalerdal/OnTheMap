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
    
    var link : String = ""
    var location : String = ""
    var latitude : Double = 0.0
    var longitude: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func finishTapped(_ sender: Any) {
        UdacityClient.getUserData(completion: handleGetUserData(firstName:lastName:error:))
  
    }
    
    func handleGetUserData(firstName: String?, lastName: String?, error: Error?){
        if error == nil{
            UdacityClient.postLocation(firstName: firstName ?? "", lastName: lastName ?? "", mapString: location, mediaURL: link, latitude: latitude, longitude: longitude, completion: handlePostLocation(success:error:))
        }
    }
    
    
    func handlePostLocation(success: Bool, error: Error?){
        if success {
            dismiss(animated: true, completion: nil)
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
