//
//  ContactPickerVC.swift
//  Tru Flat Rate
//
//  Created by Hyperlink on 8/4/16.
//  Copyright © 2016 Hyperlink. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


protocol contactPickerDelegate {
    func setContact(_ number : String, name: String)
}


class AddressBookTCellVC: UITableViewCell {
    
    
    @IBOutlet weak var imgContactProfile: UIImageView!
    @IBOutlet weak var tbFirstName: UILabel!
    @IBOutlet weak var tbLastName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.tbFirstName.applyStyle(labelFont: UIFont.applyMedium(fontSize: 13.0), textColor: UIColor.ColorBlack)
        self.tbLastName.applyStyle(labelFont: UIFont.applyMedium(fontSize: 13.0), textColor: UIColor.ColorBlack)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.imgContactProfile.layer.cornerRadius = self.imgContactProfile.frame.height / 2
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

class ContactPickerVC: UIViewController,
                    UITableViewDelegate,
                    UITableViewDataSource,
                    UISearchBarDelegate,
                    UIActionSheetDelegate


{
    
    
    @IBOutlet weak var lblContact   : UINavigationItem!
    @IBOutlet weak var searchBar    : UISearchBar!
    @IBOutlet weak var tvAddressBook: UITableView!
    
    
    /*--------------Variables----------------*/
    var delegate : contactPickerDelegate?
    var selectedNumber_arr  = NSMutableArray()
    var people: [SwiftAddressBookPerson] = []
    var filtered:[SwiftAddressBookPerson] = []
    var searchActive : Bool = false
    var contactSectionList  : [String] = []
   
    
    //-----------------------------------------------------------------------
    //MARK: - Memory Management Methods
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //----------------------------------------------------------------------
    //MARK: - Custom methods
    func setupLocalization(){
        
//        self.searchBar.searchTextField.backgroundColor = UIColor.ColorWhite
        
        self.lblContact.title       = "Contact".localized
    }
    
    //----------------------------------------------------------------------
    func getAllContacts(){
        //AppDelegate.sharedInstance().addLoder()
        
        SwiftAddressBook.requestAccessWithCompletion({ (success, error) -> Void in
            if success {
  
                
                if  let peoples = swiftAddressBook?.allPeople {
                    self.people = peoples
                    if self.people.count > 0{
                        
                        DispatchQueue.main.async(execute: {() -> Void in
                              self.tvAddressBook.reloadData()
                        })
                       
                    }else{
                       GFunction.shared.showSnackBar("No contacts found")
                    }
                }
            }
            else {
                //no success. Optionally evaluate error
            }
        })
    }

    //----------------------------------------------------------------------
    
    //MARK: - Action Method
    
    @IBAction func btnBack_tapped(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //----------------------------------------------------------------------
    
    //MARK: - TextField Delegate
    
    //----------------------------------------------------------------------
    //MARK: UITableView Datasource delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    //----------------------------------------------------------------------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if(searchActive) {
            return filtered.count
        }
        
        return people.count
    }
    //----------------------------------------------------------------------
    /*func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return contactSectionList[section]
    }*/
    //----------------------------------------------------------------------
   /* func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return contactSectionList
    }*/
    //----------------------------------------------------------------------
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }
    
    //----------------------------------------------------------------------
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! AddressBookTCellVC
              if(searchActive){
            let personData :SwiftAddressBookPerson = filtered[indexPath.row]
            
            
            cell.tbFirstName.text! = personData.firstName?.isEmpty == nil ? "No Name" : personData.firstName!
            cell.tbLastName.text! = personData.lastName?.isEmpty == nil ? "" : personData.lastName!
            //cell.tbLastName.text! = personData.lastName?.isEmpty ? "" : personData.lastName!
            if personData.hasImageData(){
                cell.imgContactProfile.image = personData.image
            }else{
                cell.imgContactProfile.image = UIImage(named: "DefaultImgContact")
            }
            
            
        }else{
            if people.count > 0{
                let personData :SwiftAddressBookPerson = people[indexPath.row]
                
                if personData.firstName != nil{
                    cell.tbFirstName.text! = personData.firstName!
                }
                cell.tbFirstName.text! = personData.firstName?.isEmpty == nil ? "No name" : personData.firstName!
                cell.tbLastName.text! = personData.lastName?.isEmpty == nil ? "" : personData.lastName!
                //cell.tbLastName.text! = personData.lastName?.isEmpty ? "" : personData.lastName!
                if personData.hasImageData(){
                    cell.imgContactProfile.image = personData.image
                }else{
                    cell.imgContactProfile.image = UIImage(named: "DefaultImgContact")
                }
            }
            
        }
        
        return cell
    }
    
    //----------------------------------------------------------------------
    //MARK: UITableView Delegate methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        searchBar.resignFirstResponder()
        
        if(searchActive) {
            
            let personData :SwiftAddressBookPerson = filtered[indexPath.row]
            
            if personData.phoneNumbers?.count > 0{
                let numberPopUp: UIActionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "CANCEL", destructiveButtonTitle: nil)
                for item in personData.phoneNumbers!{
                    numberPopUp.addButton(withTitle: item.value)
                }
                numberPopUp.tag = indexPath.row + 1234
                numberPopUp.show(in: self.view)
            }else{
                //alert for no number found
            }
        }else {
            
            let personData :SwiftAddressBookPerson = people[indexPath.row]
            
            if personData.phoneNumbers?.count > 0{
                let numberPopUp: UIActionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "CANCEL", destructiveButtonTitle: nil)
                for item in personData.phoneNumbers!{
                    numberPopUp.addButton(withTitle: item.value)
                }
                numberPopUp.tag = indexPath.row + 1234
                numberPopUp.show(in: self.view)
            }else{
                //alert for no number found
            }
        }
        
       
        
    }
    //----------------------------------------------------------------------
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath){
    }
    
    //----------------------------------------------------------------------
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?){
    }
    //----------------------------------------------------------------------
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65.0
    }
    //----------------------------------------------------------------------
    //MARK: - Action sheet delegate
    //----------------------------------------------------------------------
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int){
        //cancel button clicked
        if(buttonIndex == 0){
            return
        }
        let index = actionSheet.tag - 1234
        
        
        let personData :SwiftAddressBookPerson = people[index]
        let selectedNumber : String = personData.phoneNumbers![buttonIndex - 1 ].value
       
        debugPrint(selectedNumber_arr)
        
        let fName = personData.firstName?.isEmpty == nil ? "" : personData.firstName!
        let lName = personData.firstName?.isEmpty == nil ? "" : personData.lastName!
        
        self.dismiss(animated: true) {
            self.delegate?.setContact(self.removeSpecialCharsFromString(selectedNumber), name: fName + " " + lName)
        }
    }
    
    //----------------------------------------------------------------------
    
    func removeSpecialCharsFromString(_ text: String) -> String {
        let okayChars : Set<Character> =
            Set("1234567890")
        return String(text.filter {okayChars.contains($0) })
    }

    //----------------------------------------------------------------------
    //MARK: - searchbar delegate 
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
       
        searchActive = true;
        
        if filtered.count == 0{
            searchActive = false;
        }
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if searchBar.text == "" {
            searchActive = false
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchActive = false;
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        guard let objPeople = people as? [SwiftAddressBookPerson] else {return}
        
        let  filteredData = objPeople.flatMap{ $0 }
        
        
        filtered = filteredData.filter { item in
            if item.firstName != nil {
                return item.firstName!.contains(searchText)
            }else{
                return false
            }
        }
        //         filtered = filteredData.filter{ $0.firstName!.contains(searchText)}
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tvAddressBook.reloadData()
    }
    //-----------------------------------------------------------------------
    //MARK: - View Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
         getAllContacts()
        setupLocalization()
        self.tvAddressBook.delegate = self
        self.tvAddressBook.dataSource = self
        self.searchBar.delegate = self
    }
    
    //----------------------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.endEditing(true)
        tvAddressBook.tableFooterView = UIView(frame: CGRect.zero)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    //----------------------------------------------------------------------

}
