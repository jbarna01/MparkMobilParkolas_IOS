//
//  PlateChangeService.swift
//  MparkMobilParkolas_IOS
//
//  Created by Administrator on 2020. 04. 11..
//  Copyright © 2020. BJ. All rights reserved.
//

import UIKit

class PlateChangeService {
    
    // Lekérdezi az Account-hoz tartozó össze rendszámot
    func getAccountPlatesGET(phoneNumber: String, apiKey: String) -> AccountPlatesResponse {

        var accountPlatesResponse = AccountPlatesResponse(result: "-", allPlates: []);
        
        // Beállítjuk a semaphore-t, hogy csak az aszinkron hívás befejezését megvárjuk
        let semaphore = DispatchSemaphore(value: 0);
        
        URLCache.shared = URLCache(memoryCapacity: 0, diskCapacity: 0, diskPath: nil);
        
        // Összeállítjuk az URL-t
        let url = createURLWithComponentsAccountPlates(paramPhoneNumber: phoneNumber, paramApiKey: apiKey)!
        
        let request = NSMutableURLRequest(url: url as URL)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type") //Optional
        request.httpMethod = "GET"
        
        let session = URLSession(configuration: .default);
        
        // Meghívjuk a GET metódust
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil {
              print (error!)
              accountPlatesResponse = AccountPlatesResponse(result: "-9999", allPlates: []);
            }

            if let safeData = data {
                let accountPlatesResponseData = self.accountPlatesParseJSON(accountPlates: safeData);
                accountPlatesResponse = accountPlatesResponseData;
            }
        semaphore.signal();
        }
        task.resume();

        let result = semaphore.wait(timeout: .distantFuture);
        
        // Sikeres lefutás esetén levesszük az indikátort a képernyőröl
        switch result {
        case .success:
            return accountPlatesResponse;
        case .timedOut:
            return AccountPlatesResponse(result: "-9998", allPlates: []);
        }
    }

    // A kiválasztott rendszámot beállítja aktuális rendszámnak
    func changeAktPlatePOST(phoneNumber: String, apiKey: String, plate: String) -> ChangePlateResponse {
        
        var changePlateResponse = ChangePlateResponse(result: "");
        // Beállítjuk a semaphore-t, hogy csak az aszinkron hívás befejezését megvárjuk
        let semaphore = DispatchSemaphore(value: 0);
        
        URLCache.shared = URLCache(memoryCapacity: 0, diskCapacity: 0, diskPath: nil);
        
        // Összeállítjuk az URL-t
        let url = createURLWithComponentschangeAktPlate(paramPhoneNumber: phoneNumber, paramApiKey: apiKey, paramPlate: plate)!
        let request = NSMutableURLRequest(url: url as URL)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type") //Optional
        request.httpMethod = "POST"
        
        let session = URLSession(configuration: .default);
        
        // Meghívjuk a POST metódust
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil {
              print (error!)
              changePlateResponse = ChangePlateResponse(result: "-9998");
            }

            if let safeData = data {
                changePlateResponse = self.changeAktPlateParseJSON(response: safeData);
            }
        semaphore.signal();
        }
        task.resume();

        let result = semaphore.wait(timeout: .distantFuture);
        
        // Sikeres lefutás esetén levesszük az indikátort a képernyőröl
        switch result {
        case .success:
            return changePlateResponse;
        case .timedOut:
            return ChangePlateResponse(result: "-9998");
        }
    }

    // Accounthoz tartozó rendszámok lekéréséhez GET URL összeállítása
    func createURLWithComponentsAccountPlates(paramPhoneNumber: String, paramApiKey: String) -> NSURL? {
        let urlComponents = NSURLComponents()
        urlComponents.scheme = Konst.enviroment.protokol;
        urlComponents.host = Konst.enviroment.host;
        urlComponents.path = Konst.enviroment.accountPlatesGetUrl;
        
        // Hozzáadjuk a query paramétert
        let queryApiKey = NSURLQueryItem(name: "apikey", value: paramApiKey);
        let queryPhoneNumber = NSURLQueryItem(name: "phone", value: paramPhoneNumber);
        urlComponents.queryItems = [queryApiKey as URLQueryItem, queryPhoneNumber as URLQueryItem]
        
        return urlComponents.url as NSURL?
}

    // Aktuális rendszám változtatásához szükséges POST URL összeállítása
    func createURLWithComponentschangeAktPlate(paramPhoneNumber: String, paramApiKey: String, paramPlate: String) -> NSURL? {
        let urlComponents = NSURLComponents()
        urlComponents.scheme = Konst.enviroment.protokol;
        urlComponents.host = Konst.enviroment.host;
        urlComponents.path = Konst.enviroment.changeAktPlatesPostUrl;
        
        // Hozzáadjuk a query paramétert
        let queryApiKey = NSURLQueryItem(name: "apikey", value: paramApiKey);
        let queryPhoneNumber = NSURLQueryItem(name: "phone", value: paramPhoneNumber);
        let queryPlate = NSURLQueryItem(name: "plate", value: paramPlate);
        urlComponents.queryItems = [queryApiKey as URLQueryItem, queryPhoneNumber as URLQueryItem, queryPlate as URLQueryItem]
        
        return urlComponents.url as NSURL?
    }


    // Az Account-hoz tartozó rendszámok JSON dekódolás
    func accountPlatesParseJSON(accountPlates: Data) -> AccountPlatesResponse {
        let decoder = JSONDecoder();
        do {
            let decodedData = try decoder.decode(AccountPlatesResponse.self, from: accountPlates)
            return decodedData
        } catch {
            print (error)
            return AccountPlatesResponse(result: "-9999", allPlates: []);
        }
    }
    
    // A rendszám váltáshoz tartozó JSON dekódolás
    func changeAktPlateParseJSON(response: Data) -> ChangePlateResponse {
        let decoder = JSONDecoder();
        do {
            let decodedData = try decoder.decode(ChangePlateResponse.self, from: response)
            return decodedData
        } catch {
            print (error)
            return ChangePlateResponse(result: "-9999");
        }
    }
    
}
