//
//  MenuClienteView.swift
//  BancoIberoSwiftApp
//
//  Created by Irving Alejandro Vega Lagunas on 21/10/23.
//

import SwiftUI

struct MenuClienteView: View {
    @State var numeroTarjeta: String = ""

    var body: some View {
        VStack{
            Text("Menu")
                .font(.system(size: 36, weight: .heavy, design: .rounded))
                .multilineTextAlignment(.center)
                .padding(50)
                
            Image("my-account")
                .resizable()
                .scaledToFit()
                .imageScale(.large)
                .cornerRadius(10)
                .padding()
            
            HStack{
                NavigationLink("Saldo", destination: SaldoView(numeroTarjeta:numeroTarjeta))
                    .font(.system(size: 22, weight: .semibold))
                    .tint(.red)
                    .padding()
                    .buttonStyle(GrowingButton())
                
                    
                NavigationLink("Movimientos", destination: MovimientosView(numeroTarjeta:numeroTarjeta))
                    .font(.system(size: 22, weight: .semibold))
                    .tint(.red)
                    .padding()
                    .buttonStyle(GrowingButton())
            }
                
            HStack{
                NavigationLink("Depositar", destination: DepositosView(numeroTarjeta:numeroTarjeta))
                    .font(.system(size: 22, weight: .semibold))
                    .tint(.red)
                    .padding()
                    .buttonStyle(GrowingButton())
                
                NavigationLink("Retirar", destination: RetiroView(numeroTarjeta:numeroTarjeta))
                    .font(.system(size: 22, weight: .semibold))
                    .tint(.red)
                    .padding()
                    .buttonStyle(GrowingButton())
            }
            HStack{
                NavigationLink("Cambair NIP", destination: CambiarNipView(numeroTarjeta:numeroTarjeta))
                    .font(.system(size: 22, weight: .semibold))
                    .tint(.red)
                    .padding()
                    .buttonStyle(GrowingButton())
            }
            NavigationLink("Salir", destination: ContentView())
                .font(.system(size: 22, weight: .semibold))
                .tint(.red)
                .buttonStyle(GrowingButton())
                .navigationBarBackButtonHidden(true)
                .frame(width: 360)
        }
        .navigationBarBackButtonHidden(true) // Oculta el botón de retroceso
    }
}

#Preview {
    MenuClienteView()
}
