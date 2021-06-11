FROM swiftarm/swift
COPY . app
RUN cd app && swift build -c release && cp ./.build/release/git-status /usr/local/bin/git-status