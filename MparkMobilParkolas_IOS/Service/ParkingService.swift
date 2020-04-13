//
//  ParkingService.swift
//  MparkMobilParkolas_IOS
//
//  Created by Administrator on 2020. 03. 31..
//  Copyright © 2020. BJ. All rights reserved.
//

import UIKit

class ParkingService {
 
    // Account adatok GET függvényhívása
    func getAccountDataGET(phoneNumber: String, apiKey: String) -> (plate: String, parkingId: String, amount: String, responseData: String) {
        
        var plate: String = "";
        var parkingId: String = "";
        var amount: String = "";
        var responseData: String = "";
        
        // Beállítjuk a semaphore-t, hogy csak az aszinkron hívás befejezését megvárjuk
        let semaphore = DispatchSemaphore(value: 0);
        URLCache.shared = URLCache(memoryCapacity: 0, diskCapacity: 0, diskPath: nil)
        
        // Összeállítjuk az URL-t
        let url = createURLWithComponentsAccount(paramPhoneNumber: phoneNumber, paramApiKey: apiKey)!
        let request = NSMutableURLRequest(url: url as URL)

        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type") //Optional
        request.httpMethod = "GET"

        let session = URLSession(configuration: .default);
        
        // Meghívjuk a GET metódust
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil {
              print (error!)
              responseData = "-9999";
            }

            if let safeData = data {
                
                let parkingAccountResponseData = self.accountParseJSON(parkingAccountResponse: safeData);
                responseData = parkingAccountResponseData.result
                switch responseData {
                    case "OK":
                        plate = parkingAccountResponseData.plate!;
                        parkingId = parkingAccountResponseData.parkingId!;
                        amount = parkingAccountResponseData.amount!;
                    case "-1003":
                        plate = parkingAccountResponseData.plate!;
                        parkingId = parkingAccountResponseData.parkingId!;
                        amount = parkingAccountResponseData.amount!;
                    default:
                        plate = "";
                        parkingId = "";
                        amount = "";
                }
            }
        semaphore.signal();
        }
        task.resume();

        let result = semaphore.wait(timeout: .distantFuture);
        // Sikeres lefutás esetén levesszük az indikátort a képernyőröl
        switch result {
        case .success:
            return (plate, parkingId, amount, responseData);
        case .timedOut:
            return ("", "-1", "-1", "-9998");
        }
    }
    
    func startParkinPOST (phoneNumber: String, apiKey: String, aktPlate: String, zoneCode: String)  -> (parkingId: String, duration: String, parkingCost: String, zonaCost: String, responseData: String) {
        
        var parkingId: String = "";
        var duration: String = "";
        var parkingCost: String = "";
        var zoneCost: String = "";
        var responseData: String = "";
        
        // Beállítjuk a semaphore-t, hogy csak az aszinkron hívás befejezését megvárjuk
        let semaphore = DispatchSemaphore(value: 0);
        URLCache.shared = URLCache(memoryCapacity: 0, diskCapacity: 0, diskPath: nil)
        
        // Összeállítjuk az URL-t
        let url = createURLWithComponentsstartParkin(paramPhoneNumber: phoneNumber, paramApiKey: apiKey, paramAktPlate: aktPlate, paramZone: zoneCode)!
        let request = NSMutableURLRequest(url: url as URL)

        request.httpMethod = "POST"

        let session = URLSession(configuration: .default);
        
        // Meghívjuk a GET metódust
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil {
                print (error!)
                responseData = "-9999";
            }
            if let safeData = data {
                let startParkingResponseData = self.startParkingParseJSON(startParkingResponse: safeData);
                responseData = startParkingResponseData.result!
                switch responseData {
                    case "OK":
                        parkingId = startParkingResponseData.parkingId!;
                        duration = startParkingResponseData.duration!;
                        parkingCost = startParkingResponseData.parkingCost!;
                        zoneCost = startParkingResponseData.zoneCost!;
                    case "-1003":
                        parkingId = startParkingResponseData.parkingId!;
                    default:
                        parkingId = "";
                        duration = "";
                        parkingCost = "";
                        zoneCost = "";
                }
            }
            
            
            
            semaphore.signal();
        }
        task.resume();

        let result = semaphore.wait(timeout: .distantFuture);
        // Sikeres lefutás esetén levesszük az indikátort a képernyőröl
        switch result {
        case .success:
            return (parkingId, duration, parkingCost, zoneCost, responseData);
        case .timedOut:
            return (parkingId, duration, parkingCost, zoneCost, "-9998");
        }
    }
    
    // Account adatok JSON dekódolás
    func accountParseJSON(parkingAccountResponse: Data) -> ParkingAccountResponse {
        let decoder = JSONDecoder();
        var decodedData = ParkingAccountResponse(amount: "", plate: "", parkingId: "", result: "");
        do {
            decodedData = try decoder.decode(ParkingAccountResponse.self, from: parkingAccountResponse)
            return decodedData
        } catch {
            decodedData.result = "-9999";
        }
        return decodedData;
    }
    
    // StartParking adatok JSON dekódolás
    func startParkingParseJSON(startParkingResponse: Data) -> StartParkingResponse {
        let decoder = JSONDecoder();
        var decodedData = StartParkingResponse(parkingId: "", duration: "", parkingCost: "", zoneCost: "", result: "")
        do {
            decodedData = try decoder.decode(StartParkingResponse.self, from: startParkingResponse)
            print(decodedData)
            return decodedData
        } catch {
            print(error)
            decodedData.result = "-9999";
        }
        return decodedData;
    }
   
    // Account adatok lekéréséhez GET URL összeállítása
    func createURLWithComponentsAccount(paramPhoneNumber: String, paramApiKey: String) -> NSURL? {
        let urlComponents = NSURLComponents()
        urlComponents.scheme = Konst.enviroment.protokol;
        urlComponents.host = Konst.enviroment.host;
        urlComponents.path = Konst.enviroment.accountGetUrl;
        
        // Hozzáadjuk a query paramétert
        let queryApiKey = NSURLQueryItem(name: "apikey", value: paramApiKey);
        let queryPhoneNumber = NSURLQueryItem(name: "phone", value: paramPhoneNumber);
        urlComponents.queryItems = [queryApiKey as URLQueryItem, queryPhoneNumber as URLQueryItem]
        
        return urlComponents.url as NSURL?
    }
  
    // Parkolás indításához POST URL összeállítása
    func createURLWithComponentsstartParkin(paramPhoneNumber: String, paramApiKey: String, paramAktPlate: String, paramZone: String) -> NSURL? {
        let urlComponents = NSURLComponents()
        urlComponents.scheme = Konst.enviroment.protokol;
        urlComponents.host = Konst.enviroment.host;
        urlComponents.path = Konst.enviroment.startParkingPostUrl;
        
        // Hozzáadjuk a query paramétert
        let queryApiKey = NSURLQueryItem(name: "apikey", value: paramApiKey);
        let queryPhoneNumber = NSURLQueryItem(name: "phone", value: paramPhoneNumber);
        let queryAktPlate = NSURLQueryItem(name: "plate", value: paramAktPlate);
        let queryZone = NSURLQueryItem(name: "zone", value: paramZone);
        urlComponents.queryItems = [queryApiKey as URLQueryItem, queryPhoneNumber as URLQueryItem, queryAktPlate as URLQueryItem, queryZone as URLQueryItem]
        
        return urlComponents.url as NSURL?
    }
    
}
