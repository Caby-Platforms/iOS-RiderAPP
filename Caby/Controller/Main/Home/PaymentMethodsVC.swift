
//
//  BasicVC.swift


import UIKit

protocol PaymentMethodDelegate {
    func paymentMethodDidSelect(value: String)
}

class PaymentMethodsModel {
    var title: String!
    var type: PaymentType!
    var isSelected = false
}

class PaymentMethodsCell : UITableViewCell {
    
    //MARK:- Outlet
    
    @IBOutlet weak var lblTitle     : UILabel!
    @IBOutlet weak var btnCheck     : UIButton!
    
    //-----------------------------------------------------------
    
    //MARK:- Class methods
    
    override func awakeFromNib() {
        self.lblTitle.applyStyle(labelFont: UIFont.applyMedium(fontSize: 14), textColor: UIColor.ColorBlack)
    }
    
    //-----------------------------------------------------------
    
}

class PaymentMethodsVC: UIViewController {
    
    //MARK: -------------------------- Outlet --------------------------
    @IBOutlet weak var lblTitle                     : UILabel!
    
    @IBOutlet weak var vwPopup                      : UIView!
    
    @IBOutlet weak var tblView                      : UITableView!
    
    @IBOutlet weak var btnSubmit                    : UIButton!
    
    //MARK: -------------------------- Class Variable --------------------------
    var delegate: PaymentMethodDelegate!
    var arrPayment      = [PaymentMethodsModel]()
    var selectedType    = ""
    
    //MARK: -------------------------- Memory Management Method --------------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        
    }
    
    //MARK: -------------------------- Custom Method --------------------------
    func setUpView() {
        self.tblView.delegate       = self
        self.tblView.dataSource     = self
        
        DispatchQueue.main.async {
            self.setFont()
            self.setData()
            
            self.vwPopup.layoutIfNeeded()
            self.btnSubmit.layoutIfNeeded()
            
            self.vwPopup.applyCornerRadius(cornerRadius: 15)
            self.btnSubmit.applyCornerRadius(cornerRadius: self.btnSubmit.frame.height/2)
        }
    }
    
    func setFont() {
        //All labels
        self.lblTitle.applyStyle(labelFont: UIFont.applyBold(fontSize: 20), textColor: UIColor.ColorBlack)
        
        //All button
        self.btnSubmit.applyStyle(titleLabelFont: UIFont.applyMedium(fontSize: 14), titleLabelColor: .ColorWhite, backgroundColor: .ColorLightBlue)
    }
    
    func paymentTypeSelection(index: Int){
        let object = self.arrPayment[index]
        
        self.arrPayment = self.arrPayment.filter({ (obj) -> Bool in
            obj.isSelected = false
            if object.title == obj.title {
                obj.isSelected = true
                
                self.selectedType   = obj.title
            }
            return true
        })
        self.tblView.reloadSections([0], with: .automatic)
    }
    
    //MARK: -------------------------- Action Method --------------------------
    @IBAction func btnCloseTapped(_ sender: UIBarButtonItem) {
        self.view.endEditing(true)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnDoneTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        
        if delegate != nil {
            self.delegate.paymentMethodDidSelect(value: self.selectedType)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: -------------------------- Life Cycle Method --------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.endEditing(true)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.view.endEditing(true)
    }
}

//MARK: -------------------- TableView Methods --------------------
extension PaymentMethodsVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrPayment.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentMethodsCell") as! PaymentMethodsCell
        cell.selectionStyle = .none
        let obj = self.arrPayment[indexPath.row]
        
        cell.lblTitle.text          = obj.title
        cell.btnCheck.isSelected    = obj.isSelected
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.paymentTypeSelection(index: indexPath.row)
    }
}
//------------------------------------------------------


//MARK: -------------------------- Set data method --------------------------
extension PaymentMethodsVC {
    
    func setData(){
        self.arrPayment.removeAll()
        
        let obj1            = PaymentMethodsModel()
        obj1.title          = PaymentType.cash.rawValue
        obj1.type           = PaymentType.cash
        obj1.isSelected     = obj1.type.rawValue.lowercased() == kSelectedPaymentMethod.lowercased() ? true : false
        self.arrPayment.append(obj1)
        
        let obj2            = PaymentMethodsModel()
        obj2.title          = PaymentType.mpesa.rawValue
        obj2.type           = PaymentType.mpesa
        obj2.isSelected     = obj2.type.rawValue.lowercased() == kSelectedPaymentMethod.lowercased() ? true : false
        self.arrPayment.append(obj2)
        
        self.selectedType = kSelectedPaymentMethod//PaymentType.cash.rawValue
        self.tblView.reloadData()
    }
}

