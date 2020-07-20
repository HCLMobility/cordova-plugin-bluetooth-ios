var exec = require('cordova/exec');

module.exports.startscan = function (arg0, success, error) {
    exec(success, error, 'BluetoothScan', 'startscan', [arg0]);
};

module.exports.getDeviceList = function (arg0, success, error) {
    exec(success, error, 'BluetoothScan', 'getDeviceList', [arg0]);
};

module.exports.stopScan = function (arg0, success, error) {
    exec(success, error, 'BluetoothScan', 'stopScan', [arg0]);
};

/*var blueToothScanName = "BluetoothScan";
var bluetoothScan = {  
  startScan: function(successCallback, errorCallback, params) {
    cordova.exec(successCallback, errorCallback, blueToothScanName, "startScan", [params]);
  },
  stopScan: function(successCallback, errorCallback) {
    cordova.exec(successCallback, errorCallback, blueToothScanName, "stopScan", []);
  },
  getDeviceList: function(successCallback, errorCallback, params) {
    cordova.exec(successCallback, errorCallback, blueToothScanName, "getDeviceList", [params]);
  }
}
module.exports = bluetoothScan;*/