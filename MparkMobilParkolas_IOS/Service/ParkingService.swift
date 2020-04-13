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
    func getAccountDataGET(phoneNumber: String, apiKey: String) -> ParkingAccountResponse {
        
        var parkingAccountResponse = ParkingAccountResponse(amount: "", plate: "", parkingId: "", result: "", status: "");
        
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
                parkingAccountResponse = ParkingAccountResponse(amount: "-1", plate: "", parkingId: "-1", result: "-9999", status: "");
            }
            
            if let safeData = data {
                parkingAccountResponse = self.accountParseJSON(parkingAccountResponse: safeData);
            }
            semaphore.signal();
        }
        task.resume();
        
        let result = semaphore.wait(timeout: .distantFuture);
        // Sikeres lefutás esetén levesszük az indikátort a képernyőröl
        switch result {
        case .success:
            return parkingAccountResponse;
        case .timedOut:
            return ParkingAccountResponse(amount: "-1", plate: "", parkingId: "", result: "-9999", status: "");
        }
    }
    
    func startParkinPOST (phoneNumber: String, apiKey: String, aktPlate: String, zoneCode: String)  -> StartParkingResponse {

        var startParkingResponse = StartParkingResponse(parkingId: "", duration: "", parkingCost: "", zoneCost: "", result: "");
        
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
                startParkingResponse = StartParkingResponse(parkingId: "-1", duration: "", parkingCost: "", zoneCost: "", result: "-9999");
            }
            if let safeData = data {
                startParkingResponse = self.startParkingParseJSON(startParkingResponse: safeData);
            }
            semaphore.signal();
        }
        task.resume();

        let result = semaphore.wait(timeout: .distantFuture);
        // Sikeres lefutás esetén levesszük az indikátort a képernyőröl
        switch result {
        case .success:
            return startParkingResponse;
        case .timedOut:
            return StartParkingResponse(parkingId: "-1", duration: "", parkingCost: "", zoneCost: "", result: "-9998");
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
            decodedData = ParkingAccountResponse(amount: "-1", plate: "", parkingId: "-1", result: "-9999");
        }
        return decodedData;
    }
    
    // StartParking adatok JSON dekódolás
    func startParkingParseJSON(startParkingResponse: Data) -> StartParkingResponse {
        let decoder = JSONDecoder();
        var decodedData = StartParkingResponse(parkingId: "", duration: "", parkingCost: "", zoneCost: "", result: "");
        do {
            decodedData = try decoder.decode(StartParkingResponse.self, from: startParkingResponse)
            return decodedData;
        } catch {
            decodedData = StartParkingResponse(parkingId: "-1", duration: "", parkingCost: "", zoneCost: "", result: "-9999");
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
