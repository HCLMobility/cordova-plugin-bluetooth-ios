/*
 This file is part of Bluetooth Project. It is subject to the license terms in the LICENSE file found in the top-level directory of this distribution and at https://github.com/michaeldorner/Bluetooth/blob/master/LICENSE. No part of Bluetooth Project, including this file, may be copied, modified, propagated, or distributed except according to the terms contained in the LICENSE file.
 */

import Foundation


public enum BluetoothNotification: String {
    case PowerChanged               = "BluetoothPowerChangedNotification"
    case AvailabilityChanged        = "BluetoothAvailabilityChangedNotification"
    case DeviceDiscovered           = "BluetoothDeviceDiscoveredNotification"
    case DeviceRemoved              = "BluetoothDeviceRemovedNotification"
    case ConnectabilityChanged      = "BluetoothConnectabilityChangedNotification"
    case DeviceUpdated              = "BluetoothDeviceUpdatedNotification"
    case DiscoveryStateChanged      = "BluetoothDiscoveryStateChangedNotification"
    case DeviceConnectSuccess       = "BluetoothDeviceConnectSuccessNotification"
    case ConnectionStatusChanged    = "BluetoothConnectionStatusChangedNotification"
    case DeviceDisconnectSuccess    = "BluetoothDeviceDisconnectSuccessNotification"
    
    public static let allNotifications: [BluetoothNotification] = [.PowerChanged, .AvailabilityChanged, .DeviceDiscovered, .DeviceRemoved, .ConnectabilityChanged, .DeviceUpdated, .DiscoveryStateChanged, .DeviceConnectSuccess, .ConnectionStatusChanged, .DeviceDisconnectSuccess]
}



public protocol BluetoothDelegate {
    func receivedBluetoothNotification(notification: BluetoothNotification)
}



public class Bluetooth {
    
    public var delegate: BluetoothDelegate? = nil
    public var availableDevices: [BluetoothDevice] {
        get {
            return Array(_availableDevices)
        }
    }
    
    private let bluetoothManagerHandler = BluetoothManagerHandler.sharedInstance()!
    private var _availableDevices = Set<BluetoothDevice>()
    private var tokenCache = [BluetoothNotification: NSObjectProtocol]()
    
    public init() {
        
        for bluetoothNotification in BluetoothNotification.allNotifications {
            print("Registered \(bluetoothNotification)")
            
            let notification = NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: bluetoothNotification.rawValue), object: nil, queue: OperationQueue.main) { [unowned self] (notification) in
                let bluetoothNotification = BluetoothNotification.init(rawValue: notification.name.rawValue)!
                switch bluetoothNotification {
                case .DeviceDiscovered:
                    print("DeviceDiscovered from bluetooth class")
                    
                    let bluetoothDevice = self.extractBluetoothDevice(from: notification)
                    self._availableDevices.insert(bluetoothDevice)
                    print(bluetoothDevice)
                case .DeviceRemoved:
                    let bluetoothDevice = self.extractBluetoothDevice(from: notification)
                    self._availableDevices.remove(bluetoothDevice)
                default:
                    break
                }
                if (self.delegate != nil) {
                    self.delegate?.receivedBluetoothNotification(notification: bluetoothNotification)
                }
            }
            self.tokenCache[bluetoothNotification] = notification
        }
    }
    
    deinit {
        for key in tokenCache.keys {
            NotificationCenter.default.removeObserver(tokenCache[key]!)
        }
    }
    
    public func enableBluetooth() {
        bluetoothManagerHandler.enable()
    }
    
    public func disableBluetooth() {
        bluetoothManagerHandler.disable()
    }

    public func bluetoothIsEnabled() -> Bool {
        return bluetoothManagerHandler.enabled()
    }
    
    public func startScanForDevices() {
        bluetoothManagerHandler.startScan()
    }
    
    public func stopScan() {
        bluetoothManagerHandler.stopScan()
        resetAvailableDevices()
    }
    public func stopScanForDevices() {
        bluetoothManagerHandler.stopScan()
    }
    public func isScanning() -> Bool {
        return bluetoothManagerHandler.isScanning()
    }
    
    public static func debugLowLevel() {
        print("This is a dirty C hack and only for demonstration and deep debugging, but not for production.") // credits to http://stackoverflow.com/a/3738387/1864294
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                        nil,
                                        { (_, observer, name, _, _) in
                                            let n = name?.rawValue as! String
                                            if n.hasPrefix("B") { // notice only notification they are associated with the BluetoothManager.framework
                                               print("Received notification: \(name)")
                                            }
                                        },
                                        nil,
                                        nil,
                                        .deliverImmediately)
    }
    
    private func resetAvailableDevices() {
        _availableDevices.removeAll()
    }
    
    private func extractBluetoothDevice(from notification: Notification) -> BluetoothDevice {
        let bluetoothDeviceHandler = BluetoothDeviceHandler(notification: notification)!
        let bluetoothDevice = BluetoothDevice(name: bluetoothDeviceHandler.name, address: bluetoothDeviceHandler.address, majorClass: bluetoothDeviceHandler.majorClass, minorClass: bluetoothDeviceHandler.minorClass, type: bluetoothDeviceHandler.type, supportsBatteryLevel: bluetoothDeviceHandler.supportsBatteryLevel, detectingDate: Date())
        print("extractBluetoothDevice")
        print(bluetoothDevice)
        return bluetoothDevice
    }
}

