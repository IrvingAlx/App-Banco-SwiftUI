//
//  DepositosView.swift
//  BancoIberoSwiftApp
//
//  Created by Irving Alejandro Vega Lagunas on 21/10/23.
//

import SwiftUI

struct DepositosView: View {
    @State var numeroTarjeta: String = ""
    @State var monto: String = ""
    @State var descripcion: String = ""
    @State private var mensaje: String = ""

    func realizarDeposito() {
            guard let url = URL(string: "http://127.0.0.1:8000/depositar") else { return }

            let parameters: [String: Any] = [
                "numero_tarjeta": numeroTarjeta,  // Enviando el número de tarjeta
                "monto": Double(monto) ?? 0,  // Convierte a un valor numérico
                "motivo": descripcion
            ]

            guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters) else {
                mensaje = "Error en la solicitud"
                return
            }

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
                            }
                        } else if let error = json["error"] as? String {
                            DispatchQueue.main.async {
                                mensaje = error
                            }
                        }
                    }
                }
            }.resume()
        }
    
    var body: some View {
        VStack{
            Text("Depositar")
                .font(.system(size: 36, weight: .heavy, design: .rounded))
                .multilineTextAlignment(.center)
                .padding(20)

            Image("deposito")
                .resizable()
                .scaledToFit()
                .imageScale(.large)
                .cornerRadius(10)
                .padding()
            HStack{
                Button("$ 100") {
                    monto = "100"
                }
                .buttonStyle(GrowingButton())
                .padding(5)
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(.red)
                
                
                Button("$ 200") {
                    monto = "200"
                }
                .buttonStyle(GrowingButton())
                .padding(5)
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(.red)
            }
            .frame(width: 330)
            
            HStack{
                Button("$500") {
                    monto = "500"
                }
                .buttonStyle(GrowingButton())
                .padding(5)
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(.red)
                
                
                Button("$1000") {
                    monto = "1000"
                }
                .buttonStyle(GrowingButton())
                .padding(5)
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(.red)
            }
            .frame(width: 330)
            HStack{
                Text("Cantida: ")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                TextField("Ingrese cantidad", text: $monto)
                    .font(.system(size: 20, weight: .semibold))
            }
            .frame(width: 330)
            .padding(20)
            
            HStack{
                Text("Descripcion: ")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                TextField("Ingrese Descripcion", text: $descripcion)
                    .font(.system(size: 20, weight: .semibold))
            }
            .frame(width: 330)
            
            Button("Aceptar") {
                realizarDeposito()
            }
            .frame(width: 330)
            .buttonStyle(GrowingButton())
            .padding(10)
            .font(.system(size: 22, weight: .semibold))
            .foregroundStyle(.red)

            Text("\(mensaje)")

        }
    }
}

#Preview {
    DepositosView()
}
