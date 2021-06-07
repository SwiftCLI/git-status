import ArgumentParser

struct BucketStatus: ParsableCommand {
    mutating func run() throws {
        print("hello world")
    }
}

BucketStatus.main()
