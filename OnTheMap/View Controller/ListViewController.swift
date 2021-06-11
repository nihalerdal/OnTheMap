//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Nihal Erdal on 5/28/21.
//

import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

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
    }
    
    @IBAction func refresh(_ sender: Any) {
        tableView.reloadData()
    }
    
    
    @IBAction func logOut(_ sender: Any) {
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
