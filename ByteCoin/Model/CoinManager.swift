//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateCoin(_ coinManager: CoinManager, coin: CoinModel)
    func didFailWithError(error: Error)
    
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/"
    let apiKey = "515B29AD-953D-4D48-856C-5703FCF4D149"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR","ARS"]
    
   
    var delegate: CoinManagerDelegate?
    
    func fechCoin (moneda: String) {
        let urlString = "\(baseURL)BTC/\(moneda)?apikey=\(apiKey)"
        perfomRequest(urlString: urlString)
        
    }
    
    func perfomRequest (urlString: String) {
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data , response , error ) in
                if error != nil{
                    delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let coin = parseJSON(safeData){
                        self.delegate?.didUpdateCoin(self, coin: coin)
                    }
                    
                }
            }
            
            
            task.resume()
            
        }
        
        
    }
    
    func parseJSON (_ coinData: Data) -> CoinModel? {
        let decoder = JSONDecoder()
        do {
            let decodeData = try decoder.decode(CoinData.self, from: coinData)
            let cripto = decodeData.asset_id_base
            let moneda = decodeData.asset_id_quote
            let cambio = decodeData.rate
            
            let coin = CoinModel(cripto: cripto, moneda: moneda, cambio: cambio)
            return coin
        }catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
        
        
    
    }


}
