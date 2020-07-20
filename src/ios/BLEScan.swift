//
//  BLEScan.swift
//  BTDeviceScan

import UIKit

class BLEScan: NSObject, BluetoothDelegate {
    
    static let sharedBleScan = BLEScan()
    // MARK:- iVARS
    var btDeviceArray = [[String: Any]]()
    let bluetooth = Bluetooth()

    // MARK:- INITIALIZE
    public override init() {
        super.init()
        bluetooth.delegate = self
        bluetooth.enableBluetooth()
    }

    // MARK:- CUSTOM METHODS

    /* Start scan to search available bluetooth devices.*/
    func startBLEScan() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.bluetooth.startScanForDevices()
       }
    }
    /* Stop scanning the bluetooth devices*/
    func stopScan() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.bluetooth.stopScanForDevices()
        }
    }
    
    // MARK:- BLUETOOTH DELEGATE METHODS
    func receivedBluetoothNotification(notification: BluetoothNotification) {
        self.btDeviceArray.removeAll()
        for device in self.bluetooth.availableDevices {
            self.appendDevices(device: device)
        }
    }
    
    /** Append bluetooth device in the array */
    func appendDevices(device: BluetoothDevice) {
        var newDevice = [String: Any]()
        newDevice["class"] = device.majorClass
        newDevice["id"] = device.address
        newDevice["address"] = device.address
        newDevice["name"] = device.name
        newDevice["rssi"] = -80
        self.btDeviceArray.append(newDevice)
    }
}
