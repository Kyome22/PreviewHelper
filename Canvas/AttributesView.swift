//
//  AttributesView.swift
//  Canvas
//
//  Created by Takuto Nakamura on 2020/10/27.
//

import Cocoa

class AttributesView: NSView {

    @IBOutlet weak var widthField: NSTextField!
    @IBOutlet weak var heightField: NSTextField!

    func getSize() -> NSSize {
        var w = widthField.integerValue
        var h = heightField.integerValue
        if w == 0 { w = 800 }
        if h == 0 { h = 450 }
        return NSSize(width: w, height: h)
    }
    
}
