//
//  PDFMapViewController.swift
//  Guide
//
//  Created by Michael Vilabrera on 11/11/22.
//

import UIKit
import PDFKit

class PDFMapViewController: UIViewController {
    
    lazy var pdfView: PDFView = {
        let pV = PDFView()
        pV.translatesAutoresizingMaskIntoConstraints = false
        return pV
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()

        pdfView.delegate = self
        
        if let path = Bundle.main.path(forResource: "Subway Map", ofType: "pdf") {
            if #available(iOS 16.0, *) {
                if let pdfDocument = PDFDocument(url: URL(filePath: path)) {
                    pdfView.displayMode = .singlePage
                    pdfView.autoScales = true
                    pdfView.displayDirection = .vertical
                    pdfView.document = pdfDocument
                }
            } else {
                // iOS 16.0 minimum supported version
            }
        }
        
    }
    
    private func setup() {
        view.addSubview(pdfView)
        
        pdfView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        pdfView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        pdfView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        pdfView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

extension PDFMapViewController: PDFViewDelegate {
    
}
