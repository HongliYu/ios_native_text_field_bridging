//
//  NativeViewFactory.swift
//  Runner
//
//  Created by hongli_justetf on 06.05.22.
//

import Foundation
import Flutter
import UIKit

class NativeSearchBarTextFieldFactory: NSObject, FlutterPlatformViewFactory {
    
    public func create(withFrame frame: CGRect,
                       viewIdentifier viewId: Int64,
                       arguments args: Any?) -> FlutterPlatformView {
        return NativeSearchBarTextField(frame, viewId: viewId, args: args)
    }
    
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
    
}

public class NativeSearchBarTextField: NSObject, FlutterPlatformView {
    
    let frame: CGRect
    let viewId: Int64
    let textField: UITextField
    var placeholderColors: UIColor?
    var unfocusedWidth: Double?
    var focusedWidth: Double?
    let args: Any?
    
    init(_ frame: CGRect, viewId: Int64, args: Any?) {
        self.frame = frame
        self.viewId = viewId
        self.args = args
        self.textField = UITextField()
    }
    
    public func view() -> UIView {
        let view : UIView = UIView(frame: self.frame)
        // Parse Layer
        if let params = args as? NSDictionary,
           let left = params["left"] as? Double,
           let top = params["top"] as? Double,
           let unfocusedWidth = params["unfocusedWidth"] as? Double,
           let focusedWidth = params["focusedWidth"] as? Double,
           let height = params["height"] as? Double,
           let backgroundColor = params["backgroundColor"] as? Int,
           let placeholder = params["placeholder"] as? String,
           let placeholderColor = params["placeholderColor"] as? Int,
           let textStyleParams = params["textStyle"] as? NSDictionary {
            textField.frame = CGRect(x: left, y: top,
                                     width: unfocusedWidth,
                                     height: height)
            placeholderColors = UIColor(hex: placeholderColor)
            self.unfocusedWidth = unfocusedWidth
            self.focusedWidth = focusedWidth
            textField.attributedPlaceholder =
            NSAttributedString(string: placeholder,
                               attributes: [NSAttributedString.Key.foregroundColor: placeholderColors ?? UIColor.clear])
            view.backgroundColor = UIColor(hex: backgroundColor)
            let flutterTextStyle = FlutterTextStyle(params: textStyleParams)
            textField.textColor = UIColor(hex: flutterTextStyle.color)
            textField.font = UIFont(name: flutterTextStyle.fontFamily, size: flutterTextStyle.fontSize)
        }
        textField.delegate = self
        if textField.allTargets.isEmpty {
            textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
            textField.addTarget(self, action: #selector(textFieldEditingDidEnd), for: .editingDidEnd)
        }
        view.addSubview(textField)
        
        // Bind Actions
        globalSetSearchBarTextFieldPlaceHolder = { [weak self] (placeholder: String) -> () in
            DispatchQueue.main.async {
                guard let strongSelf = self else { return }
                strongSelf.textField.attributedPlaceholder =
                NSAttributedString(string: placeholder,
                                   attributes:
                                    [NSAttributedString.Key.foregroundColor:
                                        strongSelf.placeholderColors ?? UIColor.clear])
            }
        }
        globalSetSearchBarText = { [weak self] (text: String) -> () in
            DispatchQueue.main.async {
                guard let strongSelf = self else { return }
                strongSelf.textField.text = text
            }
        }
        globalSetFocusSearchBar = { [weak self] (isFocus: Bool) -> () in
            DispatchQueue.main.async {
                guard let strongSelf = self else { return }
                if isFocus {
                    strongSelf.textField.becomeFirstResponder()
                } else {
                    strongSelf.textField.resignFirstResponder()
                }
            }
        }
        return view
    }
    
    // Target actions
    @objc func textFieldDidChange() {
        globalSearchBarChannel?.invokeMethod("ios_native_textFieldDidChange", arguments: textField.text);
    }
    
    @objc func textFieldEditingDidEnd() {
        globalSearchBarChannel?.invokeMethod("ios_native_textFieldEditingDidEnd", arguments: textField.text);
    }
    
}

extension NativeSearchBarTextField: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.textField {
            textField.resignFirstResponder()
            globalSearchBarChannel?.invokeMethod("ios_native_textFieldShouldReturn", arguments: textField.text);
            return false
        }
        return true
    }
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        guard let focusedWidth = self.focusedWidth else { return false }
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            let frame  = strongSelf.textField.frame
            let newFrame = CGRect(x: frame.origin.x, y: frame.origin.y,
                                  width: focusedWidth, height: frame.size.height)
            strongSelf.textField.frame = newFrame
        }
        globalSearchBarChannel?.invokeMethod("ios_native_textFieldShouldBeginEditing", arguments: textField.text);
        return true
    }
    
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        guard let unfocusedWidth = self.unfocusedWidth else { return false }
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            let frame  = strongSelf.textField.frame
            let newFrame = CGRect(x: frame.origin.x, y: frame.origin.y,
                                  width: unfocusedWidth, height: frame.size.height)
            strongSelf.textField.frame = newFrame
        }
        globalSearchBarChannel?.invokeMethod("ios_native_textFieldShouldEndEditing", arguments: textField.text);
        return true
    }
}

