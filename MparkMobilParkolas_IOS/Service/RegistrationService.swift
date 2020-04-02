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
        func checkApiKey(apiKey: String) -> (phoneNumber: String, responseData: String) {
            var phoneNumber: String = "";
            var responseData: String = "";
            let semaphore = DispatchSemaphore(value: 0);
            // Le kell kérdezni az ügyfél adatait
            URLCache.shared = URLCache(memoryCapacity: 0, diskCapacity: 0, diskPath: nil)
                                 
            let url = createURLWithComponentsRegistration(paramApiKey: apiKey)!
            let request = NSMutableURLRequest(url: url as URL)
            
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "PUT"
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
                if error != nil {
                    print (error!)
                    responseData = "-9999";
                    //phoneNumber = "";
                    //return (phoneNumber, responseData);
                }
                
                if let safeData = data {
                    let registrationResponseData = self.parseJSON(registrationResponse: safeData);
                    if (registrationResponseData.success) {
                        responseData = registrationResponseData.result
                        switch responseData {
                        case "OK":
                            phoneNumber = registrationResponseData.phone!;
                        default:
                            phoneNumber = "";
                        }
                    } else {
                        // Hiba van nem sikerült a művelet
                    }
                }
                semaphore.signal();
            }
            
            task.resume()
            _ = semaphore.wait(timeout: DispatchTime.distantFuture)
            return (phoneNumber, responseData);
        }
        
    
    func parseJSON(registrationResponse: Data) -> RegistrationResponse {
        //print (registrationResponse);
        let decoder = JSONDecoder();
        var decodedData = RegistrationResponse(phone: nil, result: "", success: false, error: nil);
        do {
            decodedData = try decoder.decode(RegistrationResponse.self, from: registrationResponse)
        } catch {
            decodedData.error = Konst.error.err_9999;
        }
        return decodedData;
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
