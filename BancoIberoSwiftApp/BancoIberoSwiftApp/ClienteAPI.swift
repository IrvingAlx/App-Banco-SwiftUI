//
//  ClienteAPI.swift
//  BancoIberoSwiftApp
//
//  Created by Irving Alejandro Vega Lagunas on 04/11/23.
//

import Foundation

class ClienteAPI {
    static func guardarClienteEnServidor(_ cliente: Cliente, completion: @escaping (String?, Error?) -> Void) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        let jsonEncoder = JSONEncoder()
        jsonEncoder.dateEncodingStrategy = .formatted(formatter)

        if let jsonData = try? jsonEncoder.encode(cliente) {
            if let url = URL(string: "http://127.0.0.1:8000/cliente") {
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = jsonData

                URLSession.shared.dataTask(with: request) { data, response, error in
                    if let data = data {
                        if let respuesta = String(data: data, encoding: .utf8) {
                            completion(respuesta, nil)
                        } else {
                            completion(nil, NSError(domain: "ResponseError", code: 0, userInfo: nil))
                        }
                    } else if let error = error {
                        completion(nil, error)
                    }
                }.resume()
            }
        }
    }
    
    static func actualizarClienteEnServidor(_ cliente: Cliente, completion: @escaping (String?, Error?) -> Void) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let jsonEncoder = JSONEncoder()
        jsonEncoder.dateEncodingStrategy = .formatted(formatter)
        
        if let jsonData = try? jsonEncoder.encode(cliente) {
            if let url = URL(string: "http://127.0.0.1:8000/actualizar_cliente/\(cliente.no_cliente)") {
                var request = URLRequest(url: url)
                    request.httpMethod = "POST"
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.httpBody = jsonData

                URLSession.shared.dataTask(with: request) { data, response, error in
                    if let data = data {
                        if let respuesta = String(data: data, encoding: .utf8) {
                            completion(respuesta, nil)
                        } else {
                            completion(nil, NSError(domain: "ResponseError", code: 0, userInfo: nil))
                        }
                    } else if let error = error {
                        completion(nil, error)
                    }
                }.resume()
            }
        }
    }
}
