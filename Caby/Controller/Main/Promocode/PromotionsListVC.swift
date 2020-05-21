
//
//  BasicVC.swift


import UIKit

protocol PromoListDelegate {
    func promoDidSelect(obj: PromoListModel?, referAmount: String?)
}

class PromotionsListCell : UITableViewCell {
    
    //MARK:- Outlet
    @IBOutlet weak var vwBg             : UIView!
    
    @IBOutlet weak var lblTitle         : UILabel!
    @IBOutlet weak var lblDesc          : UILabel!
    @IBOutlet weak var lblExp           : UILabel!
    
    @IBOutlet weak var btnSelect        : UIButton!
    @IBOutlet weak var btnInfo          : UIButton!
    
    //-----------------------------------------------------------
    var object = PromoListModel()
    
    //MARK:- Class methods
    
    override func awakeFromNib() {
        self.lblTitle.applyStyle(labelFont: UIFont.applyMedium(fontSize: 14), textColor: UIColor.ColorBlack)
    }
    
    func setFont(){
        self.lblTitle.applyStyle(labelFont: UIFont.applyRegular(fontSize: 14), textColor: UIColor.ColorLightGray)
        self.lblDesc.applyStyle(labelFont: UIFont.applyRegular(fontSize: 14), textColor: UIColor.ColorBlack)
        self.lblExp.applyStyle(labelFont: UIFont.applyRegular(fontSize: 14), textColor: UIColor.ColorLightGray)
        
        //SET VIEWS
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.btnSelect.layoutIfNeeded()
            
            self.vwBg.applyCornerRadius(cornerRadius: 10, borderColor: UIColor.ColorLightBlue, borderWidth: 1)
            
            self.btnSelect.applyStyle(titleLabelFont: UIFont.applyRegular(fontSize: 14), titleLabelColor: UIColor.ColorBlack, state: .normal)
            self.btnSelect.applyStyle(titleLabelFont: UIFont.applyRegular(fontSize: 14), titleLabelColor: UIColor.ColorBlack, state: .selected)
            self.btnSelect.applyCornerRadius(cornerRadius: 0, borderColor: UIColor.ColorLightBlue, borderWidth: 1)
        }
    }
    
    func setData(){
        self.setFont()
        
        self.lblTitle.text  = kProvideBy
        
        var discount    = ""
        switch object.type.lowercased() {
        case "percentage".lowercased():
            discount    = object.value + "%" + " " + kOff
            
            break
        case "flat".lowercased():
            discount    = kFlat + " " + kCurrencySymbol + "" + object.value + " " + kOff
            
            break
        default:break
        }
        
        self.lblDesc.text   = object.descriptionField + " " + discount
        
        let date = GFunction.shared.dateFormatterFromString(strDate: object.endDate, CurrentFormat: DateTimeFormaterEnum.yyyymmdd.rawValue, ChangeFormat: DateTimeFormaterEnum.MMM_d_Y.rawValue)
        
        if GFunction.shared.compareDate(toDate: object.endDate, changeFormat: DateTimeFormaterEnum.yyyymmdd.rawValue) == .orderedAscending {
            self.lblExp.text    = kExpires + " " + date
            self.lblExp.applyStyle(labelFont: UIFont.applyRegular(fontSize: 14), textColor: UIColor.ColorLightGray)
        }
        else {
            //Expired
            
            self.lblExp.text    = kExpired + " " + date
            self.lblExp.applyStyle(labelFont: UIFont.applyRegular(fontSize: 14), textColor: UIColor.ColorRed)
        }
    }
    
    //-----------------------------------------------------------
}

class PromotionsModelTemp {
    var title: String!
    var desc: String!
    var exp: String!
    var isSelected = false
}

class PromotionsListVC: UIViewController {
    
    //MARK: -------------------------- Outlet --------------------------
    @IBOutlet weak var vwRefer              : UIView!
    @IBOutlet weak var tblView              : UITableView!
    
    @IBOutlet weak var lblTitle             : UILabel!
    @IBOutlet weak var lblDesc              : UILabel!
    @IBOutlet weak var lblNoMsg             : UILabel!
    @IBOutlet weak var lblRefer             : UILabel!
    
    @IBOutlet weak var btnSelectRefer       : UIButton!
    @IBOutlet weak var btnAddPromo          : UIBarButtonItem!
    
    //MARK: -------------------------- Class Variable --------------------------
    let refreshControl                      = UIRefreshControl()
    var page                                = 1
    var isNextPage                          = true
    var arrPromoList                        = [PromoListModel]()
    var referAmount: String                 = ""
    let refer1                              = "Get"
    let refer2                              = "off your ride"
    
    var delegate: PromoListDelegate!
    var selectedPromo                       = PromoListModel()
    
    var arrPromotionTmp                     = [PromotionsModelTemp]()
    
    //MARK: -------------------------- Memory Management Method --------------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        
    }
    
    //MARK: -------------------------- Custom Method --------------------------
    func setUpView() {
        self.tblView.delegate           = self
        self.tblView.dataSource         = self
        
        self.setFont()
        self.setUpTableView()
//        self.setDummyData()
        
        DispatchQueue.main.async {
            self.vwRefer.layoutIfNeeded()
            self.btnSelectRefer.layoutIfNeeded()
            
            self.vwRefer.backgroundColor = UIColor.ColorLightBlue.withAlphaComponent(0.1)
            
            self.btnSelectRefer.applyStyle(titleLabelFont: UIFont.applyRegular(fontSize: 14), titleLabelColor: UIColor.ColorBlack, state: .normal)
            self.btnSelectRefer.applyStyle(titleLabelFont: UIFont.applyRegular(fontSize: 14), titleLabelColor: UIColor.ColorBlack, state: .selected)
            self.btnSelectRefer.applyCornerRadius(cornerRadius: 0, borderColor: UIColor.ColorLightBlue, borderWidth: 1)
        }
    }
    
    func setUpTableView() {
        self.refreshControl.addTarget(self, action: #selector(apiFromStart(withLoader:)), for: UIControl.Event.valueChanged)
        self.tblView.addSubview(self.refreshControl)
        self.tblView.delegate       = self
        self.tblView.dataSource     = self
        
        self.tblView.estimatedRowHeight = 90
        self.tblView.rowHeight      = UITableView.automaticDimension
        
        AnimatableReload.reload(tableView: self.tblView, animationDirection: "down")
    }
    
    @objc func apiFromStart(withLoader: Bool = false){
        self.arrPromoList.removeAll()
        
        page                = 1
        isNextPage          = true
        lblNoMsg.isHidden   = true
        
        //tmp
        refreshControl.endRefreshing()
        
        //API Call
        self.promoListAPI(withLoader: withLoader) { (isLoaded) in
            if isLoaded {
                self.tblView.reloadData()
            }
            else {
                self.tblView.reloadData()
                self.lblNoMsg.isHidden = false
                self.lblNoMsg.bringSubviewToFront(self.view)
            }
        }
    }
    
    func setUpReferView(){
        self.lblRefer.text = self.refer1 + " " +
            kCurrencySymbol + " " +
            self.referAmount + " " +
            self.refer2
        
        if self.referAmount.trim() != "" && self.referAmount.trim() != "0" {
            self.vwRefer.isHidden = false
            
            self.btnSelectRefer.isSelected = false
            if RideEstimateModel.rideEstimateModel.referral_amount.trim() != "" {
                self.btnSelectRefer.isSelected = true
            }
        }
        else {
            self.vwRefer.isHidden = true
        }
    }
    
    func setPromotionSelection(index: Int) {
        
    }
    
    func setFont() {
        self.lblTitle.text      = kPromoTitle
        self.lblDesc.text       = kPromoLimit
        
        //All labels
        self.lblTitle.applyStyle(labelFont: UIFont.applyRegular(fontSize: 16), textColor: UIColor.ColorBlack)
        self.lblDesc.applyStyle(labelFont: UIFont.applyRegular(fontSize: 14), textColor: UIColor.ColorLightGray)
        self.lblNoMsg.applyStyle(labelFont: UIFont.applyBold(fontSize: 15), textColor: UIColor.lightGray)
        self.lblRefer.applyStyle(labelFont: UIFont.applyRegular(fontSize: 14), textColor: UIColor.ColorBlack)
        
        //All button
        self.btnAddPromo.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.applyBold(fontSize: 12),
                                                 NSAttributedString.Key.foregroundColor: UIColor.ColorLightBlue],
                                                for: .normal)
        self.btnAddPromo.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.applyBold(fontSize: 12),
         NSAttributedString.Key.foregroundColor: UIColor.ColorLightBlue],
        for: .highlighted)
        
        
    }
    
    //MARK: -------------------------- Action Method --------------------------
    @IBAction func btnAddPromoClick(_ sender: UIButton) {
        let vc = kMainStoryBoard.instantiateViewController(withIdentifier: "AddPromocodeVC") as! AddPromocodeVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnInfoPromoClick(_ sender: UIButton) {
        let object = self.arrPromoList[sender.tag]
        
        let date = GFunction.shared.dateFormatterFromString(strDate: object.endDate, CurrentFormat: DateTimeFormaterEnum.yyyymmdd.rawValue, ChangeFormat: DateTimeFormaterEnum.MMM_d_Y.rawValue)
        
        var exp = ""
        if GFunction.shared.compareDate(toDate: object.endDate, changeFormat: DateTimeFormaterEnum.yyyymmdd.rawValue) == .orderedAscending {
            exp    = kExpires.lowercased()
        }
        else {
            //Expired
            exp    = kExpired.lowercased()
        }
        
        let desc = kThisPromo + " " + exp + " " + kOn + " " + date
        
        GFunction.showAlert(actionOkTitle: kOk, actionCancelTitle: "", message: desc) { (isDone) in
            
        }
    }
    
    @IBAction func btnSelectPromoClick(_ sender: UIButton) {
        let object = self.arrPromoList[sender.tag]
        
        if object.status == "Active" {
            if GFunction.shared.compareDate(toDate: object.endDate, changeFormat: DateTimeFormaterEnum.yyyymmdd.rawValue) == .orderedAscending {
                
                if !object.isSelected {
                    object.isSelected = true
                }
                else {
                    object.isSelected = false
                }
                
                
                GServices.shared.checkPromocodeAPI(strPromocode: object.promocode) { (isDone, json) in
                    if isDone {
                        if self.delegate != nil {
                            self.delegate.promoDidSelect(obj: object, referAmount: nil)
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            }
            else {
                //Expired
            }
        }
    }
    
    @IBAction func btnSelectReferClick(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            
            if self.delegate != nil {
                self.delegate.promoDidSelect(obj: nil, referAmount: nil)
                self.navigationController?.popViewController(animated: true)
            }
        }
        else {
            sender.isSelected = true
            
            if self.delegate != nil {
                self.delegate.promoDidSelect(obj: nil, referAmount: self.referAmount)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    //MARK: -------------------------- Life Cycle Method --------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.endEditing(true)
        self.vwRefer.isHidden = true
        self.apiFromStart(withLoader: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.view.endEditing(true)
    }
}

//MARK: -------------------- TableView Methods --------------------
extension PromotionsListVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrPromoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PromotionsListCell") as! PromotionsListCell
        cell.selectionStyle     = .none
        cell.btnSelect.tag      = indexPath.row
        cell.btnInfo.tag        = indexPath.row
        cell.object             = self.arrPromoList[indexPath.row]
        cell.setData()
        
        cell.btnSelect.isSelected = false
        if cell.object.id == self.selectedPromo.id {
            cell.object.isSelected      = self.selectedPromo.isSelected
            cell.btnSelect.isSelected   = self.selectedPromo.isSelected
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.setPromotionSelection(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == arrPromoList.count - 1 {
            if isNextPage {
                self.page += 1
                self.promoListAPI(withLoader: false) { (isLoaded) in
                    if isLoaded {
                        self.tblView.reloadData()
                    }
                }
            }
        }
    }
}

//MARK: -------------------- Setdata Methods --------------------
extension PromotionsListVC {
    
    func setDummyData(){
        self.arrPromotionTmp.removeAll()
        let obj1            = PromotionsModelTemp()
        obj1.title          = "Provided by Caby"
        obj1.desc           = "test"
        obj1.exp            = "Expired Feb 28, 2020"
        obj1.isSelected     = false
        self.arrPromotionTmp.append(obj1)
        
        let obj2            = PromotionsModelTemp()
        obj2.title          = "Provided by Caby"
        obj2.desc           = "test is here"
        obj2.exp            = "Expired Feb 28, 2020"
        obj2.isSelected     = false
        self.arrPromotionTmp.append(obj2)
        
        let obj3            = PromotionsModelTemp()
        obj3.title          = "Provided by Caby"
        obj3.desc           = "test"
        obj3.exp            = "Expired Feb 28, 2021"
        obj3.isSelected     = false
        self.arrPromotionTmp.append(obj3)
        
        let obj4            = PromotionsModelTemp()
        obj4.title          = "Provided by Caby"
        obj4.desc           = "test 4342"
        obj4.exp            = "Expired Feb 28, 2020"
        obj4.isSelected     = false
        self.arrPromotionTmp.append(obj4)
        
        self.tblView.reloadData()
    }
    
}

//MARK: ---------------- API Call ----------------------
extension PromotionsListVC {
    //MARK: ----------------My Ride API ----------------------
    func promoListAPI(withLoader: Bool, completion: ((Bool) -> Void)?){
        
        let params: [String: Any] = ["page": page]
        print("params-------------------------------\(params)")
        
        ApiManger.shared.makeRequest(method: APIEndPoints.PromoList, methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (JSON, serverCode, error, handleCode) in
            if error == nil {
                var returnVal = false
                self.refreshControl.endRefreshing()
                
                switch handleCode {
                case ApiResponseCode.InvalidORFailerRequest:
                    self.isNextPage = false
                    if self.page == 1 {
                        self.arrPromoList.removeAll()
                    }
                    else {
                        returnVal = true
                    }
                    let msg = JSON[APIResponseKey.kMessage.rawValue].stringValue
                    //GFunction.sharedMethods.showSnackBar(msg)
                    self.lblNoMsg.text = msg
                    break
                case .UserSessionExpire:
                    break
                case .SuccessResponse:
                    let data        = JSON[APIResponseKey.kData.rawValue]
                    self.referAmount = JSON["referral_amount"].stringValue
                    self.setUpReferView()
                    let arrData     = data["promo_list"].arrayValue
                    
                    if self.page == 1 {
                        //From start
                        self.arrPromoList.removeAll()
                        if arrData.count > 0 {
                            self.arrPromoList.append(contentsOf: PromoListModel.modelsFromDictionaryArray(array: arrData))
                            returnVal = true
                        }
                    }
                    else {
                        returnVal = true
                        //for pagenation
                        guard arrData.count > 0 else {
                            self.isNextPage = false
                            return
                        }
                        self.arrPromoList.append(contentsOf: PromoListModel.modelsFromDictionaryArray(array: arrData))
                    }
                    break
                case .NoDataFound:
                    self.isNextPage = false
                    if self.page == 1 {
                        self.arrPromoList.removeAll()
                    }
                    else {
                        returnVal = true
                    }
                    
                    self.referAmount = JSON["referral_amount"].stringValue
                    self.setUpReferView()
                    
                    let msg = JSON[APIResponseKey.kMessage.rawValue].stringValue
                    self.lblNoMsg.text = msg
                    break
                case .AccountInActive:
                    GFunction.shared.forceLogOut()
                    let msg = JSON[APIResponseKey.kMessage.rawValue].stringValue
                    GFunction.shared.showSnackBar(msg)
                    break
                case .OTPVerify:
                    break
                case .EmailVerify:
                    break
                case .ForceUpdateApp:
                    break
                case .SimpleUpdateAlert:
                    break
                case .Custom:
                    break
                case .Unknown:
                    break
                default: break
                }//Switch ends
                completion?(returnVal)
            }
        }
    }
}
