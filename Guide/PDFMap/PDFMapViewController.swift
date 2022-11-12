//
//  PDFMapViewController.swift
//  Guide
//
//  Created by Michael Vilabrera on 11/11/22.
//

import UIKit
//import WebKit
import PDFKit

class PDFMapViewController: UIViewController {
    
//    lazy var scrollView: UIScrollView = {
//        let sV = UIScrollView()
//        sV.translatesAutoresizingMaskIntoConstraints = false
//        return sV
//    }()
    
    lazy var pdfView: PDFView = {
        let pV = PDFView()
        pV.translatesAutoresizingMaskIntoConstraints = false
        return pV
    }()
    
//    lazy var pdfDocument: PDFDocument = {
//        let pD = PDFDocument()
//        return pD
//    }()
    
//    lazy var webView: UIWebView = {
//        let wV = UIWebView()
//        wV.translatesAutoresizingMaskIntoConstraints = false
//        return wV
//    }()

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
                // Fallback on earlier versions
            }
        }
        
    }
    
    private func setup() {
//        view.addSubview(scrollView)
        view.addSubview(pdfView)
        
        pdfView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        pdfView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        pdfView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        pdfView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

//extension PDFMapViewController: UIScrollViewDelegate {
//
//}

extension PDFMapViewController: PDFViewDelegate {
    
}
