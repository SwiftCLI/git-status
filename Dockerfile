FROM swiftarm/swift:5.4.1-debian-10
COPY . app
RUN cd app && swift build -c release && cp ./.build/release/git-status /usr/local/bin/git-status