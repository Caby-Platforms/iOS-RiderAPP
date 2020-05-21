
//
//  BasicVC.swift


import UIKit

class ReferralUsageCell : UITableViewCell {
    
    //MARK:- Outlet
    @IBOutlet weak var vwBg             : UIView!
    
    @IBOutlet weak var lblTitle         : UILabel!
    @IBOutlet weak var lblAmount        : UILabel!
    @IBOutlet weak var lblDate          : UILabel!
    
    @IBOutlet weak var imgUser          : UIImageView!
    
    //-----------------------------------------------------------
    var object = ReferredUserModel()
    
    //MARK:- Class methods
    
    override func awakeFromNib() {
    }
    
    func setFont(){
        self.lblTitle.applyStyle(labelFont: UIFont.applyMedium(fontSize: 14), textColor: UIColor.ColorBlack)
        self.lblAmount.applyStyle(labelFont: UIFont.applyRegular(fontSize: 14), textColor: UIColor.ColorLightBlue)
        self.lblDate.applyStyle(labelFont: UIFont.applyRegular(fontSize: 12), textColor: UIColor.ColorLightGray)
        
        //SET VIEWS
        DispatchQueue.main.async {
            self.vwBg.layoutIfNeeded()
            self.imgUser.layoutIfNeeded()
            
            self.vwBg.applyCornerRadius(cornerRadius: 10, borderColor: UIColor.ColorLightBlue, borderWidth: 1)
            self.imgUser.applyCornerRadius(cornerRadius: self.imgUser.frame.size.height/2)
        }
    }
    
    func setData(){
        self.setFont()
        
        self.lblTitle.text      = object.name
        self.lblAmount.text     = kCurrencySymbol + " " + "\(object.referralAmount!)"
        self.imgUser.setImage(strURL: object.profileImage)
        
        let date = GFunction.shared.dateFormatterFromString(strDate: object.insertdate, CurrentFormat: DateTimeFormaterEnum.UTCFormat.rawValue, ChangeFormat: DateTimeFormaterEnum.MMM_d_Y.rawValue)
        
        self.lblDate.text       = date
    }
    
    //-----------------------------------------------------------
}

class ReferralUsageVC: UIViewController {
    
    //MARK: -------------------------- Outlet --------------------------
    @IBOutlet weak var tblView              : UITableView!
    @IBOutlet weak var lblNoMsg             : UILabel!
    
    //MARK: -------------------------- Class Variable --------------------------
    let refreshControl                      = UIRefreshControl()
    var page                                = 1
    var isNextPage                          = true
    var arrReferredUser                     = [ReferredUserModel]()
    
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
        self.arrReferredUser.removeAll()
        
        page                = 1
        isNextPage          = true
        lblNoMsg.isHidden   = true
        
        //tmp
        refreshControl.endRefreshing()
        
        //API Call
        self.referralUsageAPI(withLoader: withLoader) { (isLoaded) in
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
    
    func setFont() {
        self.lblNoMsg.applyStyle(labelFont: UIFont.applyBold(fontSize: 15), textColor: UIColor.lightGray)
    }
    
    //MARK: -------------------------- Action Method --------------------------
    
    
    //MARK: -------------------------- Life Cycle Method --------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.endEditing(true)
        self.apiFromStart(withLoader: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.view.endEditing(true)
    }
}

//MARK: -------------------- TableView Methods --------------------
extension ReferralUsageVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrReferredUser.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReferralUsageCell") as! ReferralUsageCell
        cell.selectionStyle     = .none
        cell.object             = self.arrReferredUser[indexPath.row]
        cell.setData()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == arrReferredUser.count - 1 {
            if isNextPage {
                self.page += 1
                self.referralUsageAPI(withLoader: false) { (isLoaded) in
                    if isLoaded {
                        self.tblView.reloadData()
                    }
                }
            }
        }
    }
}


//MARK: ---------------- API Call ----------------------
extension ReferralUsageVC {
    //MARK: ----------------My Ride API ----------------------
    func referralUsageAPI(withLoader: Bool, completion: ((Bool) -> Void)?){
        
        let params: [String: Any] = ["page": page]
        print("params-------------------------------\(params)")
        
        ApiManger.shared.makeRequest(method: APIEndPoints.GetReferralUserList, methodType: .post, parameter: params, withErrorAlert: true, withLoader: withLoader, withdebugLog: true) { (JSON, serverCode, error, handleCode) in
            if error == nil {
                var returnVal = false
                self.refreshControl.endRefreshing()
                
                switch handleCode {
                case ApiResponseCode.InvalidORFailerRequest:
                    self.isNextPage = false
                    if self.page == 1 {
                        self.arrReferredUser.removeAll()
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
                    let arrData         = JSON[APIResponseKey.kData.rawValue].arrayValue
                    
                    if self.page == 1 {
                        //From start
                        self.arrReferredUser.removeAll()
                        if arrData.count > 0 {
                            self.arrReferredUser.append(contentsOf: ReferredUserModel.modelsFromDictionaryArray(array: arrData))
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
                        self.arrReferredUser.append(contentsOf: ReferredUserModel.modelsFromDictionaryArray(array: arrData))
                    }
                    break
                case .NoDataFound:
                    self.isNextPage = false
                    if self.page == 1 {
                        self.arrReferredUser.removeAll()
                    }
                    else {
                        returnVal = true
                    }
                    
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
