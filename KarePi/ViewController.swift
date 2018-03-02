//
//  ViewController.swift
//  KarePi
//
//  Created by Taka Omori on 01/03/2018.
//  Copyright © 2018 Taka Omori. All rights reserved.
//

import UIKit
import CoreLocation
import AudioToolbox

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var myLocationManager:CLLocationManager!
    var myBeaconRegion:CLBeaconRegion!
    var beaconUuids: NSMutableArray!
    var beaconDetails: NSMutableArray!
    var count = 0
    var flag = false
    let UUIDList = [
        "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0",
        "01A90E66-6523-460C-AA88-F047B407CB18",
        "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0",
        "01A90E66-6523-460C-AA88-F047B407CB18",
        "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0",
        "01A90E66-6523-460C-AA88-F047B407CB18",
        "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0",
        "01A90E66-6523-460C-AA88-F047B407CB18",
        "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0",
        "01A90E66-6523-460C-AA88-F047B407CB18"
    ]
    
    @IBOutlet weak var label1: UILabel!
    
    @IBOutlet weak var label2: UILabel!
    
    
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var Switch: UISwitch!
    
    @IBAction func testUISwitch(sender: UISwitch) {
        if ( sender.isOn ) {
            flag = true
        } else {
            flag = false
            
        }
    }
    @IBOutlet weak var imageboard: UIImageView!
    
    
    
    
    
    override func viewDidLoad() {
        label1.textAlignment = .center // 中央揃え
        label3.textAlignment = .center // 中央揃え
        
        super.viewDidLoad()
        myLocationManager = CLLocationManager()
        myLocationManager.delegate = self
        myLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        myLocationManager.distanceFilter = 1
        let status = CLLocationManager.authorizationStatus()
        print("CLAuthorizedStatus: \(status.rawValue)");
        if(status == .notDetermined) {
            myLocationManager.requestAlwaysAuthorization()
        }
        beaconUuids = NSMutableArray()
        beaconDetails = NSMutableArray()
    }
    
    private func startMyMonitoring() {
        //let i = arc4random()%10
        //label2.text = String(i)
        let i = 0
        let uuid: NSUUID! = NSUUID(uuidString: "\(UUIDList[Int(i)].lowercased())")
        let identifierStr: String = "abcde\(i)"
        myBeaconRegion = CLBeaconRegion(proximityUUID: uuid as UUID, identifier: identifierStr)
        myBeaconRegion.notifyEntryStateOnDisplay = false
        myBeaconRegion.notifyOnEntry = true
        myBeaconRegion.notifyOnExit = true
        myLocationManager.startMonitoring(for: myBeaconRegion)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("didChangeAuthorizationStatus");
        switch (status) {
        case .notDetermined:
            print("not determined")
            break
        case .restricted:
            print("restricted")
            break
        case .denied:
            print("denied")
            break
        case .authorizedAlways:
            print("authorizedAlways")
            startMyMonitoring()
            break
        case .authorizedWhenInUse:
            print("authorizedWhenInUse")
            startMyMonitoring()
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        manager.requestState(for: region);
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        switch (state) {
        case .inside:
            print("iBeacon inside");
            manager.startRangingBeacons(in: region as! CLBeaconRegion)
            break;
        case .outside:
            print("iBeacon outside")
            break;
        case .unknown:
            print("iBeacon unknown")
            break;
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        beaconUuids = NSMutableArray()
        beaconDetails = NSMutableArray()
        let image_cry = UIImage(named: "woman04_cry")
        let image_smile = UIImage(named: "woman03_smile")
        let image_laugh = UIImage(named: "woman01_laugh")
        let image_cry_boy = UIImage(named: "man04_cry")
        let image_smile_boy = UIImage(named: "man03_smile")
        let image_laugh_boy = UIImage(named: "man01_laugh")
        let image_angry = UIImage(named: "woman02_angry")
        let image_angry_boy = UIImage(named: "man02_angry")
        
        if(beacons.count > 0){
            for i in 0 ..< beacons.count {
                
                let beacon = beacons[i]
                let beaconUUID = beacon.proximityUUID;
                let minorID = beacon.minor;
                let majorID = beacon.major;
                let rssi = beacon.rssi;
                
                var proximity = ""
                var found = "マッチングできませんでした。。。"
                switch (beacon.proximity) {
                case CLProximity.unknown :
                    print("Proximity: Unknown");
                    proximity = "どこにいるかわかんない！"
                    //found = ""
                    flag = false
                    if(Switch.isOn){
                        imageboard.image = image_angry
                    }else{
                        imageboard.image = image_angry_boy
                    }
                    break
                case CLProximity.far:
                    print("Proximity: Far");
                    proximity = "ちょっと遠いかな？"
                    found = "見つかりました！！！！"
                    if(Switch.isOn){
                        imageboard.image = image_cry
                    }else{
                        imageboard.image = image_cry_boy
                    }
                    break
                    
                case CLProximity.near:
                    print("Proximity: Near");
                    proximity = "近くにいるよ！"
                    found = "見つかりました！！！！"
                    if(Switch.isOn){
                        imageboard.image = image_smile
                    }else{
                        imageboard.image = image_smile_boy
                    }
                    break
                    
                case CLProximity.immediate:
                    print("Proximity: Immediate");
                    proximity = "めっちゃ近いです！"
                    found = "見つかりました！！！！"
                    if(Switch.isOn){
                        imageboard.image = image_laugh
                    }else{
                        imageboard.image = image_laugh_boy
                    }
                    AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))//バイブ
                    break
                }
                
                beaconUuids.add(beaconUUID.uuidString)
                var myBeaconDetails = "Major: \(majorID) "
                myBeaconDetails += "Minor: \(minorID) "
                myBeaconDetails += "Proximity:\(proximity) "
                myBeaconDetails += "RSSI:\(rssi)"
                print(myBeaconDetails)
                beaconDetails.add(myBeaconDetails)
                label1.text = proximity
                label3.text = found
                
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("didEnterRegion: iBeacon found");
        
        manager.startRangingBeacons(in: region as! CLBeaconRegion)
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("didExitRegion: iBeacon lost");
        
        manager.stopRangingBeacons(in: region as! CLBeaconRegion)
    }
}


