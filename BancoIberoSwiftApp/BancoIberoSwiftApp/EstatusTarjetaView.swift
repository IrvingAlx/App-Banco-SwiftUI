//
//  EstatusTarjetaView.swift
//  BancoIberoSwiftApp
//
//  Created by Irving Alejandro Vega Lagunas on 05/11/23.
//

import SwiftUI

struct EstatusTarjetaView: View {
    @State private var tarjetaHabilitada = false
    @State private var tarjetaSeleccionada = "90004"  // Cambiar a String
    @State private var numerosDeTarjeta = [String]()  // Cambiar a [String]

    func verificarEstadoTarjeta(numero: String) {
            guard let url = URL(string: "http://127.0.0.1:8000/estado_tarjeta") else {
                print("URL inválida")
                return
            }

            let parameters = ["numero_tarjeta": numero]
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
            } catch {
                print("Error al crear el cuerpo de la solicitud")
                return
            }

            URLSession.shared.dataTask(with: request) { data, _, _ in
                if let data = data {
                    if let estado = try? JSONDecoder().decode([String: String].self, from: data) {
                        DispatchQueue.main.async {
                            if let mensaje = estado["message"], mensaje == "La tarjeta está habilitada" {
                                self.tarjetaHabilitada = true
                            } else {
                                self.tarjetaHabilitada = false
                            }
                        }
                    }
                }
            }.resume()
        }
    
    
    func cargarNumerosDeTarjeta() {
        guard let url = URL(string: "http://127.0.0.1:8000/numeros_de_tarjeta") else {
            print("URL inválida")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                if let numeros = try? JSONDecoder().decode([String].self, from: data) { // Cambiar a [String]
                    DispatchQueue.main.async {
                        self.numerosDeTarjeta = numeros
                        // Imprime los números de tarjeta en la terminal
                        //print("Números de tarjeta recibidos:", numeros)
                    }
                } else {
                    // No se pudieron decodificar los datos JSON
                    print("Error al decodificar JSON")
                }
            } else if let error = error {
                // Ocurrió un error durante la solicitud
                print("Error al obtener datos:", error)
            }
        }.resume()
    }

    func cambiarEstadoTarjeta(numero: String) {
        guard let url = URL(string: "http://127.0.0.1:8000/cambiar_estado_tarjeta") else {
            print("URL inválida")
            return
        }

        let parameters = ["numero_tarjeta": numero]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        } catch {
            print("Error al crear el cuerpo de la solicitud")
            return
        }

        URLSession.shared.dataTask(with: request) { data, _, _ in
            if let data = data {
                if let estado = try? JSONDecoder().decode([String: String].self, from: data) {
                    DispatchQueue.main.async {
                        if let mensaje = estado["message"] {
                            if mensaje == "Tarjeta cambiada a estado activado" || mensaje == "Tarjeta cambiada a estado desactivado" {
                                self.tarjetaHabilitada = mensaje == "Tarjeta cambiada a estado activado"
                                print("Tarjeta " + (self.tarjetaHabilitada ? "activada" : "desactivada"))
                            }
                        }
                    }
                }
            }
        }.resume()
    }

    
    var body: some View {
        VStack {
            Text("Estatus Tarjetas")
                .font(.system(size: 36, weight: .heavy, design: .rounded))
                .multilineTextAlignment(.center)
            Image("payment-status")
                .resizable()
                .scaledToFit()
                .imageScale(.large)
                .cornerRadius(10)
            Form {
                Picker("Tarjeta", selection: $tarjetaSeleccionada) {
                    ForEach(numerosDeTarjeta, id: \.self) { numero in
                        Text(numero).tag(numero)
                    }
                }
                .font(.system(size: 22, design: .rounded))
            }
            .frame(height: 100)
            
            Toggle("Habilitar Tarjeta", isOn: $tarjetaHabilitada)
                    .font(.title)
                    .padding(10)

            Button("Actualizar") {
                cambiarEstadoTarjeta(numero: tarjetaSeleccionada)
            }
            .font(.largeTitle)
            .tint(.red)
            .padding()
            .buttonStyle(GrowingButton())
            
            // Agregar un Text para mostrar el estado de la tarjeta
            Text("La tarjeta está \(tarjetaHabilitada ? "habilitada" : "deshabilitada")")
                .font(.title)
        }
        .onAppear {
            cargarNumerosDeTarjeta()
        }
        .onChange(of: tarjetaSeleccionada) { selectedTarjeta in
            cambiarEstadoTarjeta(numero: selectedTarjeta)
        }
    }
}

#Preview {
    EstatusTarjetaView()
}
