//
//  WSViewController.swift
//  mermaids
//
//  Created by DAVID on 19/01/17.
//  Copyright © 2017 Jingged. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift


class WSViewController: UIViewController, MDCSwipeToChooseDelegate, UISearchBarDelegate,TutorialPageViewControllerDelegate {
    
    var isLoaded = false
    
    //MARK:- Initialize objects
    
    var tutorialPageViewController: TutorialPageViewController? {
        didSet {
            tutorialPageViewController?.tutorialDelegate = self
        }
    }
    
    /**
    ** Tutorial delegates
    **/
    
    func tutorialPageViewController(_ tutorialPageViewController: TutorialPageViewController,
                                    didUpdatePageCount count: Int)
    {
        
    }
    
    func tutorialPageViewController(_ tutorialPageViewController: TutorialPageViewController,
                                    didUpdatePageIndex index: Int)
    {
        
    }

    
    let apiManager = APIManager()

    @IBOutlet weak var searchBarTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var userBtn: UIButton!
    @IBOutlet weak var searchBarLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var catfishBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var starFishBtn: UIButton!
    @IBOutlet weak var controlPanel: UIView!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var middleContainer: UIView!
    
    
    var _WSListTableViewController:WSListTableViewController!

    var cardsContainer = UIView()
    var listContainer = UIView()
    
    var isDataAvailable:Bool = false
    var iscardsView:Bool = true
    
    var people = [Person]()
    
    let ChoosePersonButtonHorizontalPadding:CGFloat = 20.0
    let ChoosePersonButtonVerticalPadding:CGFloat = 20.0
    
    var kbHeight:CGFloat = 0
    
    var currentPerson:Person!
    var frontCardView:ChoosePersonView!
    var backCardView:ChoosePersonView!
    var details:[Any] = []
    var searchArray:[Any] = []
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initWithUserInfo()
        self.hideKeyboardWhenTappedAround()
        IQKeyboardManager.sharedManager().enable = false
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if ((userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
                self.animateTextField(up: true)
//                var frame = _WSListTableViewController.view.frame
//                frame.origin.y = frame.origin.y - 400
//                _WSListTableViewController.view.frame = frame
//
//                var frame1 = controlPanel.frame
//                frame1.origin.y = frame.origin.y - 284
//                controlPanel.frame = frame1

            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.animateTextField(up: false)
    }
    
    func animateTextField(up: Bool) {
        let movement = (up ? -kbHeight : kbHeight)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if isLoaded == false {
            isLoaded = true
            apiManager.getUsers(completion:{
                (details: [Any]) in
                
                DispatchQueue.main.sync {
                    self.details = details
                    self.people = self.LoadPeople()
                    self.isDataAvailable = true
                    self.initListView()
                    self.initCardsView()
                }
            })
        }

    }
    
    func initCardsView()  {
        cardsContainer.frame = middleContainer!.bounds
        cardsContainer.backgroundColor = .white
        middleContainer.addSubview(cardsContainer)
        initCardsController()
        loadControlPanel()
    }
    
    func initCardsController() {
        // Display the first ChoosePersonView in front. Users can swipe to indicate
        // whether they like or dislike the person displayed.
        
        self.setMyFrontCardView(self.popPersonViewWithFrame(frontCardViewFrame())!)
        cardsContainer.addSubview(self.frontCardView)
        
        // Display the second ChoosePersonView in back. This view controller uses
        // the MDCSwipeToChooseDelegate protocol methods to update the front and
        // back views after each user swipe.
        self.backCardView = self.popPersonViewWithFrame(backCardViewFrame())!
        cardsContainer.insertSubview(self.backCardView, belowSubview: self.frontCardView)
        
        var rect = self.frontCardView.frame
        rect.size.width = 60
        
        let nopeBtn = UIButton.init(frame: rect)
        nopeBtn.addTarget(self, action: #selector(self.nopeFrontCardView), for: .touchUpInside)
        cardsContainer.addSubview(nopeBtn)
        
        rect.origin.x = self.frontCardView.frame.size.width - 40
        let likeBtn = UIButton.init(frame: rect)
        likeBtn.addTarget(self, action: #selector(self.likeFrontCardView), for: .touchUpInside)
        cardsContainer.addSubview(likeBtn)
        // Add buttons to programmatically swipe the view left or right.
        // See the `nopeFrontCardView` and `likeFrontCardView` methods.
    }

    
    func initListView()  {
        
        listContainer.frame = sizeOf(middleContainer!.bounds)
        middleContainer.addSubview(listContainer)
        initListController()
    }
    
    func sizeOf(_ frame:CGRect) -> (CGRect) {
        var rect = frame
        rect.size.height = rect.size.height - 60
        return rect
    }
    
    func initListController()
    {
        _WSListTableViewController = self.storyboard?.instantiateViewController(withIdentifier: "WSListTableViewController_ID") as! WSListTableViewController
        _WSListTableViewController.details = self.details
        displaylistVC()
    }

    
    @IBAction func openUserProfile(_ sender: Any) {
        
      Global.sharedInstance.addLeftAnimation((self.navigationController?.view)!)
        
        let new = self.storyboard?.instantiateViewController(withIdentifier: "UserProfileViewControllerID") as! UserProfileViewController
        self.navigationController?.pushViewController(new, animated: true)
        
    }
    
    @IBAction func openMatch(_ sender: Any) {
        Global.sharedInstance.addRightAnimation((self.navigationController?.view)!)
        let new = self.storyboard?.instantiateViewController(withIdentifier: "MatchViewControllerID") as! MatchViewController
        self.navigationController?.pushViewController(new, animated: true)
        
    }

    @IBAction func refresh(_ sender: Any) {
        if (self.isDataAvailable == true) {
            self.getUsers()
        }
    }

    
    func getUsers() {
        var request = URLRequest(url: URL(string:"http://api.mermaidsdating.com/index.php")!)
        request.httpMethod = "POST"
        let tokenInfo = UserDefaults.standard.string(forKey: "token")
        
        var postString = "action=Swipuser&"
        postString.append("limit=5&")
        postString.append("token=\(tokenInfo!)&")
        postString.append("current_page=1")
        
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                // check for fundamental networking error
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            
            let jsonData = responseString?.data(using: .utf8)
            //
            let json = try! JSONSerialization.jsonObject(with: jsonData!, options: .allowFragments) as! [String:Any]
            self.details = json["details"] as! [Any]
            DispatchQueue.main.sync {
                self.people = self.LoadPeople()
                self.isDataAvailable = true
                self.initListView()
//                self.initCardsView()
            }
        }
        task.resume()
    }
    
    func LoadPeople() -> [Person]{
        
        var persons = [Person]()
        for obj in self.details {
            if let objs = obj as? [String:Any] {
                persons.append(Person(name: objs["name"] as! NSString?, image: UIImage(named: "user_1"), age: 21, address: objs["address"] as! NSString?, about: objs["about"] as! NSString?, count: 5, images: objs["pic"] as! [Any]))
            }
        }
        
        return persons
        
    }

    
    func showHideControlPanel() {
    }
    
    //show the photo selection
    private func displaylistVC()
    {
        addChildViewController(_WSListTableViewController)
        _WSListTableViewController.view.frame = listContainer.bounds
        listContainer.addSubview(_WSListTableViewController.view)
        _WSListTableViewController.didMove(toParentViewController: self)
    }

    
    func initWithUserInfo() {
        var userInfo = UserDefaults.standard.dictionary(forKey: "userProfile")! as [String:Any]
        
        let imageStr:String = (userInfo["image"] as! String?)!
        
        let dCode = imageStr.removingPercentEncoding
        
        Global.sharedInstance.setImageFromUrl(str: dCode!, completion:  {
            (image: UIImage) in
            self.profileImgView.image = image
        })
        
    }
    
    func loadControlPanel() {
//        catfishBtn.imageView?.contentMode = .scaleAspectFit
//        cancelBtn.imageView?.contentMode = .scaleAspectFit
//        likeBtn.imageView?.contentMode = .scaleAspectFit
//        starFishBtn.imageView?.contentMode = .scaleAspectFit
//        
//        catfishBtn.setImage(UIImage(named: "window-shopping-page-v01_31"), for: .normal)
//        cancelBtn.setImage(UIImage(named: "window-shopping-page-v01_25"), for: .normal)
//        likeBtn.setImage(UIImage(named: "window-shopping-page-v01_22"), for: .normal)
//        starFishBtn.setImage(UIImage(named: "window-shopping-page-v01_28"), for: .normal)
        
//        cancelBtn.addTarget(self, action: #selector(self.nopeFrontCardView), for: .touchUpInside)
//        likeBtn.addTarget(self, action: #selector(self.likeFrontCardView), for: .touchUpInside)

    }
    
    @IBOutlet weak var viewOptionBtn: UIButton!
    
    @IBAction func changeViewOption(_ sender: Any) {
        if iscardsView == true {
            iscardsView = false
            searchBarTrailingConstraint.constant = 0
            searchBarLeadingConstraint.constant = 0
            cardsContainer.isHidden = true
            listContainer.isHidden = false
            viewOptionBtn.setImage(UIImage.init(named: "cards_Icon"), for: .normal)

        } else {
            iscardsView = true
            searchBarTrailingConstraint.constant = 40
            searchBarLeadingConstraint.constant = 40
            cardsContainer.isHidden = false
            listContainer.isHidden = true

            viewOptionBtn.setImage(UIImage.init(named: "list_Icon"), for: .normal)
        }
    }
    
    
    func suportedInterfaceOrientations() -> UIInterfaceOrientationMask{
        return UIInterfaceOrientationMask.portrait
    }
    
    // This is called when a user didn't fully swipe left or right.
    func viewDidCancelSwipe(_ view: UIView) -> Void{
//        print("You couldn't decide on \(self.currentPerson.Name)");
    }
    
    // This is called then a user swipes the view fully left or right.
    func view(_ view: UIView, wasChosenWith wasChosenWithDirection: MDCSwipeDirection) -> Void{
        
        // MDCSwipeToChooseView shows "NOPE" on swipes to the left,
        // and "LIKED" on swipes to the right.
        if(wasChosenWithDirection == MDCSwipeDirection.left){
//            print("You noped: \(self.currentPerson.Name)")
        }
        else{
            
//            print("You liked: \(self.currentPerson.Name)")
        }
        
        // MDCSwipeToChooseView removes the view from the view hierarchy
        // after it is swiped (this behavior can be customized via the
        // MDCSwipeOptions class). Since the front card view is gone, we
        // move the back card to the front, and create a new back card.
        if(self.backCardView != nil){
            self.setMyFrontCardView(self.backCardView)
        }
        
        backCardView = self.popPersonViewWithFrame(self.backCardViewFrame())
        //if(true){
        // Fade the back card into view.
        if(backCardView != nil){
            self.backCardView.alpha = 0.0
            cardsContainer.insertSubview(self.backCardView, belowSubview: self.frontCardView)
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions(), animations: {
                self.backCardView.alpha = 1.0
            },completion:nil)
        }
    }
    
    func setMyFrontCardView(_ frontCardView:ChoosePersonView) -> Void{
        // Keep track of the person currently being chosen.
        // Quick and dirty, just for the purposes of this sample app.
        self.frontCardView = frontCardView
        self.currentPerson = frontCardView.person
    }
    
    func popPersonViewWithFrame(_ frame:CGRect) -> ChoosePersonView? {
        if(self.people.count == 0){
            return nil;
        }
        
        // UIView+MDCSwipeToChoose and MDCSwipeToChooseView are heavily customizable.
        // Each take an "options" argument. Here, we specify the view controller as
        // a delegate, and provide a custom callback that moves the back card view
        // based on how far the user has panned the front card view.
        let options:MDCSwipeToChooseViewOptions = MDCSwipeToChooseViewOptions()
        options.delegate = self
        //options.threshold = 160.0
        options.onPan = { state -> Void in
            if(self.backCardView != nil) {
                let frame:CGRect = self.frontCardViewFrame()
                self.backCardView.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: frame.height)
            }
        }
        
        // Create a personView with the top person in the people array, then pop
        // that person off the stack.
        
        let personView:ChoosePersonView = ChoosePersonView(frame: frame, person: self.people[0], options: options)
        self.people.remove(at: 0)
        self.showHideControlPanel()
        return personView
    }
    
    func frontCardViewFrame() -> CGRect{
        let horizontalPadding:CGFloat = 20.0
//        let topPadding:CGFloat = 20.00
        let bottomPadding:CGFloat = 60.0
        return CGRect(x: horizontalPadding,y: 0,width: middleContainer.frame.size.width - (horizontalPadding * 2), height: middleContainer.frame.size.height - bottomPadding)
    }
    
    func backCardViewFrame() ->CGRect{
        let frontFrame:CGRect = frontCardViewFrame()
        return CGRect(x: frontFrame.origin.x, y: frontFrame.origin.y, width: frontFrame.width, height: frontFrame.height)
    }

    
    func constructNopeButton() -> Void{
        let height:CGFloat = 60.0
        let button:UIButton =  UIButton(type: UIButtonType.system)
        let image:UIImage = UIImage(named:"window-shopping-page-v01_31")!
        button.frame = CGRect(x: ChoosePersonButtonHorizontalPadding, y: self.middleContainer.frame.size.height - height, width:height, height: height)
        button.setImage(image, for: UIControlState())
        button.tintColor = UIColor(red: 247.0/255.0, green: 91.0/255.0, blue: 37.0/255.0, alpha: 1.0)
        button.addTarget(self, action: #selector(self.nopeFrontCardView), for: UIControlEvents.touchUpInside)
        middleContainer.addSubview(button)
    }
    
    func constructLikedButton() -> Void{
        let height:CGFloat = 60.0
        let button:UIButton = UIButton(type: UIButtonType.system)
        let image:UIImage = UIImage(named:"window-shopping-page-v01_28")!
        button.frame = CGRect(x: self.view.frame.maxX - image.size.width - ChoosePersonButtonHorizontalPadding, y: self.middleContainer.frame.size.height - height, width:height, height: height)
        button.setImage(image, for:UIControlState())
        button.tintColor = UIColor(red: 29.0/255.0, green: 245.0/255.0, blue: 106.0/255.0, alpha: 1.0)
        button.addTarget(self, action: #selector(self.likeFrontCardView), for: UIControlEvents.touchUpInside)
        middleContainer.addSubview(button)
        
    }
    
    /*
    //MARK: MDCSwipeToChooseDelegate
    */
    
    func view(_ view: UIView!, shouldBeChosenWith direction: MDCSwipeDirection) -> Bool {
        switch direction {
        case MDCSwipeDirection.left:
            print("left")
        case MDCSwipeDirection.right:
            print("right")
        default:
            print("None")
        }
        return true
    }
    
    @IBAction func nopeFrontCardView() -> Void{
        updateUsers()
        Global.sharedInstance.addRightAnimation(self.frontCardView)
        self.frontCardView.mdc_swipe(MDCSwipeDirection.left)
    }
    
    @IBAction func likeFrontCardView() -> Void{
        updateUsers()
        Global.sharedInstance.addLeftAnimation(self.frontCardView)
        self.frontCardView.mdc_swipe(MDCSwipeDirection.right)
    }
    
    func updateUsers() {
        self.details.removeFirst()
        _WSListTableViewController.details = self.details
        _WSListTableViewController.tableView.reloadData()
    }
    
    
    //UISearchBar delegates
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("DidBeginEditing")
        if iscardsView == true {
            changeViewOption(self)
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        searchActive = false;
        print("EndEditing")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        searchActive = false;
        print("CancelClicked")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        searchActive = false;
        print("ButtonClicked")
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        if (searchText.characters.count > 2) {
            loadSearchData(searchText)
            
        } else {
            if (searchText.characters.count == 0){
                
            }
        }
    }
    
    func loadSearchData(_ keyword:String) {
        
        //Use Alamofire Next time
        
        var request = URLRequest(url: URL(string:"http://api.mermaidsdating.com/index.php")!)
        request.httpMethod = "POST"
        
        let tokenInfo = UserDefaults.standard.string(forKey: "token")
        
        var postString = "action=Search&"
        
        postString.append("vtoken=\(tokenInfo!)&")
        postString.append("keyword=\(keyword)")
        request.httpBody = postString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print(error!)
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print(responseString!)
            let jsonData = responseString?.data(using: .utf8)
            
            let json = try! JSONSerialization.jsonObject(with: jsonData!, options: .allowFragments) as! [String:Any]
            print(json)
//            searchArray = json
            
        }
        
        task.resume()
    }


    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
//        cardsContainer.removeFromSuperview()
//        listContainer.removeFromSuperview()
    }


}
