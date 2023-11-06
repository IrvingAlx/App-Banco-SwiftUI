//
//  IngresarNipView.swift
//  BancoIberoSwiftApp
//
//  Created by Irving Alejandro Vega Lagunas on 21/10/23.
//

import SwiftUI

struct IngresarNipView: View {
    @State var numeroTarjeta: String = ""
    @State var nip: String = ""
    @State private var navigateToMenuClienteView = false
    @State private var intentosFallidos = 0
    @State private var tarjetaBloqueada = false

    func bloquearTarjeta() {
        guard let url = URL(string: "http://127.0.0.1:8000/bloquear_tarjeta") else { return }
            
        let parameters: [String: String] = ["numero_tarjeta": numeroTarjeta]
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
            
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let message = json["message"] as? String {
                        DispatchQueue.main.async {
                            print("Mensaje del servidor: \(message)")
                            tarjetaBloqueada = true // Marcar la tarjeta como bloqueada
                        }
                    }
                }
            }
        }.resume()
    }
    
    func verificarTarjetaNIP() {
        guard let url = URL(string: "http://127.0.0.1:8000/verificar_tarjeta_nip") else { return }
        
        let parameters: [String: String] = ["numero_tarjeta": numeroTarjeta, "nip": nip]
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let message = json["message"] as? String {
                        DispatchQueue.main.async {
                            if message == "Tarjeta y NIP válidos" {
                                navigateToMenuClienteView = true
                            } else {
                                intentosFallidos += 1
                                print("Intentos fallidos: \(intentosFallidos)")
                                
                                if intentosFallidos == 5 {
                                    // Llama a la función para bloquear la tarjeta
                                    bloquearTarjeta()
                                }
                            }
                            print("Mensaje del servidor: \(message)")
                        }
                    }
                }
            }
        }.resume()
    }

    
    var body: some View {
        VStack {
            Text("Ingresa NIP")
                .font(.system(size: 36, weight: .heavy, design: .rounded))
                .multilineTextAlignment(.center)
                .padding(50)
                
            Image("padlock")
                .resizable()
                .scaledToFit()
                .imageScale(.large)
                .cornerRadius(10)
                .padding()
                
            Text("\(numeroTarjeta)")
            
            if tarjetaBloqueada {
                Text("Tarjeta bloqueada")
                    .font(.title)
                    .foregroundColor(.red)
            } else {
                HStack {
                    TextField("NIP Tarjeta", text: $nip)
                        .font(.title)
                }
                .padding(20)
            }
            
            Text("Intentos fallidos: \(intentosFallidos)")
            
            Button("Aceptar") {
                verificarTarjetaNIP()
            }
            .buttonStyle(GrowingButton())
            .padding(21)
            .font(.largeTitle)
            .foregroundStyle(.red)
            
            NavigationLink("Cancelar", destination: ContentView())
                .font(.largeTitle)
                .tint(.red)
                .padding()
                .buttonStyle(GrowingButton())
                .navigationBarBackButtonHidden(true) // Oculta el botón de retroceso
            
            if navigateToMenuClienteView {
                NavigationLink("", destination: MenuClienteView(numeroTarjeta: numeroTarjeta), isActive: $navigateToMenuClienteView)
                .opacity(0)
            }
        }
    }
}
