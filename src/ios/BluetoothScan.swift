@objc(BluetoothScan) class BluetoothScan : CDVPlugin {

    override init() {
        super.init()
    }
    
   /* CDVPlugin interface to start scanning*/
  @objc(startscan:) func startscan(command: CDVInvokedUrlCommand) {
      var pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR)
      BLEScan.sharedBleScan.startBLEScan()
      let msg = command.arguments[0] as? String ?? "Scan Started"
      pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: msg)
      self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
  }

  /* CDVPlugin interface to getDeviceList*/
  @objc(getDeviceList:) func getDeviceList(command: CDVInvokedUrlCommand) {
    var pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR)
    pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: BLEScan.sharedBleScan.btDeviceArray)
    print("Plugin device count is: \(BLEScan.sharedBleScan.btDeviceArray.count)")
    self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
  }

/* CDVPlugin interface to stop scanning*/
  @objc(stopScan:) func stopScan(command: CDVInvokedUrlCommand) {
    var pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR)
    let msg = command.arguments[0] as? String ?? "Scan Stopped"
    BLEScan.sharedBleScan.stopScan()
    pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: msg)
    self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
  }
}

