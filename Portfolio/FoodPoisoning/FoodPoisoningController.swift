//
//  FoodPoisoningController.swift
//  Portfolio
//
//  Created by 안정은 on 03/12/2018.
//  Copyright © 2018 portfolio. All rights reserved.
//
import Foundation
import UIKit
import CoreData



class FoodPoisoningController: UIViewController {
    var savedata : Int32?
    let riskList = ["관심", "주의", "경고", "위험"]
    var cityI : [Int:String]!
    var dongI : [DongListMO]!
    
    lazy var context : NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }()
 
 

 
 
    @IBOutlet weak var cityPickerView: UIPickerView!
    @IBOutlet weak var riskLbl: UILabel!
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var cityDetailLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         print(self.cityI)
        print(self.dongI)
        
        //cityPickerView.dataSource = self
        
       // cityPickerView.delegate = self
        //cityPickerView.dataSource = self
        
        /*
        var cnt = 0
        for _ in fetch(){
        print(fetch()[cnt].CityCode!);
        print(fetch()[cnt].CityName!);
            cnt = cnt + 1
        }
        */
        
    }

    
}

/*
// MARK: - PickerView
extension FoodPoisoningController : UIPickerViewDelegate, UIPickerViewDataSource{
    
    //피커 개수 설정
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 3
    }
    
    //피커별로 출력될 데이터 개수
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        //var pickerResult : [ResultVO]? = nil
        if component == 0 {
            let result = fetch(type: "city", cityCode: nil, codeOrName: "code")
            return result.count
        }else if component == 1 {
            let result = fetch(type: "dong", cityCode: 99, codeOrName: "code")
            return result.count
        }else {
            return riskList.count
        }
        
    }
    

    //데이터 출력
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        
        
        //var savedata : Int32?
        //var ar : [Int]
        if component == 1 {
            //pickerView.reloadComponent(1)
            let result = fetch(type: "dong", cityCode: self.savedata, codeOrName: "name")
            
            return result[row].name
        }
        else if component == 0{
            //pickerView.reloadComponent(0)
            let result = fetch(type: "city", cityCode: nil, codeOrName: "name")
            savedata = result[row].code
            return result[row].name
        }
        else {
            
            return self.riskList[row]
        }
    }

}
*/
