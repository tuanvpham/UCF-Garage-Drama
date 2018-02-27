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
		NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
	}
	
	// Handle keyboard overlap the input field
	@objc func keyboardWillShow(notification: NSNotification) {
		if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
			if self.view.frame.origin.y == 0{
				self.view.frame.origin.y -= keyboardSize.height
			}
		}
	}
	
	@objc func keyboardWillHide(notification: NSNotification) {
		if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
			if self.view.frame.origin.y != 0{
				self.view.frame.origin.y += keyboardSize.height
			}
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	// Handle keyboard resolved
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		alarmInput.resignFirstResponder()
	}
	
	// Initialize garages and buildings
	let buildings = ["John C. Hitt Library (LIB)", "Partnership II (P2)"]
	let garageALat = 28.60006
	let garageALong = -81.2058
	let garageBLat = 28.59695
	let garageBLon = -81.20029
	// hard-code building coordinates
	let libLat = 28.60011692
	let libLon = -81.20169594
	// picker for buildings
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return buildings[row]
	}
	
	// Calculate the distance between the building and garage
	// https://www.geodatasource.com/developers/swift
	func deg2rad(deg:Double) -> Double {
		return deg * Double.pi / 180
	}
	func rad2deg(rad:Double) -> Double {
		return rad * 180.0 / Double.pi
	}
	func distance(lat1:Double, lon1:Double, lat2:Double, lon2:Double, unit:String) -> Double {
		let theta = lon1 - lon2
		var dist = sin(deg2rad(deg: lat1)) * sin(deg2rad(deg: lat2)) + cos(deg2rad(deg: lat1)) * cos(deg2rad(deg: lat2)) * cos(deg2rad(deg: theta))
		dist = acos(dist)
		dist = rad2deg(rad: dist)
		dist = dist * 60 * 1.1515
		if (unit == "N") {
			dist = dist * 0.8684
		}
		return dist
	}
}

