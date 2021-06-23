//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Nihal Erdal on 5/28/21.
//

import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var refreshButton: UIBarButtonItem!
    var students = [StudentLocation]()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        
        UdacityClient.getStudentLocations { studentlocationresults, error in
            self.students = studentlocationresults
            self.tableView.reloadData()
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
            self.students = studentlocationresults
            self.tableView.reloadData()
        }
        refreshButton.isEnabled = true
    }
    
    
    @IBAction func logOut(_ sender: Any) {
        UdacityClient.logout { success, error in
            if success{
                self.navigationController?.popToRootViewController(animated: true)
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
        students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as? LocationTableViewCell else {
            fatalError("error")
            
        }
            let student = students[indexPath.row]
            cell.textLabel?.text = "\(student.firstName)" + " " + "\(student.lastName)"
            cell.detailTextLabel?.text = "\(student.mediaURL)"
        
       return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let student = students[indexPath.row]
        guard let url = URL(string: student.mediaURL) else {return}
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        
    }
    
    
    func showAlert(){
        let alert = UIAlertController(title: "Warning", message: "You have already posted a student location.Would you like to overwrite your current location?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Overwrite", style: .default) { action in
            if let vc = self.storyboard?.instantiateViewController(identifier: "AddStudentFromList") as? AddLocationViewController { // -- performsegue de ayni sekilde calisir mi ? yoksa baslangic noktasi farkli diye sacmalar mi segue ile buranin tetikleyicisi, -> + butonundan segue yi kaldirdim yoksa if i gormedi.
                self.navigationController?.pushViewController(vc, animated: true)
                vc.linkTextField.text = UdacityClient.User.link
                vc.locationTextField.text = UdacityClient.User.location
                
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
