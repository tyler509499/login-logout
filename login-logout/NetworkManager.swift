//
//  NetworkManager.swift
//  login-logout
//
//  Created by Galkov Nikita on 21.02.2021.
//

import Foundation
import Alamofire


private let createdTimeFormatter: DateFormatter = {
    let createdTimeFormatter = DateFormatter()
    createdTimeFormatter.timeZone = TimeZone.current
    createdTimeFormatter.dateFormat = "EEEE, d MMM yyyy HH:mm"
    return createdTimeFormatter
}()


class NetworkManager {
    
    static var token: String?
    
    struct Payments {
        let desc: String
        let amount: String
        let currency: String
        let created: String
    }
    
    var payments: [Payments] = []
    
    func postLogin(login: String , password: String, completion: @escaping(_ JSONResponse : Any?, _ error: Error?) -> ()) {
        
        let loginUrl = "http://82.202.204.94/api/login"
        
        let parameters = [
                "login": login,
                "password": password
            ]
        
        let headers: HTTPHeaders = [
            "app-key": "12345",
            "v": "1"
        ]
    
        AF.request(loginUrl, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success:
                guard let jsonData = response.data else {
                    return
                }
                do {
                    let result = try JSONDecoder().decode(CodableModel.loginResponse.self, from: jsonData)
                    switch result.success {
                    case "true":
                    NetworkManager.token = result.response.token
                    default:
                        break
                    }
                } catch {
                    print("Error: \(error)")
                }
                
                completion(jsonData, nil)
            case .failure(let error):
                print(error)
                completion(nil, error)
            }
        }
}
    
    func getPayments(completion: @escaping(_ JSONResponse : Any?, _ error: Error?) -> ()) {
        
        let paymentsUrl = "http://82.202.204.94/api/payments?token=\(NetworkManager.token!)"
        
        let headers: HTTPHeaders = [
            "app-key": "12345",
            "v": "1"
        ]
        
        AF.request(paymentsUrl, method: .get, parameters: [:], encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success:
                guard let jsonData = response.data else {
                    return
                }
                do {
                    let result = try JSONDecoder().decode(CodableModel.PaymentsResponse.self, from: jsonData)
                    switch result.success {
                    case "true":
                    for index in 0..<result.response.count{
                        
                        let paymentDesc = result.response[index].desc
                        
                        var paymentAmount: String = ""
                        switch result.response[index].amount {
                        case .double(let doubleValue):
                            paymentAmount = String(doubleValue)
                        case .string(let stringValue):
                            paymentAmount = stringValue
                        }
                        
                       
                        var paymentCurrency: String = ""
                        switch result.response[index].currency {
                        case nil:
                            paymentCurrency = "Empty Currency Data"
                        case "":
                            paymentCurrency = "Empty Currency Data"
                        default:
                            paymentCurrency = result.response[index].currency!
                        }

                        var paymentCreated: String = ""
                        if result.response[index].created != 0 {
                        let createdTimeDate = Date(timeIntervalSince1970: TimeInterval(result.response[index].created))
                        paymentCreated = createdTimeFormatter.string(from: createdTimeDate)
                        } else {
                        paymentCreated = "Empty Created Data"
                        }
                        
                        let paymentData = Payments(desc: paymentDesc, amount: paymentAmount, currency: paymentCurrency, created: paymentCreated)
                        
                        self.payments.append(paymentData)
                    
                    print(self.payments)
                    }
                    default:
                        break
                    }
                } catch {
                    print("Error: \(error)")
                }
                completion(jsonData, nil)
            
            case .failure(let error):
                print(error)
                completion(nil, error)
                }
            }
        }
        
    }

