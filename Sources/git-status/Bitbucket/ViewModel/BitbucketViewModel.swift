//
//  File.swift
//  
//
//  Created by Steve Dao on 10/6/21.
//

import Foundation
import OpenCombineShim
import OpenCombineFoundation
import OpenCombineDispatch

@available(macOS 10.15, *)
class BitbucketViewModel {
    // MARK: - Input
    @Published
    var loadData: Void?
    
    // MARK: - Output
    @Published
    var response: BitbucketResponse?
    
    @Published
    var error: Error?
    
    var disposeBag = Set<OpenCombineShim.AnyCancellable>()
    
    init() {
        $loadData
            .sink { [weak self] _ in
                do {
                    let data = try Data(contentsOf: URL(string: Constants.bitbucketURL)!)
                    let response = try JSONDecoder().decode(BitbucketResponse.self, from: data)
                    
                    self?.response = response
                } catch {
                    self?.error = error
                }
            }
            .store(in: &disposeBag)
    }
}
