//
//  SearchView.swift
//  PruebaLiverpool
//
//  Created by MacBook Pro 2015 on 14/11/24.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    
    var body: some View {
        ZStack{
            Color.gray.ignoresSafeArea().opacity(0.3)
            VStack {
                Text("¡Hola! ¿Que vamos a buscar hoy?").font(.title2).padding()
                TextField("Introduce el nombre del producto", text: $viewModel.searchTerm)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Picker("Ordenar por", selection: $viewModel.sortOption) {
                    ForEach(SortOption.allCases, id: \.self) { option in
                        Text(option.displayName).tag(option)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding().padding(.top,1)
                
                
                Button(action: {
                    viewModel.fetchProducts()
                }) {
                    Text("Buscar")
                        .frame(width: 120,height: 12)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.purple)
                        .cornerRadius(8)
                }
                
                List(viewModel.products) { product in
                    ProductRowView(product: product)
                }
            }
            .padding()
            
        }

    }
}


struct ProductRowView: View {
    let product: Product
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: product.smImage)) { image in
                image.resizable().scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 50, height: 50)
            
            VStack(alignment: .leading) {
                Text(product.productDisplayName)
                    .font(.headline)
                
                Text(product.displayPrice)
                    .foregroundColor(product.displayColor == "red" ? .red : .black)
                
                HStack {
                    ForEach(product.variantsColor, id: \.colorName) { color in
                        Circle()
                            .fill(Color.gray)
                            .frame(width: 10, height: 10)
                    }
                }
            }
        }
    }
}

