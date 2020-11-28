//
//  vcLoRaModulationConfig.swift
//  Meshtastic
//
//  Created by Thomas Huttinger on 24.11.20.
//

import UIKit

class vcLoRaModulationConfig: UIViewController
{

    @IBOutlet var pvBandwidth: UIPickerView!
    @IBOutlet var pvSpreadingFactor: UIPickerView!
    @IBOutlet var pvCodingRate: UIPickerView!
    @IBOutlet var lblDatarate: UILabel!
    
    @IBAction func btnCancel_TouchUp(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func btnSave_TouchUp(_ sender: Any)
    {
        self.CellData.bandWidth = bandWidthData.selectedBandwidth
        self.CellData.spreadingFactor = spreadingFactorData.selectedSpreadingFactor
        self.CellData.codingRate = codingRateData.selectedCodingRate
    }
    
    
    public struct cellData
    {
        var bandWidth = ""
        var spreadingFactor = ""
        var codingRate = ""
    }
    
    public var CellData = cellData(bandWidth:"",spreadingFactor:"",codingRate:"")

    let bandWidthData = BandwidthData()
    let spreadingFactorData = SpreadingFactorData()
    let codingRateData = CodingRateData()
    let dataRateCalculator = DataRateCalculator()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.pvBandwidth.delegate = self.bandWidthData
        self.pvBandwidth.dataSource = self.bandWidthData

        self.pvSpreadingFactor.delegate = self.spreadingFactorData
        self.pvSpreadingFactor.dataSource = self.spreadingFactorData

        self.pvCodingRate.delegate = self.codingRateData
        self.pvCodingRate.dataSource = self.codingRateData
        
        let indexBandwidth = bandWidthData.bandwidthData.firstIndex(where: {$0.contains(CellData.bandWidth)})
        self.pvBandwidth.selectRow(indexBandwidth ?? 0, inComponent: 0, animated: true)
        self.bandWidthData.selectedBandwidth = self.CellData.bandWidth

        let indexSpreadingFactor = spreadingFactorData.spreadingFactorData.firstIndex(where: {$0.contains(CellData.spreadingFactor)})
        self.pvSpreadingFactor.selectRow(indexSpreadingFactor ?? 0, inComponent: 0, animated: true)
        self.spreadingFactorData.selectedSpreadingFactor = self.CellData.spreadingFactor

        let indexCodingRate = codingRateData.codingRateData.firstIndex(where: {$0.contains(CellData.codingRate)})
        self.pvCodingRate.selectRow(indexCodingRate ?? 0, inComponent: 0, animated: true)
        self.codingRateData.selectedCodingRate = self.CellData.codingRate
        
        dataRateCalculator.bandwidth = bandWidthData.bandwidthData[indexBandwidth!]
        dataRateCalculator.spreadingFactor = self.CellData.spreadingFactor
        dataRateCalculator.codingRate = self.CellData.codingRate
        dataRateCalculator.labelOutput = self.lblDatarate
        
        dataRateCalculator.calculate()
        
        self.bandWidthData.dataRateCalculator = self.dataRateCalculator
        self.spreadingFactorData.dataRateCalculator = self.dataRateCalculator
        self.codingRateData.dataRateCalculator = self.dataRateCalculator

        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


class BandwidthData : NSObject, UIPickerViewDataSource, UIPickerViewDelegate
{
    let bandwidthData = ["7.8", "10.4", "15.6", "20.8", "31.25", "41.7", "62.5", "125", "250", "500"]
    var selectedBandwidth: String = ""
    var dataRateCalculator = DataRateCalculator()

    func numberOfComponents(in pvBandwidth: UIPickerView) -> Int
    {
        return 1
    }

    func pickerView(_ pvBandwidth: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return bandwidthData.count
    }

    
    func pickerView(_ pvBandwidth: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return bandwidthData[row]
    }
    
    
    func pickerView (_ pvBandwidth: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        let value = bandwidthData[row]
        let indexBeforeDot = value.firstIndex(of: ".")

        // we only need the whole number part of the selected value
        if (indexBeforeDot != nil)
        {
            selectedBandwidth = String(value[..<indexBeforeDot!])
        }
        else
        {
            selectedBandwidth = value
        }
     
        dataRateCalculator.bandwidth = value
        dataRateCalculator.calculate()
    }
}


class SpreadingFactorData : NSObject, UIPickerViewDataSource, UIPickerViewDelegate
{
    let spreadingFactorData = ["7", "8", "9", "10", "11", "12"]
    var selectedSpreadingFactor: String = ""
    var dataRateCalculator = DataRateCalculator()

    func numberOfComponents(in pvSpreadingFactor: UIPickerView) -> Int
    {
        return 1
    }

    func pickerView(_ pvSpreadingFactor: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return spreadingFactorData.count
    }

    func pickerView(_ pvSpreadingFactor: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return spreadingFactorData[row]
    }

    func pickerView (_ pvSpreadingFactor: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        selectedSpreadingFactor = spreadingFactorData[row]
        
        dataRateCalculator.spreadingFactor = spreadingFactorData[row]
        dataRateCalculator.calculate()
    }
}


class CodingRateData : NSObject, UIPickerViewDataSource, UIPickerViewDelegate
{
    let codingRateData = ["4:5", "4:6", "4:7", "4:8"]
    var selectedCodingRate: String = ""
    var dataRateCalculator = DataRateCalculator()

    func numberOfComponents(in pvCodingRate: UIPickerView) -> Int
    {
        return 1
    }

    func pickerView(_ pvCodingRate: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return codingRateData.count
    }

    func pickerView(_ pvCodingRate: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return codingRateData[row]
    }

    func pickerView (_ pvSpreadingFactor: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        let value = codingRateData[row]
        
        // we only need the last character of the selected value
        selectedCodingRate = String(value.last!)
        
        dataRateCalculator.codingRate = selectedCodingRate
        dataRateCalculator.calculate()
    }
}


class DataRateCalculator
{
    public var bandwidth: String!
    public var spreadingFactor: String!
    public var codingRate: String!
    public var labelOutput: UILabel!
    
    func calculate ()
    {
        let bw = Double(bandwidth) ?? 0.0
        let sf = Double(spreadingFactor) ?? 0
        let cr = Double(codingRate) ?? 0

        let dr = sf * ( (4 / (4 + (cr - 4))) / (pow(2, sf) / bw) )
        let drRounded = Double(round(1000 * dr) / 1000)
        
        labelOutput.text = String(drRounded)
    }
    
    
    
    
    
    
    
    
}
