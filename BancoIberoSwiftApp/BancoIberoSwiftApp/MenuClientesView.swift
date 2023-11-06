//
//  MenuClientesView.swift
//  BancoIberoSwiftApp
//
//  Created by Irving Alejandro Vega Lagunas on 21/10/23.
//

import SwiftUI

struct MenuClientesView: View {
    @State private var nombre : String = ""
    @State private var apellidoPaterno : String = ""
    @State private var apellidoMaterno : String = ""
    @State private var fechaNacimiento = Date()
    @State private var sexoSeleccionado = 0
    @State private var respuesta: String?
    @State private var isResponsePopupPresented = false

    let opciones = ["Hombre","Mujer"]

    var sexo: Character {
        return opciones[sexoSeleccionado] == "Hombre" ? "M" : "F"
    }
    
    var body: some View {
        VStack{
            Text("Menu Clientes")
                .font(.system(size: 36, weight: .heavy, design: .rounded))
                .multilineTextAlignment(.center)
            Image("user")
                .resizable()
                .scaledToFit()
                .imageScale(.large)
                .cornerRadius(10)
            HStack{
                Text("Nombres: ")
                    .font(.title2)
                TextField("Nombre", text: $nombre)
                    .font(.title2)
            }
            .frame(width: 360)
            .padding(20)
            HStack{
                Text("Apellido Paterno: ")
                    .font(.title2)
                TextField("Apellidos", text: $apellidoPaterno)
                    .font(.title2)
            }
            .frame(width: 360)
            .padding(20)
            
            HStack{
                Text("Apellido Materno: ")
                    .font(.title2)
                TextField("Apellidos", text: $apellidoMaterno)
                    .font(.title2)
            }
            .frame(width: 360)
            .padding(20)
            
            Picker(selection: $sexoSeleccionado, label: Text("Seleciona una opcion")){
                ForEach(opciones.indices, id: \.self){
                    Text(self.opciones[$0]).tag($0)
                }
            }
            .frame(width: 360)
            .pickerStyle(SegmentedPickerStyle())
            
            DatePicker("Selecciona una fecha",selection: $fechaNacimiento,displayedComponents: .date)
                .datePickerStyle(CompactDatePickerStyle())
                .padding()
                .frame(width: 360)
            
            
            Button("Nuevo") {
                let nuevoCliente = Cliente(nombre: nombre, apellido_paterno: apellidoPaterno, apellido_materno: apellidoMaterno, fecha_nacimiento: fechaNacimiento, sexo: sexo, cuentas: nil)
                ClienteAPI.guardarClienteEnServidor(nuevoCliente) { respuesta, error in
                    if let respuesta = respuesta {
                        self.respuesta = respuesta
                        self.isResponsePopupPresented = true
                    } else if let error = error {
                        self.respuesta = error.localizedDescription
                        self.isResponsePopupPresented = true
                        print(error.localizedDescription)
                    }
                }
            }
            .frame(width: 360)
            .padding(10)
            .font(.largeTitle)
            .foregroundStyle(.red)
            .buttonStyle(GrowingButton())
            
            HStack{
                NavigationLink("Actualizar", destination: ActualizarClienteView())
                    .font(.title)
                    .tint(.red)
                    .padding()
                    .buttonStyle(GrowingButton())
                
                NavigationLink("Consultar", destination: ConsultarClienteView())
                    .font(.title)
                    .tint(.red)
                    .padding()
                    .buttonStyle(GrowingButton())
            }
            .onAppear {
                // Código que se ejecuta cuando la vista aparece
            }
            .sheet(isPresented: $isResponsePopupPresented) {
                ResponsePopup(message: respuesta ?? "") {
                    self.isResponsePopupPresented = false
                }
            }
        }
    }
}

struct ResponsePopup: View {
    var message: String
    var onClose: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Text("Nuevo Cliente")
                    .font(.title)
                    .padding()

                Button("Cerrar") {
                    onClose()
                }
                .padding()
            }
            .background(Color.white)
            .cornerRadius(10)
            .padding()
        }
    }
}

#Preview {
    MenuClientesView()
}
