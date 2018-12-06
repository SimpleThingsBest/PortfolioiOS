//
//  ViewController.swift
//  Portfolio
//
//  Created by 안정은 on 30/11/2018.
//  Copyright © 2018 portfolio. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

class ViewController: UIViewController {
    
    //로그인 정보를 저장 할 저장소 - viewDidLoad에서 생성
    var userDefaults : UserDefaults? = UserDefaults.standard
    //공유변수 사용을 위한 AppDelegate 객체 생성
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    //로그인 결과 저장 할 변수
    var pid : String!
    var pnick : String!
    var pimage : String!
    //로그인 상태에 따라서 텍스트를 변경하기 위한 변수
    @IBOutlet weak var loginOrLogout: UIButton!
    //버튼을 눌렀을 때 정보를 받거나 로그아웃처리를 함.
    
    var totalCount : Int?
    /*
    func foodPoisoningDownload(){
        //api 다운로드
        //URL을 생성해서 다운로드 받기
        //다운로드 받을 URL 만들기
        let cnt = "http://apis.data.go.kr/B550928/dissForecastInfoSvc/getDissForecastInfo?serviceKey=m%2BAB97QjVAk8g8IGN9PTm5H%2BdfLsRRkZVWVXfhPqgvcko5uRCLo7ai4ak%2FS57jyNOqKLxq7xiDzPRyUqDrQbZw%3D%3D&numOfRows=1&pageNo=1&type=json&dissCd=3"
        
        let url = "http://apis.data.go.kr/B550928/dissForecastInfoSvc/getDissForecastInfo?serviceKey=m%2BAB97QjVAk8g8IGN9PTm5H%2BdfLsRRkZVWVXfhPqgvcko5uRCLo7ai4ak%2FS57jyNOqKLxq7xiDzPRyUqDrQbZw%3D%3D&numOfRows=\(totalCount)&pageNo=1&type=json&dissCd=3"
        
        let cntURI : URL! = URL(string: cnt)
        let apiURi : URL! = URL(string: url)
        
        //REST API를 호출
        let cntdata = try! Data(contentsOf: cntURI)
        let apidata = try! Data(contentsOf: apiURi)
        //예외처리
        do{
            //전체 데이터를 디셔너리로 만들기
            let cntDict =
                try JSONSerialization.jsonObject(with: cntdata, options: []) as! NSDictionary
            //response 키의 값을 디셔너리로 가져오기
            let cntResponse = cntDict["response"] as! NSDictionary
            let cntBody = cntResponse["body"] as! NSDictionary
            
            self.totalCount = cntBody["totalCount"] as! NSInteger
            
            //let apiDict = try
            
        }catch{
             print("파싱 예외 발생")
        }
    }
 */
    
    
    
    @IBAction func loginBtn(_ sender: Any) {
        if loginOrLogout.title(for: .normal) == "로그인"{
        //대화상자 생성
        let loginAlert = UIAlertController.init(title: "로그인", message: nil, preferredStyle: .alert)
        //텍스트 필드
        loginAlert.addTextField(){(tf) in tf.placeholder = "아이디를 입력하세요"}
        loginAlert.addTextField(){(tf) in tf.placeholder = "비밀번호 입력하세요"
            //****
            tf.isSecureTextEntry = true
        }
        //버튼
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let ok = UIAlertAction(title: "로그인", style: .default){(_) in
            //입력내용 가져오기
            let inputid = loginAlert.textFields![0].text
            let inputpw = loginAlert.textFields![1].text
            //서버에 로그인정보 요청
            let request = Alamofire.request("http://192.168.0.5:8080/aisdugo/mobile/login?pid=\(inputid!)&ppw=\(inputpw!)", method: .get, parameters: nil)
            //결과 사용
            request.responseJSON(){
              response in
                //결과를 확인
                print(response.result.value!)
                if let jsonObject = response.result.value as? [String:Any]{
                    print(jsonObject)
                    let result = jsonObject["result"] as! NSDictionary
                    print(result)
                    let id = result["pid"] as! NSString
                    print(id)
                    if id == "NULL"{
                        //로그인 실패
                        self.title = "아이디나 비밀번호가 틀렸습니다."
                    }else{
                        //로그인 성공 - 데이터를 userDefaults에 저장하고 자동로그인되도록 하기
                        print(id)
                        self.pid = id as String
                        self.userDefaults?.set(id as String, forKey: "pid")
                        print(self.userDefaults!.string(forKey: "pid")!)
                        self.userDefaults?.set(result["pnick"] as! NSString, forKey: "pnick")
                        self.pnick = self.userDefaults?.object(forKey: "nickname") as? String
                        self.userDefaults?.set((result["pimage"])! as! NSString, forKey: "pimage")
                        self.pimage = self.userDefaults?.object(forKey: "image") as? String
                        self.title = "\(self.userDefaults!.object(forKey: "nickname")!)님 환영합니다."
                        self.loginOrLogout.setTitle("로그아웃", for: .normal)
                    }
                }
            }
        }
            //버튼을 대화상자에 부착
            loginAlert.addAction(cancel)
            loginAlert.addAction(ok)
            //화면에 출력
            self.present(loginAlert, animated: true)
        }else{
            //로그인 정보를 삭제
            self.pid = nil
            userDefaults?.set(self.pid, forKey: "pid")
            self.pnick = nil
            self.pimage = nil
            self.title = ""
            self.loginOrLogout.setTitle("로그인", for: .normal)
        }
    }
    
    
    
    
    
    //식중독 버튼 클릭
    @IBAction func foodPoisoning(_ sender: Any) {
        let foodPoisoning = self.storyboard?.instantiateViewController(withIdentifier: "FoodPoisoningController") as! FoodPoisoningController
        foodPoisoning.title = "식중독예측정보"
        
        self.navigationController?.pushViewController(foodPoisoning, animated: true)
    }
    
    
    //AppDelegate에 있는 CoreData 사용을 위한 변수에 접근하는 변수 생성
    lazy var context : NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }()
    
    //처음 화면이 실행될 때 로그인 체크
    override func viewDidLoad() {
        super.viewDidLoad()
        if userDefaults?.string(forKey: "pid") == nil{
            //로그인 안 되어 있을 때
            self.loginOrLogout.setTitle("로그인", for: .normal)
        }else{
            //로그인 되어 있을 때
            self.loginOrLogout.setTitle("로그아웃", for: .normal)
            //FoodPoisoningCell
        }
        
        //앱이 설치되었을 때 1번만 실행---------------------------------------------------
        if self.appDelegate.counti == 0 {
            
            //비동기적으로 내장 된 csv 데이터 다운 받기
            DispatchQueue.main.async(execute: {
                let citylistPath = Bundle.main.path(forResource: "citylist", ofType: "csv")
                let donglistPath = Bundle.main.path(forResource: "donglist", ofType: "csv")
                if citylistPath == nil {
                    print("citylist 경로 없음")
                    return
                }else if donglistPath == nil{
                    print("donglist 경로 없음")
                    return
                }
                
                var citylistData: String? = nil
                var donglistData: String? = nil
                
                do {
                    citylistData = try String(contentsOfFile: citylistPath!, encoding: String.Encoding.utf8)
                    donglistData = try String(contentsOfFile: donglistPath!, encoding: String.Encoding.utf8)
                    let citysData = citylistData?.csvRows()
                    let dongsData = donglistData?.csvRows()
                    var count = 0
                    for row in citysData!{
                        if count == 0{
                            count = count + 1
                        }else{
                        //print(row)
                        //새로 저장할 객체를 생성
                        let cityObject = NSEntityDescription.insertNewObject(forEntityName: "CityList", into: self.context) as! CityListMO
                            //print("city리스트: \(object)")
                        let myInteger = row[0] as NSString
                        let mmyInteger = myInteger as String
                        let mmmyInteger = Int32(mmyInteger)
                        //print(mmmyInteger!)
                        cityObject.cityCode = mmmyInteger!
                        cityObject.cityName = row[1]
                        //coreData에 저장
                        
                        do{
                            try self.context.save()
                            //print(cityObject.cityCode)
                        }catch let e as NSError{
                            print("\(e.localizedDescription)")
                        }
 
                    }
                    }
                    
                        count = 0
                    for row in dongsData!{
                        if count == 0 {
                            count = count + 1
                        }else{
                            //print(row)
                            //새로 저장할 객체를 생성
                            
                            let dongObject = NSEntityDescription.insertNewObject(forEntityName: "DongList", into: self.context) as! DongListMO
                            //print("dong리스트 : \(object)")
                            let dongParseNSString = row[1] as NSString
                            let dongParseString = dongParseNSString as String
                            let dongParseInt = Int32(dongParseString)
                            //print(dongParseInt)
                            dongObject.dongCode = dongParseInt!
                            dongObject.dongName = row[2]
                            do{
                                try self.context.save()
                                //print(dongObject.dongCode)
                            }catch let e as NSError{
                                print("\(e.localizedDescription)")
                            }
                        }
                    }
                    
 
                } catch{
                    print(error)
                }
            })
            self.appDelegate.counti = 1
        }
        //---------------------------------------------------------------
    }
    
    
    
    
    //화면이 시작될 때마다 로그인 여부 체크
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //userDefaults?.set(pid, forKey: "pid")
        if userDefaults?.string(forKey: "pid") == nil{
            //로그인 안 되어 있을 때
            self.loginOrLogout.setTitle("로그인", for: .normal)
        }else{
            //로그인 되어 있을 때
            self.title = "\((self.userDefaults?.object(forKey: "pnick") as! String))님 환영합니다."
            self.loginOrLogout.setTitle("로그아웃", for: .normal)
        }
    }


}

