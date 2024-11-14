//
//  SearchViewModelTests.swift
//  PruebaLiverpoolTests
//
//  Created by MacBook Pro 2015 on 14/11/24.
//

import XCTest
@testable import PruebaLiverpool

class SearchViewModelTests: XCTestCase {
    
    var viewModel: SearchViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = SearchViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
//Prueba para ver que la URL se arme bien
    func testURLConstruction() {
        viewModel.searchTerm = "Playera"
        viewModel.sortOption = .lowestPrice
        
        let expectedURLString = "https://shoppapp.liverpool.com.mx/appclienteservices/services/v8/plp/sf?page-number=1&search-string=Playera&sort-option=sortPrice|0&force-plp=false&number-of-items-per-page=40&cleanProductName=false"
        let encodedSearchTerm = viewModel.searchTerm.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let actualURLString = "https://shoppapp.liverpool.com.mx/appclienteservices/services/v8/plp/sf?page-number=1&search-string=\(encodedSearchTerm)&sort-option=\(viewModel.sortOption.rawValue)&force-plp=false&number-of-items-per-page=40&cleanProductName=false"
        
        XCTAssertEqual(expectedURLString, actualURLString, "La URL construida no es la esperada.")
    }
    

    
    // Prueba para ver que se cvarguen los productos
    func testFetchProducts() {

        let expectation = self.expectation(description: "Carga de productos")
        
        viewModel.searchTerm = "Playera"
        viewModel.sortOption = .relevance
        
        // Simular datos de productos
        let json = """
        {
            "plpResults": {
                "records": [
                    {
                        "productId": "12345",
                        "productDisplayName": "Playera de ejemplo",
                        "listPrice": 499.0,
                        "promoPrice": 399.0,
                        "smImage": "https://example.com/image.jpg",
                        "variantsColor": [{"colorName": "Rojo"}]
                    }
                ]
            }
        }
        """.data(using: .utf8)!
        
        // Prueba de URLSession
        let url = URL(string: "https://shoppapp.liverpool.com.mx/appclienteservices/services/v8/plp/sf?page-number=1&search-string=Playera&sort-option=Relevancia|0&force-plp=false&number-of-items-per-page=40&cleanProductName=false")!
        let urlResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        
        URLProtocolMock.testURLs = [url: (data: json, response: urlResponse, error: nil)]
        URLProtocol.registerClass(URLProtocolMock.self)
        
        viewModel.fetchProducts()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(self.viewModel.products.count, 1)
            XCTAssertEqual(self.viewModel.products.first?.productDisplayName, "Playera de ejemplo")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2)
        URLProtocol.unregisterClass(URLProtocolMock.self)
    }
}

