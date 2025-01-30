//
//  LeadingAlignedFlowLayout.swift
//  MovieBox
//
//  Created by marty.academy on 1/30/25.
//

import UIKit

class LeadingAlignedFlowLayout: UICollectionViewFlowLayout {
    /**
    This function makes **x origin same** for items in same-vertical-direction-column
    The function has precondition that the collection has ** horiziontal scroll flow and 2 item size fit in one column **
     */
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else { return nil}
        
        for (index, layoutAttribute) in attributes.enumerated() {
            
            if index % 2 != 0 {continue}
            if index + 1 == attributes.count { return attributes }
            
            let widthOnCurrentAttribute = layoutAttribute.frame.width
            let widthOnNextAttribute = attributes[index + 1].frame.width
            
            let leadingPoint = widthOnCurrentAttribute > widthOnNextAttribute ? layoutAttribute.frame.origin.x : attributes[index + 1].frame.origin.x
            
            if widthOnCurrentAttribute > widthOnNextAttribute {
                attributes[index + 1].frame.origin.x = leadingPoint
            } else {
                layoutAttribute.frame.origin.x = leadingPoint
            }
        }
        return attributes
    }
}
