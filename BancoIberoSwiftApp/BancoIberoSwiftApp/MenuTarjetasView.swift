//
//  MenuTarjetasView.swift
//  BancoIberoSwiftApp
//
//  Created by Irving Alejandro Vega Lagunas on 05/11/23.
//

import SwiftUI

struct MenuTarjetasView: View {
    var body: some View {
        VStack{
            Text("Menu Tarjetas")
                .font(.system(size: 36, weight: .heavy, design: .rounded))
                .multilineTextAlignment(.center)
            Image("menu")
                .resizable()
                .scaledToFit()
                .imageScale(.large)
                .cornerRadius(10)
                .padding()
            
            NavigationLink("Estatus Tarjetas", destination: EstatusTarjetaView())
                .font(.largeTitle)
                .tint(.red)
                .padding()
                .buttonStyle(GrowingButton())
                
            NavigationLink("Nueva Tarjeta", destination: NuevaTarjetaView())
                .font(.largeTitle)
                .tint(.red)
                .padding()
                .buttonStyle(GrowingButton())
            
        }
    }
}

#Preview {
    MenuTarjetasView()
}
