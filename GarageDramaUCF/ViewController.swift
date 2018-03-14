//
//  ViewController.swift
//  GarageDramaUCF
//
//  Created by Tuan Pham on 2/20/18.
//  Copyright © 2018 Tuan Pham. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
	@IBOutlet weak var buildingPicker: UIPickerView!
	@IBOutlet weak var sortPicker: UIPickerView!
	@IBOutlet weak var availabilityInput: UITextField!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		buildingPicker.delegate = self
		buildingPicker.dataSource = self
		sortPicker.delegate = self
		sortPicker.dataSource = self
		NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	// handle picker view
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		if pickerView == buildingPicker {
			return buildings.count
		} else {
			return garageSort.count
		}
	}
	
	// picker for buildings and garages
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		if pickerView == buildingPicker {
			return buildings[row]
		} else {
			return garageSort[row]
		}
	}
	
	var selectedBuilding = ""
	var selectedSort = ""
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		if pickerView == buildingPicker {
			selectedBuilding = buildings[row]
		} else {
			selectedSort = garageSort[row]
		}
	}
	
	
	// Handle keyboard resolved
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		availabilityInput.resignFirstResponder()
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
	
	// Initialize garages and buildings
	let buildings = ["John C. Hitt Library (LIB)", "Partnership II"]
	let garageALat = 28.60006
	let garageALon = -81.2058
	let garageBLat = 28.59695
	let garageBLon = -81.20029
	let garageCLat = 28.60226
	let garageCLon = -81.19589
	let garageDLat = 28.60505
	let garageDLon = -81.1972
	let garageHLat = 28.60507
	let garageHLon = -81.20104
	let garageILat = 28.6011
	let garageILon = -81.2049
	let garageLibraLat =  28.59605
	let garageLibraLon = -81.19668
	
	// hard-code building coordinates
	let libLat = 28.60011692
	let libLon = -81.20169594
	
	let P2Lat = 28.58582
	let P2Lon = -81.19923
	
	let garageSort = ["Closest Distance", "Availability"]
	
	// Calculate the distance between the building and garage
	//	https://www.geodatasource.com/developers/swift
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
	
	@IBAction func didSubmit(_ sender: Any) {
		// Pull data from parking garage's API
		let url = URL(string: "https://ucf-parking-api.herokuapp.com/api/v1/garages/")
		let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
			if error != nil {
				print (error!)
			} else {
				if let urlContent = data {
					do {
						let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options:[JSONSerialization.ReadingOptions.mutableContainers]) as AnyObject
						if self.selectedBuilding == "John C. Hitt Library (LIB)" {
							let garageList = (jsonResult as! NSArray) as Array
							let sortGarageList = garageList.sorted(by: {($0["percentage"] as! Int) < ($1["percentage"] as! Int)})
							let garages = [
								"A": self.distance(lat1: self.libLat, lon1: self.libLon, lat2: self.garageALat, lon2: self.garageALon, unit: "M"),
								"B": self.distance(lat1: self.libLat, lon1: self.libLon, lat2: self.garageBLat, lon2: self.garageBLon, unit: "M"),
								"C": self.distance(lat1: self.libLat, lon1: self.libLon, lat2: self.garageCLat, lon2: self.garageCLon, unit: "M"),
								"D": self.distance(lat1: self.libLat, lon1: self.libLon, lat2: self.garageDLat, lon2: self.garageDLon, unit: "M"),
								"H": self.distance(lat1: self.libLat, lon1: self.libLon, lat2: self.garageHLat, lon2: self.garageHLon, unit: "M"),
								"I": self.distance(lat1: self.libLat, lon1: self.libLon, lat2: self.garageILat, lon2: self.garageILon, unit: "M"),
								"Libra": self.distance(lat1: self.libLat, lon1: self.libLon, lat2: self.garageLibraLat, lon2: self.garageLibraLon, unit: "M")
							]
							let ascGaragesDist = garages.sorted(by: { $0.value < $1.value })
							//						let desiredAvailability = Int(self.availabilityInput.text!)
							if (self.selectedSort == "Closest Distance") {
								let distAlert = UIAlertController(title: "Garage \(ascGaragesDist[0].key)", message:"Found it", preferredStyle: .alert)
								distAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
								self.present(distAlert, animated: true)
							} else {
								let name = sortGarageList[0]["name"] as! String
								let percentage = 100 - (sortGarageList[0]["percentage"] as! Int)
								let availableGarageAlert = UIAlertController(
									title:"Garage \(name) with \(percentage)% available spots",
									message:"Found it",
									preferredStyle: .alert
								)
								availableGarageAlert.addAction(UIAlertAction(title: "Cancle", style: .cancel, handler: nil))
								self.present(availableGarageAlert, animated: true)
							}
						} else {
							let garageList = (jsonResult as! NSArray) as Array
							let sortGarageList = garageList.sorted(by: {($0["percentage"] as! Int) < ($1["percentage"] as! Int)})
							let garages = [
								"A": self.distance(lat1: self.P2Lat, lon1: self.P2Lon, lat2: self.garageALat, lon2: self.garageALon, unit: "M"),
								"B": self.distance(lat1: self.P2Lat, lon1: self.P2Lon, lat2: self.garageBLat, lon2: self.garageBLon, unit: "M"),
								"C": self.distance(lat1: self.P2Lat, lon1: self.P2Lon, lat2: self.garageCLat, lon2: self.garageCLon, unit: "M"),
								"D": self.distance(lat1: self.P2Lat, lon1: self.P2Lon, lat2: self.garageDLat, lon2: self.garageDLon, unit: "M"),
								"H": self.distance(lat1: self.P2Lat, lon1: self.P2Lon, lat2: self.garageHLat, lon2: self.garageHLon, unit: "M"),
								"I": self.distance(lat1: self.P2Lat, lon1: self.P2Lon, lat2: self.garageILat, lon2: self.garageILon, unit: "M"),
								"Libra": self.distance(lat1: self.P2Lat, lon1: self.P2Lon, lat2: self.garageLibraLat, lon2: self.garageLibraLon, unit: "M")
							]
							let ascGaragesDist = garages.sorted(by: { $0.value < $1.value })
							//						let desiredAvailability = Int(self.availabilityInput.text!)
							if (self.selectedSort == "Closest Distance") {
								let distAlert = UIAlertController(title: "Garage \(ascGaragesDist[0].key)", message:"Found it", preferredStyle: .alert)
								distAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
								self.present(distAlert, animated: true)
							} else {
								let name = sortGarageList[0]["name"] as! String
								let percentage = 100 - (sortGarageList[0]["percentage"] as! Int)
								let availableGarageAlert = UIAlertController(
									title:"Garage \(name) with \(percentage)% available spots",
									message:"Found it",
									preferredStyle: .alert
								)
								availableGarageAlert.addAction(UIAlertAction(title: "Cancle", style: .cancel, handler: nil))
								self.present(availableGarageAlert, animated: true)
							}
						}
					} catch {
						print("JSON failed")
					}
				}
			}
		}
		task.resume()
	}
}

