//
//  SearchViewModel.swift
//  PruebaLiverpool
//
//  Created by MacBook Pro 2015 on 14/11/24.
//

import Combine
import Foundation

class SearchViewModel: ObservableObject {
    @Published var products = [Product]()
    @Published var searchTerm: String = ""
    @Published var sortOption: SortOption = .predefined
    
    private var cancellables = Set<AnyCancellable>()
    
    func fetchProducts() {

        guard let encodedSearchTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            print("Invalid search term")
            return
        }
        

        let urlString = "https://shoppapp.liverpool.com.mx/appclienteservices/services/v8/plp/sf?page-number=1&search-string=\(encodedSearchTerm)&sort-option=\(sortOption.rawValue)&force-plp=false&number-of-items-per-page=40&cleanProductName=false"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            return
        }
        
        print("Fetching products for URL: \(url)")
        
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .decode(type: ProductResponse.self, decoder: JSONDecoder())
            .map { $0.plpResults.records }
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink { [weak self] products in
                self?.products = products
                print("Fetched \(products.count) products")
            }
            .store(in: &cancellables)
    }
}




