//
//  ActualizarClienteView.swift
//  BancoIberoSwiftApp
//
//  Created by Irving Alejandro Vega Lagunas on 22/10/23.
//

import SwiftUI
import Network

struct ActualizarClienteView: View {

    @State private var nombre: String = ""
    @State private var apellidoPaterno: String = ""
    @State private var apellidoMaterno: String = ""
    @State private var fechaNacimiento = Date()
    @State private var sexoSeleccionado = 0
    @State private var clienteSeleccionado = 10001
    @State private var clientes = [Cliente]()
    @State private var numerosDeClientes = [Int]()

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

    
    func actualizarClienteEnServidor(fechaNacimiento: Date) {
        let cliente = Cliente(no_cliente: clienteSeleccionado, nombre: nombre, apellido_paterno: apellidoPaterno, apellido_materno: apellidoMaterno, fecha_nacimiento: fechaNacimiento, sexo: sexo, cuentas: nil)

        // Print the data before sending it to the server
        print("Updating Client Data:")
        print("Nombre: \(cliente.nombre)")
        print("Apellido Paterno: \(cliente.apellido_paterno)")
        print("Apellido Materno: \(cliente.apellido_materno ?? "")")
        print("Fecha de Nacimiento: \(cliente.fecha_nacimiento)")
        print("Sexo: \(cliente.sexo)")
        
        ClienteAPI.actualizarClienteEnServidor(cliente) { respuesta, error in
            if let respuesta = respuesta {
                print("Cliente actualizado en el servidor: \(respuesta)")
                // Handle the server response, e.g., show a success alert.
            } else if let error = error {
                print("Error al actualizar cliente: \(error.localizedDescription)")
                // Handle the error, e.g., show an error alert.
            }
        }
    }



    var body: some View {
        VStack {
            Text("Actualizar Cliente")
                .font(.system(size: 36, weight: .heavy, design: .rounded))
                .multilineTextAlignment(.center)
                .padding(20)
            Image("new-transaction")
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
            
            HStack {
                Text("Nombres: ")
                    .font(.title2)
                TextField("\(nombre)", text: $nombre)
                    .font(.title2)
            }
            .padding(20)
            HStack {
                Text("Apellido Paterno: ")
                    .font(.title2)
                TextField("\(apellidoPaterno)", text: $apellidoPaterno)
                    .font(.title2)
            }
            .padding(20)

            HStack {
                Text("Apellido Materno: ")
                    .font(.title2)
                TextField("\(apellidoMaterno)", text: $apellidoMaterno)
                    .font(.title2)
            }
            .padding(20)

            Picker(selection: $sexoSeleccionado, label: Text("Selecciona una opcion")) {
                ForEach(opciones.indices, id: \.self) {
                    Text(self.opciones[$0]).tag($0)
                }
            }
            .pickerStyle(SegmentedPickerStyle())

            DatePicker("Selecciona una fecha", selection: $fechaNacimiento, displayedComponents: .date)
                .datePickerStyle(CompactDatePickerStyle())
                .padding()

            Button("Actualizar") {
                actualizarClienteEnServidor(fechaNacimiento: fechaNacimiento)
            }
            .font(.largeTitle)
            .tint(.red)
            .padding()
            .buttonStyle(GrowingButton())
        }
        .onAppear {
            obtenerClientes()
        }
        .onChange(of: clienteSeleccionado) { selectedCliente in
            obtenerInformacionCliente(cliente: selectedCliente)
        }
    }
}

