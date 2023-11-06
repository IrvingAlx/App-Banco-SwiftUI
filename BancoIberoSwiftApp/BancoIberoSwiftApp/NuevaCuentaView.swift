//
//  NuevaCuentaView.swift
//  BancoIberoSwiftApp
//
//  Created by Irving Alejandro Vega Lagunas on 21/10/23.
//

import SwiftUI

struct NuevaCuentaView: View {
    
    @State private var clienteSeleccionado = 10001
    @State private var clientes = [Cliente]()
    @State private var numerosDeClientes = [Int]()
    @State private var tipoSelecionado = "Nomina"
    let tipos = ["Ahorros","Nomina", "Cheches"]
    @State private var monedaSelecionado = "MXN"
    let monedas = ["MXN", "USD", "EUR"]
    @State private var mensajeConfirmacion = ""

    func obtenerClientes() {
        guard let url = URL(string: "http://127.0.0.1:8000/clientes") else {
            return
        }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do {
                    let clientes = try JSONDecoder().decode([Cliente].self, from: data)
                    DispatchQueue.main.async {
                        self.clientes = clientes
                        self.numerosDeClientes = clientes.map { $0.no_cliente }
                    }
                } catch {
                    print("Error al decodificar JSON:", error)
                }
            } else if let error = error {
                print("Error al obtener datos:", error)
            }
        }.resume()
    }
    
    func crearCuentaEnServidor() {
        let requestData: [String: Any] = [
            "cliente_id": clienteSeleccionado,
            "tipo_cuenta": tipoSelecionado,
            "moneda": monedaSelecionado
        ]

        guard let url = URL(string: "http://127.0.0.1:8000/crear_cuenta") else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestData)
        } catch {
            print("Error al crear datos JSON:", error)
            return
        }

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 {
                    // Cuenta creada correctamente
                    mensajeConfirmacion = "Cuenta creada correctamente"

                    print("Cuenta creada correctamente")
                } else {
                    // Error en la respuesta del servidor
                    print("Error en la respuesta del servidor")
                }
            } else if let error = error {
                // Error al obtener datos
                print("Error al obtener datos:", error)
            }
        }.resume()
    }

    
    var body: some View {
        VStack{
            Text("Nueva Cuenta")
                .font(.system(size: 36, weight: .heavy, design: .rounded))
                .multilineTextAlignment(.center)
                .padding(20)
            Image("new-friendship")
                .resizable()
                .scaledToFit()
                .imageScale(.large)
                .cornerRadius(10)
                .padding()
    
            Form {
                Section {
                    Picker("Cliente", selection: $clienteSeleccionado) {
                        ForEach(numerosDeClientes, id: \.self) { numero in
                            Text(String(numero)).tag(numero)
                        }
                    }
                    .font(.system(size: 22, design: .rounded))
                }
                Section {
                    Picker("Tipo", selection: $tipoSelecionado) {
                        ForEach(tipos, id: \.self) {
                            Text($0)
                        }
                    }
                    .font(.system(size: 22, design: .rounded))
                }
                Section {
                    Picker("Moneda", selection: $monedaSelecionado) {
                        ForEach(monedas, id: \.self) {
                            Text($0)
                        }
                    }
                    .font(.system(size: 22, design: .rounded))
                }
            }
            .frame(height: 280)
            .padding(20)
        
            Text(mensajeConfirmacion)
                .foregroundColor(.green)
                .font(.system(size: 18))
                .padding()
            
            Button("Generar") {
                crearCuentaEnServidor()
            }
            .padding(20)
            .font(.largeTitle)
            .foregroundStyle(.red)
            .buttonStyle(GrowingButton())

        }.onAppear {
            obtenerClientes()
        }
    }
}

#Preview {
    NuevaCuentaView()
}
