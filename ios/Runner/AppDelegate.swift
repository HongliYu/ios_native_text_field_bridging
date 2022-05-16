import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        let deviceRegionChannel = FlutterMethodChannel(name: "com.justetf.justetf/region",
                                                       binaryMessenger: controller.binaryMessenger)
        let searchBarChannel = FlutterMethodChannel(name: "com.justetf.justetf/search_bar",
                                                       binaryMessenger: controller.binaryMessenger)
        globalSearchBarChannel = searchBarChannel

        deviceRegionChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            guard call.method == "getDeviceRegion" else {
                result(FlutterMethodNotImplemented)
                return
            }
            self.receiveDeviceRegion(result: result)
        })
        
        searchBarChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            switch call.method {
            case "setSearchBarTextFieldPlaceHolder":
                guard let myresult = call.arguments as? [String: Any],
                      let placeholder = myresult["placeholder"] as? String else { return }
                self.receiveSetSearchBarTextFieldPlaceHolder(result: result, placeholder: placeholder)
            case "setSearchBarText":
                guard let myresult = call.arguments as? [String: Any],
                      let text = myresult["text"] as? String else { return }
                self.receiveSetSearchBarText(result: result, text: text)
            case "setFocusSearchBar":
                guard let myresult = call.arguments as? [String: Any],
                      let isFocus = myresult["isFocus"] as? Bool else { return }
                self.receiveSetFocusSearchBar(result: result, isFocus: isFocus)
            default: break
            }
        })
        let nativeViewFactory = NativeSearchBarTextFieldFactory()
        registrar(forPlugin: "Runner")?.register(nativeViewFactory, withId: "NativeSearchBarTextField")
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    /// There is an issue by flutter, which does not set the right region, if a language with region parameter behind (for example: Italy (Italian)) is selected.
    private func receiveDeviceRegion(result: FlutterResult) {
        guard let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String
        else { return result("DE") }
        return result(countryCode)
    }
    
    private func receiveSetSearchBarTextFieldPlaceHolder(result: FlutterResult, placeholder: String) {
        globalSetSearchBarTextFieldPlaceHolder?(placeholder)
        return result("receiveSetSearchBarTextFieldPlaceHolder called")
    }
    
    private func receiveSetSearchBarText(result: FlutterResult, text: String) {
        globalSetSearchBarText?(text)
        return result("receiveSetSearchBarText called")
    }
        
    private func receiveSetFocusSearchBar(result: FlutterResult, isFocus: Bool) {
        globalSetFocusSearchBar?(isFocus)
        return result("receiveSetFocusSearchBar called")
    }
    
}

var globalSearchBarChannel: FlutterMethodChannel?
var globalSetSearchBarTextFieldPlaceHolder: ((_ placehoder: String) -> ())?
var globalSetSearchBarText: ((_ searchBarText: String) -> ())?
var globalSetFocusSearchBar: ((_ isFocus: Bool) -> ())?
