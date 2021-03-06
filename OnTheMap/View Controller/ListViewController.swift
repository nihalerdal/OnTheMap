//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Nihal Erdal on 5/28/21.
//

import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var refreshButton: UIBarButtonItem!

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        
        UdacityClient.getStudentLocations { studentlocationresults, error in
            
            if error == nil {
                Student.locations = studentlocationresults
                self.tableView.reloadData()
                
            } else {
                let alert = UIAlertController(title: "Error", message: "Data couldn't load", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func addLocation(_ sender: Any) {
        if UdacityClient.User.createdAt == "" {
            performSegue(withIdentifier: "AddStudentFromList", sender: nil)
        }else{
            showAlert()
        }
    }
    
    @IBAction func refresh(_ sender: Any) {
        
        refreshButton.isEnabled = false
        UdacityClient.getStudentLocations { studentlocationresults, error in
            Student.locations = studentlocationresults
            self.tableView.reloadData()
        }
        refreshButton.isEnabled = true
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
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Student.locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as? LocationTableViewCell else {
            fatalError("error")
            
        }
        let student = Student.locations[indexPath.row]
            cell.textLabel?.text = "\(student.firstName)" + " " + "\(student.lastName)"
            cell.detailTextLabel?.text = "\(student.mediaURL)"
        
       return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let student = Student.locations[indexPath.row]
        guard let url = URL(string: student.mediaURL) else {return}
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        
    }
    
    
    func showAlert(){
        let alert = UIAlertController(title: "Warning", message: "You have already posted a student location.Would you like to overwrite your current location?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Overwrite", style: .default) { action in
            if let vc = self.storyboard?.instantiateViewController(identifier: "AddLocationViewController") as? AddLocationViewController { // -- performsegue de ayni sekilde calisir mi ? yoksa baslangic noktasi farkli diye sacmalar mi segue ile buranin tetikleyicisi, -> + butonundan segue yi kaldirdim yoksa if i gormedi.
                vc.loadView()
                self.tabBarController?.tabBar.isHidden = true
                vc.linkTextField.text = UdacityClient.User.link
                vc.locationTextField.text = UdacityClient.User.location
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

}
