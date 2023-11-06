//
//  Tarjeta.swift
//  BancoIberoSwiftApp
//
//  Created by Irving Alejandro Vega Lagunas on 16/10/23.
//

import Foundation

class Tarjeta: Codable{
    var noTarjeta : Int
    var cvv : String
    var nip : String
    var marca : String
    var fechaExpiracion : Date
    var estatus : Bool
    var tarjetas :Int
    
    init(noTarjeta: Int, cvv: String, nip: String, marca: String, fechaExpiracion: Date, estatus: Bool) {
        self.noTarjeta = noTarjeta
        self.cvv = cvv
        self.nip = nip
        self.marca = marca
        self.fechaExpiracion = fechaExpiracion
        self.estatus = estatus
        self.tarjetas = 0
    }
    
    init(noTarjeta: Int) {
        self.noTarjeta = noTarjeta
        self.cvv = "000"
        self.nip = "1234"
        self.marca = "Visa"
        self.fechaExpiracion = Date()
        self.estatus = true
        self.tarjetas = 0

    }
}
