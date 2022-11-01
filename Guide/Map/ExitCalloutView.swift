//
//  ExitCalloutView.swift
//  Guide
//
//  Created by Michael Vilabrera on 11/1/22.
//

import UIKit

class ExitCalloutView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        backgroundColor = .green
    }
}
