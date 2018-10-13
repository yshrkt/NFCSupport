//
//  ViewController.swift
//  NFCSample
//
//  Created by Yoshihiro Kato on 2017/08/11.
//  Copyright © 2017年 Yoshihiro Kato. All rights reserved.
//

import UIKit
import CoreNFC
import NFCSupport

class ViewController: UIViewController {
    
    var ndefReader: NFCNDEFReaderSession?
    
    let button: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Start", for: .normal)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(button)
        button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        button.widthAnchor.constraint(equalToConstant: 120).isActive = true
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ndefReader?.invalidate()
    }
    
    @objc func didTapButton(sender: UIButton) {
        startNDEFReader()
    }
    
    private func startNDEFReader() {
        ndefReader?.invalidate()
        ndefReader = NFCNDEFReaderSession(delegate: self,
                                          queue: nil,
                                          invalidateAfterFirstRead: false)
        ndefReader?.begin()
    }
}

extension ViewController: NFCNDEFReaderSessionDelegate {
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        print("reader did detect")
        
        guard let record = messages.first?.records.first else {
            print("record is not found")
            return
        }
        
        print("typeNameFormat: \(record.typeNameFormat.rawValue)")
        print("type: \(String(data: record.type, encoding: .utf8) ?? "(nil)")")
        print("identifier: \(String(data: record.identifier, encoding: .utf8) ?? "(nil)")")
        let payloadString: String = record.payload.reduce(""){ result, data in
            return result + String(format: "%02x", data)
        }
        print("payload: \(payloadString)")
        guard record.typeNameFormat == .nfcWellKnown else {
            print("record type is not NFCWellKnown")
            return
        }
        
        guard let result = try? NFCNDEFWellknown.parse(type: record.type, payload: record.payload) else {
            print("can not parse record data")
            return
        }
        
        switch result {
        case let .text(record):
            showAlert(title: "Text", message: record.text)
            session.invalidate()
        case let .uri(record):
            showAlert(title: "URI", message: record.uri?.absoluteString ?? "")
            session.invalidate()
        case let .smartPoster(record):
            let message = "title: \(record.titleRecords.first?.text ?? "")\nuri: \(record.uri?.absoluteString ?? "")"
            showAlert(title: "Smart Poster", message: message)
            session.invalidate()
        case let .unsupported(type):
            print("unsupported record type (\(type))")
            session.invalidate()
        }
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print("did invalidate with error: \(error.localizedDescription)\n")
    }
    
    private func showAlert(title: String, message: String, handler: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                handler?()
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
}
