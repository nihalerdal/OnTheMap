//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Nihal Erdal on 5/28/21.
//

import UIKit
import MapKit

class AddLocationViewController: UIViewController {

    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func findLocationTapped(_ sender: Any) {
    }
    
    
    @IBAction func cancel(_ sender: Any) {
    }
    
    
    func findGeocode(_ address: String){
        CLGeocoder().geocodeAddressString(address) { (placemark, error)
            in
            if error == nil {
                
                if let placemark = placemark?.first,
                   let location = placemark.location {
                    let latitude = location.coordinate.latitude
                    let longitude = location.coordinate.longitude
                    
                    print("Latitude:\(latitude), Longitude:\(longitude)")
                    
                }
            }else {
                fatalError("geocode error")
            }
        }
        
    }

    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "FindLocationSegue"{
//            if let mapVC = segue.destination as? FindLocationViewController{
//                let
//            }
//
//        }
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
