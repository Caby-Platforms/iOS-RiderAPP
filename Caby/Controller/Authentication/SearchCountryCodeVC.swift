//
//  SearchCountryCodeVC.swift
//  UltimateRyder
//
//  Created by iOS on 17/01/17.
//  Copyright © 2017 Hyperlink. All rights reserved.
//

import UIKit

protocol CodePickerDelegate{
    
    func countryCodePickerDelegateMethod(sender:AnyObject)
}

class SearchCountryCodeVC: UIViewController, UITableViewDelegate , UITableViewDataSource , UISearchBarDelegate {
    
    
    //MARK:- Outlet
    
    @IBOutlet var btnClose      : UIBarButtonItem!
    @IBOutlet var searchBar     : UISearchBar!
    @IBOutlet var tblAddress    : UITableView!

    
    //------------------------------------------------------
    
    //MARK:- Class Variable
    
    var arraySearch     : NSMutableArray = NSMutableArray()
    var arrayCode       : NSArray = NSArray()
    var dictData        : NSMutableDictionary = NSMutableDictionary()
    var delegate        : CodePickerDelegate! = nil
    var codeType        : String = String()
    
    //------------------------------------------------------
    
    
    //MARK:- Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //------------------------------------------------------
    
    //MARK:- Custom Method
    
    func setUpView() {
        
        searchBar.becomeFirstResponder()
        tblAddress.tableFooterView = UIView(frame: CGRect.zero)
        searchBar.setShowsCancelButton(false, animated: true)
        
        //Country Code Picker setUp data
        let path : String = Bundle.main.path(forResource: "countryCode", ofType: "geojson")!
        let dataString : String = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
        
        
        if let data = dataString.data(using: .utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                
                arrayCode = json?.value(forKey: "countries") as! NSArray
               
            } catch {
                print(error.localizedDescription)
            }
        }
        arraySearch = NSMutableArray(array: arrayCode)
    }
    
    //------------------------------------------------------
    
    //MARK:- Action Method
    
    @IBAction func btnCloseClicked(sender: UIBarButtonItem) {
        self.view.endEditing(true)
        self.dismiss(animated: false, completion: nil)
    }
    
    //------------------------------------------------------
    
    //MARK: ScrollView Delegate
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
    
    //------------------------------------------------------
    
    //MARK:- SearchBar Delegate
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {

        searchBar.setShowsCancelButton(false, animated: true)
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchText == "" {
            arraySearch = NSMutableArray(array: arrayCode)
        } else {
            let predict = NSPredicate(format: "name CONTAINS[cd] %@ OR name LIKE[cd] %@",searchText, searchText)
            arraySearch = NSMutableArray(array:(arrayCode.filtered(using: predict)))
        }

        tblAddress.reloadData()
    }
    

    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        self.view.endEditing(true)
        searchBar.text = ""

    }
    
    
    //------------------------------------------------------
    
    //MARK:- TableView Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arraySearch.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dictAtIndex : NSDictionary = arraySearch.object(at: indexPath.row) as! NSDictionary
        let cell: UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: "searchCodeCell")
        cell.textLabel?.text = "\(dictAtIndex.value(forKey: "name")!)(\(dictAtIndex.value(forKey: "dial")!))"
        cell.textLabel?.font = UIFont(name: CustomFont.FontRegular.rawValue, size: 13.0)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.sizeToFit()
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dictAtIndex : NSDictionary = arraySearch.object(at: indexPath.row) as! NSDictionary
        if(self.delegate != nil) {

            dictData = dictAtIndex.mutableCopy() as! NSMutableDictionary
            dictData["kType"] = codeType
            
            self.delegate.countryCodePickerDelegateMethod(sender: dictData)
//            self.presentingViewController!.dismiss(animated: true, completion: { _ in })
            self.presentingViewController?.dismiss(animated: true, completion: {
                
            })
        }
    }
    //------------------------------------------------------
    
    //MARK:- Life Cycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    

}
