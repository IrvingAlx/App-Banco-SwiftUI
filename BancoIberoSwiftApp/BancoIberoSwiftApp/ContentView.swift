//
//  ContentView.swift
//  BancoIberoSwiftApp
//
//  Created by Irving Alejandro Vega Lagunas on 16/10/23.
//

import SwiftUI

struct GrowingButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .background(.red)
            .foregroundStyle(.white)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct ContentView: View {
    var body: some View {
        NavigationView{
            VStack {
                HStack{
                    Image(systemName: "bitcoinsign.circle")
                        .resizable()
                        .frame(width: 56.0, height: 56.0)
                        .imageScale(.large)
                        .foregroundStyle(.red)
                        .padding()
                    Text("Banco Ibero")
                        .font(.system(size: 36, weight: .heavy, design: .rounded))
                        .multilineTextAlignment(.center)
                        .padding()
                    Image(systemName: "bitcoinsign.circle")
                        .resizable()
                        .frame(width: 56.0, height: 56.0)
                        .imageScale(.large)
                        .foregroundStyle(.red)
                        .padding()
                }
                Image("vault1")
                    .resizable()
                    .scaledToFit()
                    .imageScale(.large)
                    .cornerRadius(10)
                    .padding()
                
                NavigationLink("Gestion", destination: GestionView())
                    .font(.largeTitle)
                    .tint(.red)
                    .padding()
                    .buttonStyle(GrowingButton())
                
                NavigationLink("Cajero", destination: IngreseTarjetaView())
                    .font(.largeTitle)
                    .tint(.red)
                    .padding()
                    .buttonStyle(GrowingButton())
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    ContentView()
}
