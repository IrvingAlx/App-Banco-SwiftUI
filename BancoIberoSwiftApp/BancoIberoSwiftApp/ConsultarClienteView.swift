//
//  ConsultarClienteView.swift
//  BancoIberoSwiftApp
//
//  Created by Irving Alejandro Vega Lagunas on 22/10/23.
//

import SwiftUI

struct ConsultarClienteView: View {
    @State private var nombre: String = ""
    @State private var apellidoPaterno: String = ""
    @State private var apellidoMaterno: String = ""
    @State private var fechaNacimiento = Date()
    @State private var sexoSeleccionado = 0
    @State private var clienteSeleccionado = 10001
    @State private var clientes = [Cliente]()
    @State private var numerosDeClientes = [Int]()
    @State private var cuentasInfo: String = ""

    let opciones = ["Hombre", "Mujer"]

    var sexo: Character {
        return opciones[sexoSeleccionado] == "Hombre" ? "M" : "F"
    }


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

    func obtenerInformacionCliente(cliente: Int) {
        print("Entre a buscar cliente \(cliente)")
        if let clienteEncontrado = clientes.first(where: { $0.no_cliente == cliente }) {
            self.nombre = clienteEncontrado.nombre
            self.apellidoPaterno = clienteEncontrado.apellido_paterno
            self.apellidoMaterno = clienteEncontrado.apellido_materno ?? ""
            self.fechaNacimiento = clienteEncontrado.fecha_nacimiento!
            self.sexoSeleccionado = clienteEncontrado.sexo == "M" ? 0 : 1
        }
    }
    
    func obtenerDatosDelCliente() {
        guard let url = URL(string: "http://127.0.0.1:8000/cliente_datos/\(clienteSeleccionado)") else {
            print("URL no válida")
            return
        }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let nombre = json["nombre"] as? String,
                       let apellidoPaterno = json["apellido_paterno"] as? String,
                       let apellidoMaterno = json["apellido_materno"] as? String,
                       let cuentas = json["cuentas"] as? [String] {
                        DispatchQueue.main.async {
                            // Aquí puedes imprimir o mostrar en la interfaz la información que deseas
                            let nombreCompleto = "\(nombre) \(apellidoPaterno) \(apellidoMaterno)"
                            let cuentasText = cuentas.joined(separator: ", ")

                            // Asigna los valores a las variables de estado
                            self.nombre = nombreCompleto
                            self.apellidoPaterno = apellidoPaterno
                            self.apellidoMaterno = apellidoMaterno
                            self.cuentasInfo = cuentasText

                            // Imprime la información en la consola
                            print("Nombre: \(nombreCompleto)")
                            print("Números de cuenta: \(cuentasText)")
                        }
                    } else {
                        print("No se encontró la información necesaria en el JSON.")
                    }
                } else {
                    print("No se pudo decodificar el JSON.")
                }
            } else if let error = error {
                print("Error al obtener datos:", error)
            }
        }.resume()
    }


    
    var body: some View {
        VStack{
            Text("Consultar Cliente")
                .font(.system(size: 36, weight: .heavy, design: .rounded))
                .multilineTextAlignment(.center)
                .padding(20)
            Image("query")
                .resizable()
                .scaledToFit()
                .imageScale(.large)
                .cornerRadius(10)
                .padding()
    
            Form {
                Picker("Cliente", selection: $clienteSeleccionado) {
                    ForEach(numerosDeClientes, id: \.self) { numero in
                        Text(String(numero)).tag(numero)
                    }
                }
                .font(.system(size: 22, design: .rounded))
            }
            .frame(height: 100)
            
            List {
                Text("Nombre: \(nombre)")
                    .font(.title)
                
                if !cuentasInfo.isEmpty {
                    Text("No Cuenta: \(cuentasInfo)")
                        .font(.title)
                } else {
                    Text("No Cuenta: No hay cuentas disponibles") // Muestra un mensaje si no hay cuentas
                        .font(.title)
                }
            }
        }
        .onAppear {
            obtenerClientes()
        }
        .onChange(of: clienteSeleccionado) { selectedCliente in
            obtenerDatosDelCliente()
        }

    }
}

#Preview {
    ConsultarClienteView()
}
