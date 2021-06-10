//
//  File.swift
//  
//
//  Created by Steve Dao on 10/6/21.
//

import Foundation
import Alamofire
import OpenCombineShim
import OpenCombineFoundation
import OpenCombineDispatch

@available(macOS 10.15, *)
class BitbucketViewModel {
    // MARK: - Input
    @OpenCombineShim.Published
    var loadData: Void?
    
    // MARK: - Output
    @OpenCombineShim.Published
    var response: BitbucketResponse?
    
    @OpenCombineShim.Published
    var error: Error?
    
    var disposeBag = Set<OpenCombineShim.AnyCancellable>()
    init() {
        $loadData
            .flatMap(maxPublishers: .max(1)) { _ in URLSession.shared.dataTaskPublisher(for: try! BitbucketAPIRouter().asURLRequest())
                .retry(3)
                .tryMap() { element -> Data in
                    guard let httpResponse = element.response as? HTTPURLResponse,
                        httpResponse.statusCode == 200 else {
                            throw URLError(.badServerResponse)
                        }
                    return element.data
                    }
                .decode(type: BitbucketResponse.self, decoder: JSONDecoder())
                .catch { [weak self] error -> OpenCombineShim.Empty<BitbucketResponse, Never> in
                    self?.error = error
                    return OpenCombineShim.Empty.init(completeImmediately: true)
                    
                }
            }
            .eraseToAnyPublisher()
            .sink { [weak self] response in
                self?.response = response
            }
            .store(in: &disposeBag)
    }
}
