//
//  SettingsViewController.swift
//  AmicaleINSA
//
//  Created by Arthur Papailhau on 01/03/16.
//  Copyright © 2016 Arthur Papailhau. All rights reserved.
//

import UIKit
import ImagePicker
import SWRevealViewController
import MBProgressHUD

class SettingsViewController: UIViewController, UITextFieldDelegate, ImagePickerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var usernameChatTextField: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var yearSpeGroupLabel: UILabel!
    
    
    @IBOutlet weak var pickerViewYearsINSA: UIPickerView!
    
    var savedMBProgressHUD = MBProgressHUD()
    
    var yearsINSA = [("1A - A", "394"),
                     ("1A - B", "396"),
                     ("1A - C", "357"),
                     ("1A - D", "41"),
                     ("1A - E", "356"),
                     ("1A - F", "223"),
                     ("1A - FAS", "218"),
                     ("1A - G", "43"),
                     ("1A - H", "360"),
                     ("1A - J", "353"),
                     ("1A - K", "1536"),
                     ("1A - M", "359"),
                     ("1A - N", "363"),
                     ("1A - Z", "45+362"),
                     ("1A - IBERINSA", "365+681"),
                     ("2-IC - A", "224"),
                     ("2-IC - B", "270"),
                     ("2-IC - C", "435"),
                     ("2-IC - D", "225"),
                     ("2-IC - E", "56"),
                     ("2-IC - FAS", "1489"),
                     ("2-ICBE - A", "211+213"),
                     ("2-ICBE - B", "214+219"),
                     ("2-ICBE - C", "243+249"),
                     ("2-IMACS - A", "1024+1549"),
                     ("2-IMACS - B", "1025+1550"),
                     ("2-IMACS - C", "1022+1551"),
                     ("2-IMACS - D", "534+535"),
                     ("2-MIC - A", "1027"),
                     ("2-MIC - B", "1030"),
                     ("2-MIC - C", "1031"),
                     ("2-MIC - D", "1028"),
                     ("3-IC - A", "1321+1322"),
                     ("3-IC - B", "1324+1325+1037"),
                     ("3-IC - C", "1327+1328"),
                     ("3-IC - D", "1330+1331"),
                     ("3-IC - E", "1335+1336"),
                     ("3-IC - F", "1339+1340"),
                     ("3-IC - G", "1459+1457"),
                     ("3-AGC", "9"),
                     ("4-IR-I - A", "1720+1721"),
                     ("4-IR-I - B", "1720+1721"),
                     ("4-IR-RT - A", "1724+1725")
                     ]
    
    let LIMITE_USERNAME_LENGTH = 12
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        
        let tapDismissKeyboard: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SettingsViewController.dismissKeyboard))
        view.addGestureRecognizer(tapDismissKeyboard)
        
        usernameChatTextField.delegate = self
        pickerViewYearsINSA.delegate = self
        
        usernameChatTextField.layer.cornerRadius = 8.0
        usernameChatTextField.layer.masksToBounds = true
        usernameChatTextField.layer.borderColor = UIColor.redColor().CGColor
        usernameChatTextField.layer.borderWidth = 2.0
        
        usernameChatTextField.attributedPlaceholder = NSAttributedString(string: Storyboard.usernameChat, attributes: [NSForegroundColorAttributeName: UIColor(red: 100, green: 0, blue: 0, alpha: 0.4)])
        
        // pickerView set default row
        let defautlRowPickerView = NSUserDefaults.standardUserDefaults().integerForKey(Storyboard.rowPickerViewSettings)
        pickerViewYearsINSA.selectRow(defautlRowPickerView, inComponent: 0, animated: true)
        
        // Year spe group
        yearSpeGroupLabel.text = yearsINSA[defautlRowPickerView].0
        yearSpeGroupLabel.layer.cornerRadius = 8.0
        yearSpeGroupLabel.layer.masksToBounds = true
        yearSpeGroupLabel.layer.borderColor = UIColor.redColor().CGColor
        yearSpeGroupLabel.layer.borderWidth = 2.0
    }
    
    override func viewDidAppear(animated: Bool) {
        profileImageView.image = getProfilPicture()
    }
    
    func profilePictureSelected() {
        let imagePickerController = ImagePickerController()
        imagePickerController.imageLimit = 1
        imagePickerController.delegate = self
        self.presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    /*
        PickerView delegate
    */
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return yearsINSA.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return yearsINSA[row].0
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let idPlanningExpress = yearsINSA[row].1
        let yearSpeGroupString = yearsINSA[row].0
        yearSpeGroupLabel.text = yearSpeGroupString
        NSUserDefaults.standardUserDefaults().setInteger(row, forKey: Storyboard.rowPickerViewSettings)
        savedMBProgressHUDAction()
        setIDPlanningExpress(idPlanningExpress)
        setYearSpeGroupPlanningExpress(yearSpeGroupString)
    }
    
    /*
        MBProgressHUD
    */
    
    func savedMBProgressHUDAction(){
        savedMBProgressHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        savedMBProgressHUD.customView = UIImageView(image: UIImage(named: "37x-Checkmark.png"))
        savedMBProgressHUD.mode = MBProgressHUDMode.CustomView
        savedMBProgressHUD.labelText = "Saved!"
        savedMBProgressHUD.userInteractionEnabled = false
        savedMBProgressHUD.hide(true, afterDelay: 2)
    }
    
    
    /*
        Keyboard delegate
    */
    
    func dismissKeyboard() {
        setUsernameChat(usernameChatTextField.text!)
        view.endEditing(true)
    }

    
    private func initUI() {
        let tapOnProfilePicture = UITapGestureRecognizer(target: self, action: #selector(SettingsViewController.profilePictureSelected))
        profileImageView.addGestureRecognizer(tapOnProfilePicture)
        profileImageView.userInteractionEnabled = true
        let colorForBorder = UIColor.blackColor()
        profileImageView.layer.borderColor = colorForBorder.CGColor
        profileImageView.layer.borderWidth = 0.5
        profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
        self.profileImageView.clipsToBounds = true
    }
    
    /*
        Image Picker methodes delegate
    */
    
    func wrapperDidPress(images: [UIImage]) {
        print("wrapperDidPress")
    }
    
    func doneButtonDidPress(images: [UIImage]) {
        let pickedImage = images[0].imageRotatedByDegrees(90, flip: false)
        profileImageView.image = pickedImage
        setProfilPicture(pickedImage)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func cancelButtonDidPress() {
        print("cancel button pressed")
    }

    
    /*
        TextField methodes delegate
    */
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        setUsernameChat(usernameChatTextField.text!)
        savedMBProgressHUDAction()
        view.endEditing(true)
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        
        let newLength = text.utf16.count + string.utf16.count - range.length
        return newLength <= LIMITE_USERNAME_LENGTH
    }
    
    override func viewWillAppear(animated: Bool) {
        usernameChatTextField.text = getUsernameChat()
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}