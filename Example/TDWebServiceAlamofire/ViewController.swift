//
//  ViewController.swift
//  TDWebServiceAlamofire
//
//  Created by trident10 on 11/13/2017.
//  Copyright (c) 2017 trident10. All rights reserved.
//

import UIKit
import TDWebServiceAlamofire
import TDWebService
import TDResult

class ViewController: UIViewController {
    
    lazy var test = Test()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        test.call { (result) in
            switch result {
            case .Success(let movies):
                print(movies)
                
            case .Error(let error):
                print(error)
                
            }
        }
        //test.call
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    //Test
}

struct User{
    
}

struct NehaoValidator: TDResultValidatorApi{
    func validateResponse(_ result: TDWSResponse) -> TDResult<TDWSResponse, TDError> {
        let json = result.resultData as! TDJson
        let resultJson = json.jsonData as? [String: Any]
        if resultJson == nil{
            return TDResult.Error(TDError.init(Validation.NotAuthorised))
        }
        return TDResult.init(value: result)
    }
    
    enum Validation: Error{
        case NotValid
        case NotAuthorised
    }
    
}

class Test: TDWebserviceAlamofire{
    
    func url() -> String {
        return "https://httpbin.org/get"
    }
    
    enum TestApiError: Error{
        case Unauthorised
    }
    
    func resultType() -> TDResultType {
        return .JSON
    }
    
    func validalidatorClient() -> TDResultValidatorApi? {
        return NehaoValidator()
    }
    
    var handler : ((TDResult<User, TDError>) -> Void)?
    
    
    func call(_ completionHandler: @escaping (TDResult<User, TDError>) -> Void) {
        handler = completionHandler
        
        apiCall {(result) in
            switch result {
            case .Success(let resultString):
                print(resultString)
            //print(isResultValid)
            case .Error(let error):
                print(error)
                completionHandler(TDResult<User, TDError>.init(error: TestApiError.Unauthorised))
            }
            
        }
        
    }
}

