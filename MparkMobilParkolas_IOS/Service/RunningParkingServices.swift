//
//  RunningParking.swift
//  MparkMobilParkolas_IOS
//
//  Created by Administrator on 2020. 04. 13..
//  Copyright © 2020. BJ. All rights reserved.
//

import UIKit

class RunningParkingServices {
    
    func runningParkingGet(apiKey: String, phoneNumber: String, parkingId: String) -> RunningParkingResponse {
        
        var runningParkingResponse = RunningParkingResponse(parkingId: "", start: "", duration: "", parkingCost: "", zoneCost: "", result:"");
        
        let semaphore = DispatchSemaphore(value: 0);
        URLCache.shared = URLCache(memoryCapacity: 0, diskCapacity: 0, diskPath: nil);
        
        let url = createURLWithComponentsRunningParking(paramPhoneNumber: phoneNumber, paramApiKey: apiKey, paramParkingId: parkingId)!;
        
        let request = NSMutableURLRequest(url: url as URL);
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type"); //Optional
        request.httpMethod = "GET";
        
        let session = URLSession(configuration: .default);
        
        // Meghívjuk a GET metódust a futó parkolási adatok lekérdezéséhez
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil {
                runningParkingResponse = RunningParkingResponse(parkingId: "", start: "", duration: "", parkingCost: "", zoneCost: "", result:"-9999");
            }
            
            if let safeData = data {
                runningParkingResponse = self.runningParkingParseJSON(accountPlates: safeData);
            }
            semaphore.signal();
        }
        task.resume();
        
        let result = semaphore.wait(timeout: .distantFuture);
        switch result {
        case .success:
            return runningParkingResponse;
        case .timedOut:
            return RunningParkingResponse(parkingId: "", start: "", duration: "", parkingCost: "", zoneCost: "", result:"-9998");
        }
        
    }
    
    func stopParkingGET(apiKey: String, phoneNumber: String, parkingId: String) -> RunningParkingResponse {
        
        var stopParkingResponse = RunningParkingResponse(parkingId: "", start: "", duration: "", parkingCost: "", zoneCost: "", result:"");
        
        let semaphore = DispatchSemaphore(value: 0);
        URLCache.shared = URLCache(memoryCapacity: 0, diskCapacity: 0, diskPath: nil);
        
        let url = createURLWithComponentsStopParking(paramPhoneNumber: phoneNumber, paramApiKey: apiKey, paramParkingId: parkingId)!;
        
        let request = NSMutableURLRequest(url: url as URL);
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type"); //Optional
        request.httpMethod = "POST";
        
        let session = URLSession(configuration: .default);
        
        // Meghívjuk a GET metódust a futó parkolási adatok lekérdezéséhez
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil {
                stopParkingResponse = RunningParkingResponse(parkingId: "", start: "", duration: "", parkingCost: "", zoneCost: "", result:"-9999");
            }
            
            if let safeData = data {
                stopParkingResponse = self.stopParkingParseJSON(accountPlates: safeData);
            }
            semaphore.signal();
        }
        task.resume();
        
        let result = semaphore.wait(timeout: .distantFuture);
        switch result {
        case .success:
            return stopParkingResponse;
        case .timedOut:
            return RunningParkingResponse(parkingId: "", start: "", duration: "", parkingCost: "", zoneCost: "", result:"-9998");
        }
        
    }
    
    // A futó parkolás adatainka GET URL összeállítása
    func createURLWithComponentsRunningParking(paramPhoneNumber: String, paramApiKey: String, paramParkingId: String) -> NSURL? {
        let urlComponents = NSURLComponents()
        urlComponents.scheme = Konst.enviroment.protokol;
        urlComponents.host = Konst.enviroment.host;
        urlComponents.path = Konst.enviroment.runningParkingGetUrl;
        
        // Hozzáadjuk a query paramétert
        let queryApiKey = NSURLQueryItem(name: "apikey", value: paramApiKey);
        let queryPhoneNumber = NSURLQueryItem(name: "phone", value: paramPhoneNumber);
        let queryParkingId = NSURLQueryItem(name: "parkingId", value: paramParkingId);
        urlComponents.queryItems = [queryApiKey as URLQueryItem, queryPhoneNumber as URLQueryItem, queryParkingId as URLQueryItem]
        
        return urlComponents.url as NSURL?
    }
    
    // A futó parkolás leállítása GET URL összeállítása
    func createURLWithComponentsStopParking(paramPhoneNumber: String, paramApiKey: String, paramParkingId: String) -> NSURL? {
        let urlComponents = NSURLComponents()
        urlComponents.scheme = Konst.enviroment.protokol;
        urlComponents.host = Konst.enviroment.host;
        urlComponents.path = Konst.enviroment.stopParkingGetUrl;
        
        // Hozzáadjuk a query paramétert
        let queryApiKey = NSURLQueryItem(name: "apikey", value: paramApiKey);
        let queryPhoneNumber = NSURLQueryItem(name: "phone", value: paramPhoneNumber);
        let queryParkingId = NSURLQueryItem(name: "parkingId", value: paramParkingId);
        urlComponents.queryItems = [queryApiKey as URLQueryItem, queryPhoneNumber as URLQueryItem, queryParkingId as URLQueryItem]
        
        return urlComponents.url as NSURL?
    }
    
    // A futó parkolás adatok JSON dekódolás
    func runningParkingParseJSON(accountPlates: Data) -> RunningParkingResponse {
        let decoder = JSONDecoder();
        do {
            let decodedData = try decoder.decode(RunningParkingResponse.self, from: accountPlates)
            return decodedData
        } catch {
            return RunningParkingResponse(parkingId: "", start: "", duration: "", parkingCost: "", zoneCost: "", result:"-9999");
        }
    }
    
    // A futó parkolás adatok JSON dekódolás
    func stopParkingParseJSON(accountPlates: Data) -> RunningParkingResponse {
        let decoder = JSONDecoder();
        do {
            let decodedData = try decoder.decode(RunningParkingResponse.self, from: accountPlates)
            return decodedData
        } catch {
            return RunningParkingResponse(parkingId: "", start: "", duration: "", parkingCost: "", zoneCost: "", result:"-9999");
        }
    }
}
