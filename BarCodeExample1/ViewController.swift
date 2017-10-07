//
//  ViewController.swift
//  BarCodeExample1
//
//  Created by Carlos Rodolfo Santos on 07/10/2017.
//  Copyright © 2017 Carlos Rodolfo Santos. All rights reserved.
//
import UIKit



class ViewController: UIViewController, UINavigationControllerDelegate {

    
    let edit: UITextField = {
       let edit = UITextField()
        edit.translatesAutoresizingMaskIntoConstraints = false
        edit.borderStyle = UITextBorderStyle.line
        edit.text = "aqui"
        return edit
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.delegate = self
        self.navigationItem.title = "OI"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(goToCamera))
        
        view.addSubview(edit)
        edit.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        edit.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 5).isActive = true
        edit.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -5).isActive = true
        edit.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    @objc func goToCamera() {
        print("goToCamera")
        let barCodeScanner = BarcodeScanner()
        barCodeScanner.viewMain = self
        navigationController?.pushViewController(barCodeScanner, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

