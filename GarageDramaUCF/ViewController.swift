//
//  ViewController.swift
//  GarageDramaUCF
//
//  Created by Tuan Pham on 2/20/18.
//  Copyright © 2018 Tuan Pham. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return buildings.count
	}
	
	@IBOutlet weak var buildingPicker: UIPickerView!
	@IBOutlet weak var submitBuilding: UIButton!
	@IBOutlet weak var alarmInput: UITextField!
	@IBOutlet weak var saveAlarm: UIButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		buildingPicker.delegate = self
		buildingPicker.dataSource = self
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	// Initialize buildings
	let buildings = ["John C. Hitt Library (LIB)", "Partnership II (P2)"]
	// hard-code building coordinates
	let libLat = 28.60011692
	let liblon = -81.20169594
	// picker for buildings
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return buildings[row]
	}
}

