//
//  RegistrationService.swift
//  MparkMobilParkolas_IOS
//
//  Created by Administrator on 2020. 03. 26..
//  Copyright © 2020. BJ. All rights reserved.
//

import UIKit

class RegistrationService {
    
    let utils = Utils();

    
    // Ellenörzi, hogy a  regisztrációs kód text mező helyesen van-e kitöltve
    func apiKeyEllenorzese(_ apiKey: String) -> String {
        let tisztitottApiKey: String;
        var result: String = "RENDBEN";
        if (apiKey.isEmpty) {
            result = "msg_002";
        } else {
            tisztitottApiKey = apiKey.replacingOccurrences(of: " ", with: "");
            // Amennyiben a regisztrációs kód hossza nem egyenló 8-al, akkor nemjó a kód
            if (tisztitottApiKey.count != 8) {
                result = "msg_003";
            }
        }
        return result;
    }
    
        // Lekérdezi, hogy létezik-e a regisztrációs kód.
        // Amennyiben létezik, úgy visszakapjuk a regisztráció kód mellett a kódhoz tartozó telefonszámot is.
        func checkApiKey(apiKey: String) -> (phoneNumber: String, JSONresult: String) {
            var phoneNumber: String = "";
            var JSONresult: String = "";
            let semaphore = DispatchSemaphore(value: 0);
            // Le kell kérdezni az ügyfél adatait
            URLCache.shared = URLCache(memoryCapacity: 0, diskCapacity: 0, diskPath: nil)
                                 
            let url = createURLWithComponentsRegistration(paramApiKey: apiKey)!
            let request = NSMutableURLRequest(url: url as URL)
            
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "PUT"
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: request as URLRequest, completionHandler: handle(data: response: error:))
            
            task.resume()
/*
            let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
                guard error == nil && data != nil else
                {
                    print("Hiba");
                    return;
                }
                let httpStatus = response as? HTTPURLResponse
                
                if httpStatus!.statusCode == 200
                {
                    if data?.count != 0
                    {
                        //self.parseJSON(registrationResponse: data!)
                        let jsonString = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary
                        print (jsonString)
                        if ((jsonString["result"]) != nil) {
                            JSONresult = (jsonString["result"] as? String)!;
                            switch JSONresult {
                                case "OK":
                                    // Sikeres hívás, lekérdezzük a telefonszámt.
                                    phoneNumber = (jsonString["phone"] as! String);
                                default:
                                    // Egyéb hiba
                                    phoneNumber = "";
                            }
                        }
                    } else {
                        phoneNumber = "";
                        JSONresult = "";
                    }
                    
    //            } else {
    //                self.displayAlertMessage(alertTitle: "Hiba!", userMessage: self.utils.msg_1002)
                }
                semaphore.signal();
            }
 */
  //          task.resume()
            _ = semaphore.wait(timeout: DispatchTime.distantFuture)
            return (phoneNumber, JSONresult);
        }
        
    func handle(data: Data?, response: URLResponse?, error: Error?) {
        if error != nil {
            print (error!)
            return
        }
        
        if let safeData = data {
            let dataString = String(data: safeData, encoding: .utf8)
            print (dataString)
        }
    }
    
    func parseJSON(registrationResponse: Data) {
        print (registrationResponse);
        let decoder = JSONDecoder();
        do {
            let decodedData = try decoder.decode(RegistrationResponse.self, from: registrationResponse);
            print (decodedData.phone);
            print (decodedData.error);
            print (decodedData.success);
            print (decodedData.result);
        } catch {
            print (error)
        }
    }
    
        // A hívás url-jét állítja össze, amihez hozzáadja a paraméterben kapott értéket is.
        func createURLWithComponentsRegistration(paramApiKey: String) -> NSURL? {
            
            let urlComponents = NSURLComponents()
            urlComponents.scheme = Konst.enviroment.protokol;
            urlComponents.host = Konst.enviroment.host;
            urlComponents.path = Konst.enviroment.registrationUrl;
            
            // Hozzáadjuk a query paramétert
            let queryApiKey = NSURLQueryItem(name: "apikey", value: paramApiKey)
            urlComponents.queryItems = [queryApiKey as URLQueryItem]
            
            return urlComponents.url as NSURL?
        }

    
}
