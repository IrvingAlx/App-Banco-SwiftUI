//
//  Movimiento.swift
//  BancoIberoSwiftApp
//
//  Created by Irving Alejandro Vega Lagunas on 16/10/23.
//

import Foundation

struct Movimiento: Identifiable, Codable {
    var noMov: Int
    var deposito: String
    var retiro: String
    var fechaMov: String
    var descripcion: String

    var id: Int {
        return noMov
    }

    enum CodingKeys: String, CodingKey {
        case noMov = "no_mov"
        case deposito
        case retiro
        case fechaMov = "fecha_mov"
        case descripcion
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        noMov = try container.decode(Int.self, forKey: .noMov)
        deposito = try container.decode(String.self, forKey: .deposito)
        retiro = try container.decode(String.self, forKey: .retiro)
        fechaMov = try container.decode(String.self, forKey: .fechaMov)
        descripcion = try container.decode(String.self, forKey: .descripcion)
    }
}
