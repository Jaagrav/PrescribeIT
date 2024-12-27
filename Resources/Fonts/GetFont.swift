//
//  GetFont.swift
//  PrescribeIT
//
//  Created by Jaagrav Seal on 22/12/24.
//

import Foundation
import CoreText
import UIKit
import SwiftUICore

func getFont(fontName: String) -> Font {
    let cfURL = Bundle.main.url(forResource: fontName, withExtension: "ttf")! as CFURL

    CTFontManagerRegisterFontsForURL(cfURL, CTFontManagerScope.process, nil)

    let uiFont = UIFont(name: fontName, size:  30.0)

    return Font(uiFont ?? UIFont())
}
