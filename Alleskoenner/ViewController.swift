

import UIKit
import CoreLocation
import UserNotifications

class ViewController: UIViewController, CLLocationManagerDelegate, UNUserNotificationCenterDelegate{
    
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var BoardName: UILabel!
    
    let locationManager = CLLocationManager()
    
    let region = CLBeaconRegion(proximityUUID: UUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!, identifier: "Estimotes")
    let colors = [
        
        47229: UIColor(red: 84/255, green: 77/255, blue: 160/255, alpha: 1 ),  //lila
        5856 : UIColor(red: 84/255, green: 77/255, blue: 160/255, alpha: 1),  //lila
        51128: UIColor(red: 84/255, green: 77/255, blue: 160/255, alpha: 1),  //lila
        
        20915: UIColor(red: 142/255, green: 212/255, blue: 220/255, alpha: 1), //blau
        30602: UIColor(red: 142/255, green: 212/255, blue: 220/255, alpha: 1), //blau
        
        33062: UIColor(red: 162/255, green: 213/255, blue: 181/255, alpha: 1), //mint
        6505: UIColor(red: 162/255, green: 213/255, blue: 181/255, alpha: 1),  //mint
        39969: UIColor(red: 162/255, green: 213/255, blue: 181/255, alpha: 1), //mint
        
        
    ]
    
    let Boarddefinition = [
        
        47229: "Board 1", //lila
        5856 : "Board 2",  //lila
        51128: "Board 3",  //lila
        
        20915:"Board 4", //blau
        30602: "Board 5", //blau
        
        33062: "Andy", //mint
        6505: "Julian",  //mint
        39969: "Tim", //mint
        
        
        
    ]
    
    func update(distance: CLProximity) {
        UIView.animate(withDuration: 0.8) { [unowned self] in
            switch distance {
            case .unknown:
                self.distanceLabel.text = "UNKNOWN"
                
            case .far:
                self.distanceLabel.text = "FAR"
                
            case .near:
                self.distanceLabel.text = "NEAR"
                
            case .immediate:
                self.distanceLabel.text = "RIGHT HERE"
            }
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedWhenInUse) {
            locationManager.requestWhenInUseAuthorization()
            
            
        }
        self.startranging()
         locationManager.startRangingBeacons(in: region)
        
    }
    
    
    
    func startranging () {
        
        //let region = CLBeaconRegion (proximityUUID: UUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!, identifier: "Estimotes")
        region.notifyOnEntry = true
        region.notifyOnExit = false
        
        
        let trigger = UNLocationNotificationTrigger(region: region, repeats: true)
        
        
        let content = UNMutableNotificationContent()
        content.title = "Beacon is close"
        content.body = "click to check where it is "
        
        
        
        let identifier = "MyBeacons"
        let request = UNNotificationRequest.init(identifier: identifier, content: content, trigger: trigger)
        
        
        
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
            
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().add(request) {(error) in
                
                if let error = error {
                    print("Uh oh! We had an error: \(error)")
                }
            }
            
        })
    
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        completionHandler()
        
        
        func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            completionHandler([.alert, .sound])
        }
        
    }
    
 
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if beacons.count > 0 {
            let closestBeacon = beacons[0]
            update(distance: closestBeacon.proximity)
            self.view.backgroundColor = self.colors[closestBeacon.minor.intValue]
            self.BoardName.text = self.Boarddefinition[closestBeacon.minor.intValue]
            
        } else {
            update(distance: .unknown)
        }
    }
    
    }
    

























