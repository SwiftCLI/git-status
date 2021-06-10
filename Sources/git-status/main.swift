import ArgumentParser
import OpenCombineShim
import Foundation
import SwiftyTextTable

enum GitProvider: EnumerableFlag {
    case bitbucket
    
    static func name(for value: GitProvider) -> NameSpecification {
        .shortAndLong
    }
    
    static func help(for value: GitProvider) -> ArgumentHelp? {
        ArgumentHelp(stringLiteral: "Support: bitbucket. Default is: bitbucket")
    }
}

@available(macOS 10.15, *)
struct GitStatus: ParsableCommand {
    @Flag
    var provider: GitProvider = .bitbucket
    
    mutating func run() throws {
        switch provider {
        case .bitbucket:
            let viewModel = BitbucketViewModel.init()
            viewModel
                .$response
                .sink { response in
                    guard let response = response else { return }
                    print("\(response.status.indicator) \(response.status.description)")
                    print(response.components.renderTextTable())
                    GitStatus.exit(withError: nil)
                }
                .store(in: &viewModel.disposeBag)
            
            viewModel.$error
                .dropFirst()
                .sink { error in
                    if let error = error {
                        print("ERROR: \(error.localizedDescription)")
                    }
                    GitStatus.exit(withError: error)
                }
                .store(in: &viewModel.disposeBag)
            
            viewModel.loadData = ()
        }
    }
}

if #available(macOS 10.15, *) {
    GitStatus.main()
    dispatchMain()
} else {
    print("Sorry, we're supporting macOS 10.15 & above!")
}
