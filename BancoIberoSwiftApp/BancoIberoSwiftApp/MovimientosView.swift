//
//  MovimientosView.swift
//  BancoIberoSwiftApp
//
//  Created by Irving Alejandro Vega Lagunas on 21/10/23.
//

import SwiftUI

struct MovimientosView: View {
        @State var numeroTarjeta: String = ""
    @State private var movimientos: [Movimiento] = []

        func fetchMovimientos(numeroTarjeta: String) {
           // Realiza una solicitud HTTP al servidor Flask para obtener los movimientos
           let url = URL(string: "http://127.0.0.1:8000/movimientos_por_tarjeta")! // Reemplaza con la URL correcta
           let bodyData: [String: String] = ["numero_tarjeta": numeroTarjeta] // Reemplaza con el número de tarjeta adecuado

            guard let jsonData = try? JSONSerialization.data(withJSONObject: bodyData) else {
                print("Error al serializar datos")
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error en la solicitud: \(error)")
                }

                if let data = data {
                    do {
                        let jsonString = String(data: data, encoding: .utf8)
                        print("JSON Data: \(jsonString ?? "No se puede decodificar a texto")")
                        let decoder = JSONDecoder()
                        let movimientos = try decoder.decode([Movimiento].self, from: data)
                       // Actualizar el estado de movimientos con los datos obtenidos
                        self.movimientos = movimientos
                    } catch {
                        print("Error al decodificar datos: \(error.localizedDescription)")
                    }
                } else {
                    print("No se recibieron datos en la respuesta.")
                }
            }.resume()
        }

    var body: some View {
        VStack{
            Text("Movimientos")
                .font(.system(size: 36, weight: .heavy, design: .rounded))
                .multilineTextAlignment(.center)

            Image("transaction")
                .resizable()
                .scaledToFit()
                .imageScale(.large)
                .cornerRadius(10)
        
            List(movimientos) { movimiento in
                VStack(alignment: .leading) {
                    Text("Movimiento")
                        .font(.title)
                    Text("Fecha: \(movimiento.fechaMov)")
                    Text("Depósito: \(movimiento.deposito)")
                    Text("Descripción: \(movimiento.descripcion)")
                    Text("Retiro: \(movimiento.retiro)")
                }
            }
            .frame(height: 400)
        }
        .onAppear {
            fetchMovimientos(numeroTarjeta: numeroTarjeta)
        }
    }
}

#Preview {
    MovimientosView()
}
