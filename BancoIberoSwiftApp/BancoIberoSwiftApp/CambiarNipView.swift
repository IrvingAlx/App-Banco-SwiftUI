//
//  CambiarNipView.swift
//  BancoIberoSwiftApp
//
//  Created by Irving Alejandro Vega Lagunas on 21/10/23.
//

import SwiftUI

struct CambiarNipView: View {
    @State var numeroTarjeta: String = ""
    @State var nipActual: String = ""
    @State var nipNuevo: String = ""
    @State var nipConfirmar: String = ""
    @State var mensajeError: String = ""
    @State var mensajeExito: String = ""

    func cambiarNIP() {
            if nipNuevo == nipConfirmar {
                let url = URL(string: "http://127.0.0.1:8000/cambiar_nip")! // Reemplaza con la URL correcta
                let bodyData: [String: String] = [
                    "numero_tarjeta": numeroTarjeta,
                    "nip_anterior": nipActual,
                    "nip_nuevo": nipNuevo
                ]

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
                        mensajeError = "Error al cambiar el NIP."
                    }

                    if let data = data {
                        if let response = try? JSONDecoder().decode([String: String].self, from: data) {
                            if let message = response["message"] {
                                // NIP cambiado con éxito
                                mensajeExito = "NIP cambiado con éxito: \(message)"
                            } else if let error = response["error"] {
                                // Error al cambiar el NIP
                                mensajeError = "Error al cambiar el NIP: \(error)"
                            }
                        }
                    } else {
                        print("No se recibieron datos en la respuesta.")
                    }
                }.resume()
            } else {
                // Mostrar un mensaje de error si los NIP no coinciden
                mensajeError = "Los NIP no coinciden, asegúrate de que sean iguales."
            }
        }
    
    var body: some View {
        VStack{
            Text("Cambiar NIP")
                .font(.system(size: 36, weight: .heavy, design: .rounded))
                .multilineTextAlignment(.center)

            Image("reset-password")
                .resizable()
                .scaledToFit()
                .imageScale(.large)
                .cornerRadius(10)
                .padding()
            
            HStack{
                Text("NIP Actual: ")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                TextField("NIP Actual", text: $nipActual)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            }
            .padding(10)
            .frame(width: 360)
            
            HStack{
                Text("Nuevo NIP: ")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                TextField("Nuevo NIP", text: $nipNuevo)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            }
            .padding(10)
            .frame(width: 360)
            HStack{
                Text("Confirmar:  ")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                TextField("NIP Confirmar", text: $nipConfirmar)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            }
            .padding(10)
            .frame(width: 360)
            
            if !mensajeError.isEmpty {
                Text(mensajeError)
                    .foregroundColor(.red)
            }
                        
            if !mensajeExito.isEmpty {
                Text(mensajeExito)
                    .foregroundColor(.green)
            }
            
            Button("Aceptar") {
                cambiarNIP()
            }
            .buttonStyle(GrowingButton())
            .padding(5)
            .font(.system(size: 22, weight: .semibold))
            .foregroundStyle(.red)
            .frame(width: 360)
            
        }
    }
}

#Preview {
    CambiarNipView()
}
