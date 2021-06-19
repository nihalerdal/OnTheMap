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
    var latitude : Double = 0.0
    var longitude : Double = 0.0 // -> (CLLocationCoordinate2D(latitude:Double, logitude: Double))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.tabBar.isHidden = true

    }
    

    @IBAction func findLocationTapped(_ sender: Any) {
        if locationTextField.text == "" || linkTextField.text == "" {
            showAlert()
        }else {
            guard let location = locationTextField.text else {return}
            findGeocode("\(location)")
        }
    }
    
    
    @IBAction func cancel(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    
    func findGeocode(_ address: String) {
        CLGeocoder().geocodeAddressString(address) { (placemark, error)
            in
            if error == nil {
                
                if let placemark = placemark?.first,
                   let location = placemark.location {
                    self.latitude = location.coordinate.latitude
                    self.longitude = location.coordinate.longitude
                    
                    print("Latitude:\(self.latitude), Longitude:\(self.longitude)")
                
                    self.performSegue(withIdentifier: "FindLocationSegue", sender: nil)
                }
                
            }else {
                fatalError("geocode error")
            }
        }
    }
    
    func showAlert(){
        let alert = UIAlertController(title: "Required Fields!", message: "You must provide location and url.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FindLocationSegue"{
            if let mapVC = segue.destination as? FindLocationViewController{
                mapVC.link = linkTextField.text ?? ""
                mapVC.location = locationTextField.text ?? ""
                mapVC.latitude = latitude
                mapVC.longitude = longitude
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
