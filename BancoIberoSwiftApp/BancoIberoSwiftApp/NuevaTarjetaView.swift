//
//  NuevaTarjetaView.swift
//  BancoIberoSwiftApp
//
//  Created by Irving Alejandro Vega Lagunas on 21/10/23.
//

import SwiftUI

struct NuevaTarjetaView: View {
    @State private var numerosDeCuenta = [String]()
    @State private var marcaSelecionado = "VISA"
    @State private var cuentaSeleccionada = "50001"
    let marca = ["VISA","Mastercard","Amex"]
    @State private var mensajeConfirmacion = ""

    func generarNumeroCSVAleatorio() -> String {
        return String(format: "%03d", Int.random(in: 0...999))
    }
    
    func obtenerNumerosDeCuenta() {
            if let url = URL(string: "http://127.0.0.1:8000/numeros_de_cuenta") {
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                    if let data = data {
                        if let numeros = try? JSONDecoder().decode([String].self, from: data) {
                            DispatchQueue.main.async {
                                self.numerosDeCuenta = numeros
                            }
                        }
                    }
                }.resume()
            }
        }
    
    func generarTarjeta() {
        let nuevoCSV = generarNumeroCSVAleatorio()

        // Crea un diccionario con los datos
        let data = [
            "csv": nuevoCSV,
            "marca": marcaSelecionado,
            "cuenta": cuentaSeleccionada
        ]

        // Convierte el diccionario a datos JSON
        if let jsonData = try? JSONSerialization.data(withJSONObject: data) {
            // Crea la solicitud
            var request = URLRequest(url: URL(string: "http://127.0.0.1:8000/crear_tarjeta")!)
            request.httpMethod = "POST"
            request.httpBody = jsonData
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            // Realiza la solicitud al servidor
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        if let message = json["message"] as? String {
                            // La tarjeta se creó con éxito
                            mensajeConfirmacion = message
                            print(message)
                        } else if let error = json["error"] as? String {
                            // Hubo un error
                            print("Error: \(error)")
                        }
                    }
                } else if let error = error {
                    print("Error al realizar la solicitud: \(error)")
                }
            }.resume()
        }
    }

    
    var body: some View {
    
        VStack{
            Text("Nueva Tarjeta")
                .font(.system(size: 36, weight: .heavy, design: .rounded))
                .multilineTextAlignment(.center)
                .padding(20)
            Image("new-credit-card")
                .resizable()
                .scaledToFit()
                .imageScale(.large)
                .cornerRadius(10)
                .padding()
            Form {
                Section {
                    Picker("Cuenta", selection: $cuentaSeleccionada) {
                        ForEach(numerosDeCuenta, id: \.self) {
                            Text($0)
                        }
                    }
                    .font(.system(size: 22, design: .rounded))

                }
                Section {
                    Picker("Marca", selection: $marcaSelecionado) {
                        ForEach(marca, id: \.self) {
                            Text($0)
                        }
                    }
                    .font(.system(size: 22, design: .rounded))

                }
            }

            Text(mensajeConfirmacion)
                .foregroundColor(.green)
                .font(.system(size: 18))
                .padding()
            
            Button("Generar") {
                generarTarjeta()
            }
            .buttonStyle(GrowingButton())
            .padding(20)
            .font(.largeTitle)
            .foregroundStyle(.red)
        }.onAppear {
            obtenerNumerosDeCuenta()
        }
    }
}

#Preview {
    NuevaTarjetaView()
}
