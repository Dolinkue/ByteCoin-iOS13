//
//  CoinModel.swift
//  ByteCoin
//
//  Created by Nicolas Dolinkue on 21/02/2022.
//  Copyright © 2022 The App Brewery. All rights reserved.
//

import Foundation

struct CoinModel {
    let cripto: String
    let moneda: String
    let cambio: Double
    
    var cambioString: String {
        return String(format: "%.4f", cambio)
    }
}
