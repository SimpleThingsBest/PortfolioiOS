//
//  FoodPoisoningController.swift
//  Portfolio
//
//  Created by 안정은 on 03/12/2018.
//  Copyright © 2018 portfolio. All rights reserved.
//

import UIKit
import CoreData
class CityDongVO{
    var cityCode : Int32?
    var cityName : String?
    var dongCode : Int32?
    var dongName : String?
}

class FoodPoisoningController: UIViewController {
    var componentCode : String?
    lazy var context : NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }()
    
    //전체 데이터를 가져오는 메소드 -- 매개변수에 따라서 생성되는 배열을 다르게 하기
    func fetch(componentCode:String?) -> [CityDongVO]{
        //리스트 생성
        var cityList = [CityDongVO]()
        
        //요청 객체 생성
        let fetchRequestCity:NSFetchRequest<CityListMO> = CityListMO.fetchRequest()
        let fetchRequestDong:NSFetchRequest<DongListMO> = DongListMO.fetchRequest()
        //2개 이상의 데이터를 가져올 때는 정렬 조건을 추가
        let cityCodeDesc = NSSortDescriptor(key: "cityCode", ascending: false)
        let dongCodeDesc = NSSortDescriptor(key: "dongCode", ascending: false)
        fetchRequestCity.sortDescriptors = [cityCodeDesc]
        fetchRequestDong.sortDescriptors = [dongCodeDesc]
        do{
            //데이터 가져오기
            let resultSetCity = try self.context.fetch(fetchRequestCity)
            let resultSetDong = try self.context.fetch(fetchRequestDong)
            //데이터 순회
            for record in resultSetCity{
                //데이터를 피커에서 배열로 사용하기 위해서 배열에 저장
                //1개의 데이터를 저장할 객체 생성
                let data = CityDongVO()
                data.cityCode = record.cityCode
                data.cityName = record.cityName
                //목록에 저장
                cityList.append(data)
            }
            for record in resultSetDong{
                //데이터를 피커에서 배열로 사용하기 위해서 배열에 저장
                //1개의 데이터를 저장할 객체 생성
                let data = CityDongVO()
                data.cityCode = record.cityList?.cityCode
                data.dongCode = record.dongCode
                data.dongName = record.dongName
                //목록에 저장
                cityList.append(data)
            }
        }catch let e as NSError{
            print("\(e.localizedDescription)")
        }
        return cityList
    }
    
    @IBOutlet weak var cityPickerView: UIPickerView!
    @IBOutlet weak var riskLbl: UILabel!
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var cityDetailLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //cityPickerView.dataSource = self
        cityPickerView.delegate = self
        cityPickerView.dataSource = self

        
        //cityPickerView.isHidden = true
        
    }

    // MARK: - PickerView
}
extension FoodPoisoningController : UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 3
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if component == 1 {
            componentCode = "city"
            var cityList = fetch(componentCode: componentCode)
            return cityList.count
        }else if component == 2 {
            componentCode = "dong"
            var dingList = fetch(componentCode: componentCode)
            return dingList.count
        }else{
            componentCode = "risk"
            var riskList = fetch(componentCode: componentCode)
            return riskList.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        componentCode = "city"
        var cityList = fetch(componentCode: componentCode)
        return citysList[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
}
