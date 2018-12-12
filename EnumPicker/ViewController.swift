//
//  ViewController.swift
//  EnumPicker
//
//  Created by Mark Wright on 12/12/18.
//  Copyright © 2018 Raised Square, LLC. All rights reserved.
//

import UIKit

enum Drink: String, CaseIterable {
    case coffee = "Coffee"
    case tea = "Tea"
    case cola = "Cola"
    case water = "Water"
}

class ViewController: UIViewController {
    @IBOutlet weak var drinkTextField: UITextField!
    
    private var pickerView: UIPickerView = {
        var picker = UIPickerView()
        return picker
    }()

    private var toolBar: UIToolbar = {
        var toolbar = UIToolbar()
        let cancelBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain,
                                                  target: self, action: #selector(cancel(_:)))
        let doneBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                target: self, action: #selector(done(_:)))

        toolbar.items = [cancelBarButtonItem, doneBarButtonItem]
        toolbar.barStyle = .default
        toolbar.sizeToFit()
        
        return toolbar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Enum Powered Picker"
        
        setUpPickerView()
        setUpTextField()
    }

    private func setUpPickerView() {
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    private func setUpTextField() {
        drinkTextField.delegate = self
        drinkTextField.inputView = pickerView
        drinkTextField.inputAccessoryView = toolBar
    }
    
    @objc private func done(_ sender: UIBarButtonItem) {
        let row = pickerView.selectedRow(inComponent: 0)
        drinkTextField.text = Drink.allCases[row].rawValue
        view.endEditing(true)
    }
    
    @objc private func cancel(_ sender: UIBarButtonItem) {
        view.endEditing(true)
    }
}

extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Drink.allCases[row].rawValue
    }
}

extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Drink.allCases.count
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.drinkTextField {
            // Select the value in the picker from the text in the textField
            let row = Drink.allCases.firstIndex(where: { (drink) -> Bool in
                drink.rawValue == self.drinkTextField.text
            })
            
            if let row = row {
                pickerView.selectRow(row, inComponent: 0, animated: true)
            }
        }
    }
}
