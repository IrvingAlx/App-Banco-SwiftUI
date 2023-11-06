//
//  SaldoView.swift
//  BancoIberoSwiftApp
//
//  Created by Irving Alejandro Vega Lagunas on 21/10/23.
//

import SwiftUI

struct SaldoView: View {
    @State var numeroTarjeta: String = ""
    @State private var saldo: String = "Cargando saldo..." // Inicialmente muestra un mensaje de carga

    func consultarSaldo() {
        guard let url = URL(string: "http://127.0.0.1:8000/consultar_saldo") else { return }

        let parameters: [String: String] = ["numero_tarjeta": numeroTarjeta]
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters)

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let saldo = json["saldo"] as? String {
                        DispatchQueue.main.async {
                            self.saldo = "Saldo actual: $" + saldo
                            // Imprimir el saldo en la terminal
                            print("Saldo recibido:", saldo)
                        }
                    }
                }
            }
        }.resume()
    }



    var body: some View {
        VStack{
            Text("\(numeroTarjeta)")
            Text("Saldo")
                .font(.system(size: 36, weight: .heavy, design: .rounded))
                .multilineTextAlignment(.center)
                .padding(50)

            Image("wallet")
                .resizable()
                .scaledToFit()
                .imageScale(.large)
                .cornerRadius(10)
                .padding()
            
            HStack{
                Text("\(saldo)")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            }
            .padding(20)
        
        }
        .onAppear {
            // Cuando la vista aparece, consulta el saldo
            consultarSaldo()
        }
    }
}

#Preview {
    SaldoView()
}
