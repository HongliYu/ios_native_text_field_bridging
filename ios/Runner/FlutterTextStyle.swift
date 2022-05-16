//
//  FlutterTextStyle.swift
//  Runner
//
//  Created by hongli_justetf on 12.05.22.
//

import Foundation

class FlutterTextStyle {
    let fontFamily: String
    let color: Int
    let fontSize: CGFloat

    init(params: NSDictionary) {
        fontFamily = params["fontFamily"] as? String ?? ""
        color = params["color"] as? Int ?? 0
        fontSize = params["fontSize"] as? CGFloat ?? 0
    }
}
