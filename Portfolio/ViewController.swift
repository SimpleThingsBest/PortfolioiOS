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
    //news 버튼 클릭 이벤트
    @IBAction func newsBtn(_ sender: Any) {
        //news 뷰 객체 만들기
        let news = self.storyboard?.instantiateViewController(withIdentifier: "NewsController")
        //네비게이션 버튼 수정
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "메인화면", style: .done, target: nil, action: nil)
        //페이지 이동
        self.navigationController?.pushViewController(news!, animated: true)
        
    }
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
        
        let cfetchRequest:NSFetchRequest<CityListMO> = CityListMO.fetchRequest()
        let dfetchRequest:NSFetchRequest<DongListMO> = DongListMO.fetchRequest()
        let cityDesc = NSSortDescriptor(key: "cityCode", ascending: false)
        let dongDesc = NSSortDescriptor(key: "dongCode", ascending: false)
        
        cfetchRequest.sortDescriptors = [cityDesc]
        dfetchRequest.sortDescriptors = [dongDesc]
        do{
        //데이터 가져오기
        let cresultSet = try self.context.fetch(cfetchRequest)
        let dresultSet = try self.context.fetch(dfetchRequest)
        //데이터 순회
        for imsi in cresultSet{
            
        }
        for imsi in dresultSet{
        }
        }catch let e as NSError{
            print("\(e.localizedDescription)")
        }
        
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
        if userDefaults?.value(forKey: "a") == nil{
            self.download()
        }
        
        

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

    
    

    func download() {
        //앱이 설치되었을 때 1번만 실행---------------------------------------------------
       
            userDefaults?.set(0, forKey: "a")
            //비동기적으로 내장 된 csv 데이터 다운 받기
            DispatchQueue.main.async(execute: {
                guard let citylistPath = Bundle.main.path(forResource: "citylist", ofType: "csv") else{return}
                guard citylistPath.isEmpty == false else{
                    print("citylist 경로 없음")
                    return
                }
                
                var citylistData: String? = nil
                
                do {
                    citylistData = try String(contentsOfFile: citylistPath, encoding: String.Encoding.utf8)
                    let citysData = citylistData?.csvRows()
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
                    
                } catch{
                    print(error)
                }
                
                
                //=====>
                
                guard let donglistPath = Bundle.main.path(forResource: "donglist", ofType: "csv") else{return}
                guard donglistPath.isEmpty == false else{
                    print("donglist 경로 없음")
                    return
                }
                
                var donglistData: String? = nil
                
                do {
                    donglistData = try String(contentsOfFile: donglistPath, encoding: String.Encoding.utf8)
                    let dongsData = donglistData?.csvRows()
                    var count = 0
                    for row in dongsData!{
                        if count == 0{
                            count = count + 1
                        }else{
                            //print(row)
                            //새로 저장할 객체를 생성
                            let dongObject = NSEntityDescription.insertNewObject(forEntityName: "DongList", into: self.context) as! DongListMO
                            //print("city리스트: \(object)")
                            let myInteger = row[1] as NSString
                            let mmyInteger = myInteger as String
                            let mmmyInteger = Int32(mmyInteger)
                            
                            let myInteger1 = row[0] as NSString
                            let mmyInteger1 = myInteger1 as String
                            let mmmyInteger1 = Int32(mmyInteger1)
                            
                            dongObject.dongCode = mmmyInteger!
                            dongObject.dongName = row[2]
                            dongObject.cityList?.cityCode = mmmyInteger1!
                            //print(mmmyInteger!)
                            //print(mmmyInteger1!)
                            
                            //coreData에 저장
                            do{
                                try self.context.save()
                                //print(cityObject.cityCode)
                            }catch let e as NSError{
                                print("\(e.localizedDescription)")
                            }
                            
                        }
                    }
                    
                } catch{
                    print(error)
                }
                
                
            })
        
        
        //---------------------------------------------------------------
    }

}

