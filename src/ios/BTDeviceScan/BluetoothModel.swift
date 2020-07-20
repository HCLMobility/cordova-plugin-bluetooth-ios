/*
 This file is part of Bluetooth Project. It is subject to the license terms in the LICENSE file found in the top-level directory of this distribution and at https://github.com/michaeldorner/Bluetooth/blob/master/LICENSE. No part of Bluetooth Project, including this file, may be copied, modified, propagated, or distributed except according to the terms contained in the LICENSE file.
 */

import Foundation

class BluetoothModel: BluetoothDelegate {

    static let sharedInstance = BluetoothModel()

    private let bluetooth = Bluetooth()
    private var subscribers = [BluetoothDelegate]()
        
    public var availableDevices: [BluetoothDevice] {
        get {
            return bluetooth.availableDevices
        }
    }
    
    private init() {
        bluetooth.delegate = self
    }
    
    func receivedBluetoothNotification(notification: BluetoothNotification) {
        for subscriber in subscribers {
            subscriber.receivedBluetoothNotification(notification: notification)
        }
        print("BluetoothNotification: " + String(describing: notification))
    }
    
    public func turnBluetoothOn() {
        bluetooth.enableBluetooth()
        print("Bluetooth turned on")

    }
    
    public func turnBluetoothOff() {
        bluetooth.disableBluetooth()
        print("Bluetooth turned off")

    }
    
    public func bluetoothIsOn() -> Bool {
        return bluetooth.bluetoothIsEnabled()
    }
    
    public func startScanForDevices() {
        bluetooth.startScanForDevices()
        print("Bluetooth started scanning for new devices")

    }
    
    public func stopScan() {
        bluetooth.stopScan()
        print("Bluetooth stopped scanning")
    }
    
    public func isScanning() -> Bool {
        return bluetooth.isScanning()
    }
    
    public func subscribe(subscriber: BluetoothDelegate) {
        subscribers.append(subscriber)
    }
    
    public func unsubscribe(subscriber: BluetoothDelegate) {
        //todo: add remove
    }
    
}
