//
//  WebPlanningViewController.swift
//  AmicaleINSA
//
//  Created by Arthur Papailhau on 29/02/16.
//  Copyright © 2016 Arthur Papailhau. All rights reserved.
//

import UIKit
import SwiftSpinner
import SWRevealViewController

class WebPlanningViewController: UIViewController, UIWebViewDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var menuButton:UIBarButtonItem!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var ActualBarButtonItem: UIBarButtonItem!
    var weekNumberToday : Int = 0 {
        didSet {
            print("weekNumberToday: \(oldValue) -> \(weekNumberToday)")
        }
    }
    var debug = false
    let offsetScroll = CGFloat(190)
    var AmITheCurrentWeek = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
        
        self.navigationController?.navigationBar.isTranslucent = false
        
        // set delegate
        self.webView.delegate = self
        self.webView.scrollView.delegate = self
        
        weekNumberToday = getWeekNumber()
        print("week number: \(weekNumberToday)")
        let url = URL(string: getUrlPlanning(weekNumberToday))
        if url?.absoluteString != Public.noGroupINSA {
            let request = URLRequest(url: url!)
            webView.loadRequest(request)
        } else {
            self.performSegue(withIdentifier: Public.segueFromPlanningToSettings, sender: self)
        }
        
        initUI()
    }
    
    func initUI(){
        ActualBarButtonItem.title = getYearSpeGroupPlanningExpress()
    }
    
    
    func setLandscapeOrientation(){
        let value = UIInterfaceOrientation.landscapeLeft.rawValue;
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        if (debug) {
            print("[WebPlanningViewController][webViewDidStartLoad] I start loading my page")
        }
        SwiftSpinner.show("Connexion \nen cours...").addTapHandler({
            SwiftSpinner.hide()
        })
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        let offSetOfDay = getOffsetOfDay()
        if (debug) {
            print("[WebPlanningViewController][webViewDidFinishLoad] I stop loading my page")
        }
        SwiftSpinner.hide()
        
        self.webView.scrollView.setZoomScale(getZoomValue(), animated: true)
        if debug {
            print("getOffSet: \(offSetOfDay)")
        }
        self.webView.scrollView.contentOffset = CGPoint(x: offSetOfDay, y: 0)
        
    }
    
    func getZoomValue() -> CGFloat {
        if AmITheCurrentWeek {
            let currentLang = Device.CURRENT_LANGUAGE
            let dayOfWeek = getDayOfWeek()
            if (currentLang == "en"){
                if (dayOfWeek == "Saturday") || (dayOfWeek == "Sunday"){
                    return 0
                } else {
                    return 3
                }
            } else {
                if (dayOfWeek == "samedi") || (dayOfWeek == "dimanche"){
                    return 0
                } else {
                    return 3
                }
            }
        } else {
            return 0
        }
    }
    
    func getIphoneSizeScreen() -> String{
        return Device.CURRENT_SIZE
    }
    
    func getOffsetOfDay() -> CGFloat{
        var dayValueOffset = 0
        let iPhoneSizeScreen = getIphoneSizeScreen()
        if debug {
            print("getDayOfWeek: \(getDayOfWeek())")
        }
        let currentLang = Device.CURRENT_LANGUAGE
        if (currentLang == "en"){
            if (iPhoneSizeScreen == "iPhone6"){
                switch getDayOfWeek() {
                case "Monday":
                    dayValueOffset = Public.Monday_iPhone6
                case "Tuesday":
                    dayValueOffset = Public.Tuesday_iPhone6
                case "Wednesday":
                    dayValueOffset = Public.Wednesday_iPhone6
                case "Thursday":
                    dayValueOffset = Public.Thursday_iPhone6
                case "Friday":
                    dayValueOffset = Public.Friday_iPhone6
                default:
                    dayValueOffset = Public.Weekend_iPhone6
                }
            } else if (iPhoneSizeScreen == "iPhone6+"){
                switch getDayOfWeek() {
                case "Monday":
                    dayValueOffset = Public.Monday_iPhone6Plus
                case "Tuesday":
                    dayValueOffset = Public.Tuesday_iPhone6Plus
                case "Wednesday":
                    dayValueOffset = Public.Wednesday_iPhone6Plus
                case "Thursday":
                    dayValueOffset = Public.Thursday_iPhone6Plus
                case "Friday":
                    dayValueOffset = Public.Friday_iPhone6Plus
                default:
                    dayValueOffset = Public.Weekend_iPhone6Plus
                }
                
            } else if (iPhoneSizeScreen == "iPhone5"){
                switch getDayOfWeek() {
                case "Monday":
                    dayValueOffset = Public.Monday_iPhone5
                case "Tuesday":
                    dayValueOffset = Public.Tuesday_iPhone5
                case "Wednesday":
                    dayValueOffset = Public.Wednesday_iPhone5
                case "Thursday":
                    dayValueOffset = Public.Thursday_iPhone5
                case "Friday":
                    dayValueOffset = Public.Friday_iPhone5
                default:
                    dayValueOffset = Public.Weekend_iPhone5
                }
            } else if (iPhoneSizeScreen == "iPhone4"){
                switch getDayOfWeek() {
                case "Monday":
                    dayValueOffset = Public.Monday_iPhone4
                case "Tuesday":
                    dayValueOffset = Public.Tuesday_iPhone4
                case "Wednesday":
                    dayValueOffset = Public.Wednesday_iPhone4
                case "Thursday":
                    dayValueOffset = Public.Thursday_iPhone4
                case "Friday":
                    dayValueOffset = Public.Friday_iPhone4
                default:
                    dayValueOffset = Public.Weekend_iPhone4
                }
            }
        } else {
            if (iPhoneSizeScreen == "iPhone6"){
                switch getDayOfWeek() {
                case "lundi":
                    dayValueOffset = Public.Monday_iPhone6
                case "mardi":
                    dayValueOffset = Public.Tuesday_iPhone6
                case "mercredi":
                    dayValueOffset = Public.Wednesday_iPhone6
                case "jeudi":
                    dayValueOffset = Public.Thursday_iPhone6
                case "vendredi":
                    dayValueOffset = Public.Friday_iPhone6
                default:
                    dayValueOffset = Public.Weekend_iPhone6
                }
            } else if (iPhoneSizeScreen == "iPhone6+"){
                switch getDayOfWeek() {
                case "lundi":
                    dayValueOffset = Public.Monday_iPhone6Plus
                case "mardi":
                    dayValueOffset = Public.Tuesday_iPhone6Plus
                case "mercredi":
                    dayValueOffset = Public.Wednesday_iPhone6Plus
                case "jeudi":
                    dayValueOffset = Public.Thursday_iPhone6Plus
                case "vendredi":
                    dayValueOffset = Public.Friday_iPhone6Plus
                default:
                    dayValueOffset = Public.Weekend_iPhone6Plus
                }
                
            } else if (iPhoneSizeScreen == "iPhone5"){
                switch getDayOfWeek() {
                case "lundi":
                    dayValueOffset = Public.Monday_iPhone5
                case "mardi":
                    dayValueOffset = Public.Tuesday_iPhone5
                case "mercredi":
                    dayValueOffset = Public.Wednesday_iPhone5
                case "jeudi":
                    dayValueOffset = Public.Thursday_iPhone5
                case "vendredi":
                    dayValueOffset = Public.Friday_iPhone5
                default:
                    dayValueOffset = Public.Weekend_iPhone5
                }
            } else if (iPhoneSizeScreen == "iPhone4"){
                switch getDayOfWeek() {
                case "lundi":
                    dayValueOffset = Public.Monday_iPhone4
                case "mardi":
                    dayValueOffset = Public.Tuesday_iPhone4
                case "mercredi":
                    dayValueOffset = Public.Wednesday_iPhone4
                case "jeudi":
                    dayValueOffset = Public.Thursday_iPhone4
                case "vendredi":
                    dayValueOffset = Public.Friday_iPhone4
                default:
                    dayValueOffset = Public.Weekend_iPhone4
                }
            }
        }
        if debug {
            print("current size: \(Device.CURRENT_SIZE)")
        }
        return CGFloat(dayValueOffset)
    }
    
    func getDayOfWeekSimple() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let dayOfWeekString = dateFormatter.string(from: date)
        return dayOfWeekString
    }
    
    func getDayOfWeek() -> String{
        var date = Date()
        if shouldGoTomorrow() && getDayOfWeekSimple() != "Sunday" && getDayOfWeekSimple() != "dimanche" {
            date = date.addDays(1)
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let dayOfWeekString = dateFormatter.string(from: date)
        
        return dayOfWeekString
    }
    
    fileprivate func getHourString() -> String {
        let date = Date();
        let formatter = DateFormatter();
        formatter.dateFormat = "h:mm a";
        let defaultTimeZoneStr = formatter.string(from: date);
        return defaultTimeZoneStr
    }
    
    fileprivate func shouldGoTomorrow() -> Bool {
        let currentHourString = getHourString()
        print("current hour string: \(currentHourString)")
        let hourStringToCompare = "07:00 PM"
        let formatter = DateFormatter();
        formatter.dateFormat = "h:mm a";
        let currentDate = formatter.date(from: currentHourString)
        let dateToCompare = formatter.date(from: hourStringToCompare)
        return currentDate!.isGreaterThanDate(dateToCompare!)
    }
    
    func segueToSettingsIfNeeded(){
        if !getBeenToSettingsOnce() {
            self.performSegue(withIdentifier: Public.segueBeenToSettingsOnce, sender: self)
        }
    }
    
    
    func getUrlPlanning(_ weekNumber: Int) -> String {
        let IDWebPlanning = getIDPlanningExpress()
        if IDWebPlanning == "" || IDWebPlanning == Public.noGroupINSA {
            return Public.noGroupINSA
        } else {
            if debug {
                print("https://www.etud.insa-toulouse.fr/planning/index.php?gid=\(IDWebPlanning)&wid=\(weekNumber)&platform=ios")
            }
            return "https://www.etud.insa-toulouse.fr/planning/index.php?gid=\(IDWebPlanning)&wid=\(weekNumber)&platform=ios"
        }
    }
    
    func getWeekNumber() -> Int {
        let calender = Calendar.current
        let dateComponent = (calender as NSCalendar).component(NSCalendar.Unit.weekOfYear, from: Date())
        print("date: \(Date())")
        let dayOfWeek = getDayOfWeek()
        if debug {
            print("date component: \(dateComponent)")
            print("dayOfWeek = \(dayOfWeek)")
        }
        if (dayOfWeek == "Saturday" || dayOfWeek == "samedi" || dayOfWeek == "Sunday" || dayOfWeek == "dimanche"){
            return dateComponent + 1
        } else {
            return dateComponent
        }
    }
    
    func getWeekNumberForZoom() -> Int {
        let calender = Calendar.current
        let dateComponent = (calender as NSCalendar).component(NSCalendar.Unit.weekOfYear, from: Date())
        return dateComponent
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override var shouldAutorotate : Bool {
        return false
    }
    
    // MARK: Network
    
    @IBAction func nextWeekButtonAction(_ sender: AnyObject) {
        weekNumberToday += 1
        AmITheCurrentWeek = false
        if let url = URL(string: getUrlPlanning(weekNumberToday)) {
            let request = URLRequest(url: url)
            webView.loadRequest(request)
        } else {
            let url = URL(string:"https://www.etud.insa-toulouse.fr/planning/index.php")
            let request = URLRequest(url: url!)
            webView.loadRequest(request)
        }
    }
    
    @IBAction func lastWeekButtonAction(_ sender: AnyObject) {
        weekNumberToday -= 1
        AmITheCurrentWeek = false
        if let url = URL(string: getUrlPlanning(weekNumberToday)) {
            let request = URLRequest(url: url)
            webView.loadRequest(request)
        } else {
            let url = URL(string:"https://www.etud.insa-toulouse.fr/planning/index.php")
            let request = URLRequest(url: url!)
            webView.loadRequest(request)
        }
    }
    
    @IBAction func todayWeekButtonAction(_ sender: AnyObject) {
        AmITheCurrentWeek = true
        weekNumberToday = getWeekNumber()
        if let url = URL(string: getUrlPlanning(weekNumberToday)) {
            let request = URLRequest(url: url)
            webView.loadRequest(request)
        } else {
            let url = URL(string:"https://www.etud.insa-toulouse.fr/planning/index.php")
            let request = URLRequest(url: url!)
            webView.loadRequest(request)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Public.segueFromPlanningToSettings {
            let settingsVC = segue.destination as! SettingsTableViewController
            settingsVC.comeFromWebPlanningBecauseNoGroupSelected = true
        }
    }
    
}
