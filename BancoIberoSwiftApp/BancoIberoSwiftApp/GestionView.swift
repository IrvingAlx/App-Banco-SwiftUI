//
//  GestionView.swift
//  BancoIberoSwiftApp
//
//  Created by Irving Alejandro Vega Lagunas on 19/10/23.
//

import SwiftUI

struct GestionView: View {
    var body: some View {
        VStack{
            Text("Gestion Banco-IBERO")
                .font(.system(size: 36, weight: .heavy, design: .rounded))
                .multilineTextAlignment(.center)
                .padding(10)
            Image("data-management")
                .resizable()
                .scaledToFit()
                .imageScale(.large)
                .cornerRadius(10)
                .padding()
                
            NavigationLink("Clientes", destination: MenuClientesView())
                .font(.largeTitle)
                .tint(.red)
                .padding()
                .buttonStyle(GrowingButton())
            
            NavigationLink("Cuentas", destination: NuevaCuentaView())
                .font(.largeTitle)
                .tint(.red)
                .padding()
                .buttonStyle(GrowingButton())
                
            NavigationLink("Tarjetas", destination: MenuTarjetasView())
                .font(.largeTitle)
                .tint(.red)
                .padding()
                .buttonStyle(GrowingButton())
            
        }
    }
}

#Preview {
    GestionView()
}
