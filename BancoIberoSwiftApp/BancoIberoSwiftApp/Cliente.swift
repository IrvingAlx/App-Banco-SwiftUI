//
//  Cliente.swift
//  BancoIberoSwiftApp
//
//  Created by Irving Alejandro Vega Lagunas on 16/10/23.
//

import Foundation

class Cliente: Codable {
    var no_cliente: Int
    var nombre: String
    var apellido_paterno: String
    var apellido_materno: String?
    var fecha_nacimiento: Date?
    var sexo: Character
    var cuentas: [Cuenta]?
    var cuentas_cliente: [String]?

    
    // Inicializador de conveniencia para manejar la fecha de nacimiento como String
        init(no_cliente: Int, nombre: String, apellido_paterno: String, apellido_materno: String?, fecha_nacimiento: String?, sexo: Character, cuentas: [Cuenta]?) {
            self.no_cliente = no_cliente
            self.nombre = nombre
            self.apellido_paterno = apellido_paterno
            self.apellido_materno = apellido_materno
            self.sexo = sexo
            self.cuentas = cuentas
            
            if let fechaNacimientoString = fecha_nacimiento {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                self.fecha_nacimiento = dateFormatter.date(from: fechaNacimientoString)
            } else {
                self.fecha_nacimiento = nil  // Valor predeterminado si la fecha no está presente
            }
        }
    
    init(no_cliente: Int, nombre: String, apellido_paterno: String, apellido_materno: String?, fecha_nacimiento: Date, sexo: Character, cuentas: [Cuenta]?) {
        self.no_cliente = no_cliente
        self.nombre = nombre
        self.apellido_paterno = apellido_paterno
        self.apellido_materno = apellido_materno
        self.fecha_nacimiento = fecha_nacimiento
        self.sexo = sexo
        self.cuentas = [Cuenta]()
    }

    init(nombre: String, apellido_paterno: String, apellido_materno: String?, fecha_nacimiento: Date, sexo: Character, cuentas: [Cuenta]?) {
        self.no_cliente = 0
        self.nombre = nombre
        self.apellido_paterno = apellido_paterno
        self.apellido_materno = apellido_materno
        self.fecha_nacimiento = fecha_nacimiento
        self.sexo = sexo
        self.cuentas = [Cuenta]()
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        no_cliente = try container.decode(Int.self, forKey: .no_cliente)
        nombre = try container.decode(String.self, forKey: .nombre)
        apellido_paterno = try container.decode(String.self, forKey: .apellido_paterno)
        
        // Manejo especial para el valor nulo (null) en apellido_materno
        if let apellido_materno = try? container.decode(String.self, forKey: .apellido_materno) {
            self.apellido_materno = apellido_materno
        } else {
            self.apellido_materno = nil
        }

        if let fechaNacimientoString = try? container.decode(String.self, forKey: .fecha_nacimiento) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if let fecha = dateFormatter.date(from: fechaNacimientoString) {
                fecha_nacimiento = fecha
            } else {
                // Manejo del caso en el que la fecha no es válida
                // Puedes asignar un valor predeterminado o manejarlo de otra manera
                fecha_nacimiento = Date() // Por ejemplo, usar la fecha actual como valor predeterminado
            }
        } else {
            // La clave "fecha_nacimiento" no está presente en los datos JSON
            // Puedes asignar un valor predeterminado o manejarlo de otra manera
            fecha_nacimiento = Date() // Por ejemplo, usar la fecha actual como valor predeterminado
        }
        
        if let sexoString = try? container.decode(String.self, forKey: .sexo) {
            sexo = Character(sexoString)
        } else {
            // La clave "sexo" no está presente en los datos JSON
            // Puedes asignar un valor predeterminado o manejarlo de otra manera
            sexo = "?" // Por ejemplo, usar un valor predeterminado como "?" en caso de falta de datos
        }
        
        cuentas_cliente = try container.decodeIfPresent([String].self, forKey: .cuentas_cliente)
    }


        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(no_cliente, forKey: .no_cliente)
            try container.encode(nombre, forKey: .nombre)
            try container.encode(apellido_paterno, forKey: .apellido_paterno)
            try container.encode(apellido_materno, forKey: .apellido_materno)
            try container.encode(fecha_nacimiento, forKey: .fecha_nacimiento)
            try container.encode(String(sexo), forKey: .sexo)
            try container.encode(cuentas, forKey: .cuentas)
            try container.encode(cuentas_cliente, forKey: .cuentas_cliente)

        }

    enum CodingKeys: String, CodingKey {
        case no_cliente
        case nombre
        case apellido_paterno
        case apellido_materno
        case fecha_nacimiento
        case sexo
        case cuentas
        case cuentas_cliente
    }
    
    
}
