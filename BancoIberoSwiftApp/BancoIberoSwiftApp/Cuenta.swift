//
//  Cuenta.swift
//  BancoIberoSwiftApp
//
//  Created by Irving Alejandro Vega Lagunas on 16/10/23.
//

import Foundation

class Cuenta: Codable {
    var noCuenta: Int
    var tipo: String
    var saldo: Double
    var moneda: String
    var estatus: Bool
    var movimientos: [Movimiento]
    var tarjetas: [Tarjeta]
    
    init() {
        self.noCuenta = 0
        self.tipo = "Ahorros"
        self.saldo = 0.0
        self.moneda = "MXN"
        self.estatus = true
        self.movimientos = [Movimiento]()
        self.tarjetas = [Tarjeta]()
    }
    
    init(noCuenta: Int) {
        self.noCuenta = noCuenta
        self.tipo = "Ahorros"
        self.saldo = 0.0
        self.moneda = "MXN"
        self.estatus = true
        self.movimientos = [Movimiento]()
        self.tarjetas = [Tarjeta]()
    }
    
    init(noCuenta: Int, tipo: String, saldo: Double, moneda: String, estatus: Bool) {
        self.noCuenta = noCuenta
        self.tipo = tipo
        self.saldo = saldo
        self.moneda = moneda
        self.estatus = estatus
        self.movimientos = [Movimiento]()
        self.tarjetas = [Tarjeta]()
    }

    enum CodingKeys: String, CodingKey {
        case noCuenta
        case tipo
        case saldo
        case moneda
        case estatus
        case movimientos
        case tarjetas
    }
}
