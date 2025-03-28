//
//  View + Helper.swift
//  MovieBox
//
//  Created by marty.academy on 1/26/25.
//

import UIKit

func getBrownBoldBorder<T:UIView>(view: T) -> Void {
    view.layer.borderColor = AppColor.tintBrown.inUIColorFormat.cgColor
    view.layer.borderWidth = AppLineDesign.selected.rawValue
}
