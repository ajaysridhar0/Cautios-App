//
//  OffenderListTableTableViewController.swift
//  Cautios-App
//
//  Created by Ajay Sridhar on 10/31/19.
//  Copyright © 2019 Ajay Sridhar. All rights reserved.
//

import UIKit
import MapViewPlus
import RealmSwift

struct cellData {
    var opened = Bool()
    var title = String()
    var sectionData = [String]()
}

class OffenderListTableViewController: UITableViewController {
    // Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    // Instance variables
    var tableViewData = [cellData]()
    var annotations: [AnnotationPlus] = []
    var searchOffender: [cellData] = []
    let cellId = "cell"
    let realm = try! Realm(configuration: RealmConfig.main.configuration)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Offenders"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
//        offenders = realm.objects(OregonOffenders.self)
        loadTableViewData(offenders: realm.objects(OregonOffenders.self))
        tableView.reloadData()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewData.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableViewData[section].opened {
            return tableViewData[section].sectionData.count + 1
        }
        else {
            return 1
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId) else { return UITableViewCell() }
            cell.textLabel?.text = tableViewData[indexPath.section].title
            cell.backgroundColor = .clear
            return cell
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId) else { return UITableViewCell() }
            cell.textLabel?.text = tableViewData[indexPath.section].sectionData[indexPath.row - 1]
            cell.backgroundColor = .gray
            cell.textLabel?.numberOfLines = 0;
            cell.textLabel?.lineBreakMode = .byWordWrapping
            return cell
        }
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
//        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableViewData[indexPath.section].opened {
            tableViewData[indexPath.section].opened = false
            let sections = IndexSet.init(integer: indexPath.section)
            tableView.reloadSections(sections, with: .none)
        }
        else {
            tableViewData[indexPath.section].opened = true
            let sections = IndexSet.init(integer: indexPath.section)
            tableView.reloadSections(sections, with: .none)
        }
    }
    
    // MARK: - Load the data methods
    func loadTableViewData(offenders: Results<OregonOffenders>?) {
        tableViewData = []
        for offender in offenders! {
            let address = (offender.residenceStreetNumber + " " + offender.residenceStreetName + " " + offender.residenceCity + ", " + offender.residenceState + " " + String(offender.residenceZip)).uppercased()
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "MM/dd/yyyy"
            guard let birthDate : Date = inputFormatter.date(from: offender.dateOfBirth) else { fatalError() }
            let form = DateComponentsFormatter()
            form.maximumUnitCount = 1
            form.unitsStyle = .full
            form.allowedUnits = [.year]
            let age = form.string(from: birthDate, to: Date())
            let height: String = String(offender.height / 100) + "' " + String(offender.height % 100) + "\""
            let weight = offender.weight
            let eyeColor = offender.eyes == "BLU" ? "Blue" : (offender.eyes  == "BRO" ? "Brown" : (offender.eyes  == "HAZ" ? "Hazel" : (offender.eyes  == "GRY" ? "Gray" : (offender.eyes  == "GRN" ? "Green" : (offender.eyes  == "BLK" ? "Black" : ("Not available"))))))
            let hairColor = offender.hair == "BLN" ? "Blond" : (offender.hair  == "BRO" ? "Brown" : (offender.hair  == "WHI" ? "White" : (offender.hair  == "GRY" ? "Gray" : (offender.hair  == "RED" ? "Red" : (offender.hair  == "BLK" ? "Black" : ("Not available"))))))
            
            let name = offender.firstName + " " + offender.middleName + " " + offender.lastName + " " + offender.suffix
            
            tableViewData.append(cellData(opened: false, title: name, sectionData: ["Address: \(address)", "Age: \(age!)", "Height: \(height)", "Weight: \(weight)", "Hair Color: \(hairColor)", "Eye Color: \(eyeColor)"]))
        }
    }
}

// MARK: - Search Bar Methods
extension OffenderListTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(searchBar.text!)
//        offenders = offenders?.filter("firstName CONTAINS[cd]", searchBar.text!).sorted(byKeyPath: "name", ascending: true)
        let subpredicates = ["firstName", "middleName", "lastName", "residenceCity"].map { property in
            NSPredicate(format: "%K CONTAINS[cd] %@", property, searchBar.text!)
        }
        let predicate = NSCompoundPredicate(orPredicateWithSubpredicates: subpredicates)
        loadTableViewData(offenders: realm.objects(OregonOffenders.self).filter(predicate))
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        loadTableViewData(offenders: realm.objects(OregonOffenders.self))
        searchBar.endEditing(true)
        tableView.reloadData()
    }
    
}

