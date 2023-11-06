//
//  IngreseTarjetaView.swift
//  BancoIberoSwiftApp
//
//  Created by Irving Alejandro Vega Lagunas on 21/10/23.
//

import SwiftUI

struct IngreseTarjetaView: View {
    @State private var noTarjeta: String = ""
    @State private var mensaje: String = ""
    @State private var navigateToIngresarNipView = false
    
    func verificarTarjeta() {
            guard let url = URL(string: "http://127.0.0.1:8000/verificar_tarjeta") else { return }
            
            let parameters: [String: String] = ["numero_tarjeta": noTarjeta]
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
                                mensaje = message
                                if message == "La tarjeta existe y está activa" {
                                    navigateToIngresarNipView = true
                                }
                            }
                        }
                    }
                }
            }.resume()
        }
    
    var body: some View {
        VStack{
            Text("Ingresa Tarjeta")
                .font(.system(size: 36, weight: .heavy, design: .rounded))
                .multilineTextAlignment(.center)
                .padding(50)
                
            Image("credit-card")
                .resizable()
                .scaledToFit()
                .imageScale(.large)
                .cornerRadius(10)
                .padding()
                
            HStack{
                TextField("No Tarjeta", text: $noTarjeta)                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            }
            .padding(20)
                
            Text(mensaje)
                .font(.title)
            
            Button("Aceptar") {
                verificarTarjeta()
            }
            .buttonStyle(GrowingButton())
            .padding(10)
            .font(.largeTitle)
            .foregroundStyle(.red)
                        
                
            Button("Borrar") {
                noTarjeta = ""
            }
            .buttonStyle(GrowingButton())
            .padding(10)
            .font(.largeTitle)
            .foregroundStyle(.red)
            
            if navigateToIngresarNipView {
                NavigationLink("", destination: IngresarNipView(numeroTarjeta: noTarjeta), isActive: $navigateToIngresarNipView)
                .opacity(0)
            }
        }
    }
}

#Preview {
    IngreseTarjetaView()
}
