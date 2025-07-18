id := "st.lynx.plugins.opendeck-akp03.sdPlugin"

package: build-linux build-mac build-win collect zip

prepare: docker-macos

build-linux:
    cargo build --release --target x86_64-unknown-linux-gnu --target-dir target/plugin-linux

build-mac:
    docker run --rm -it -v $(pwd):/io -w /io ghcr.io/rust-cross/cargo-zigbuild:local-1.87.0 cargo zigbuild --release --target universal2-apple-darwin --target-dir target/plugin-mac

build-win:
    cargo build --release --target x86_64-pc-windows-gnu --target-dir target/plugin-win

docker-macos:
    docker build -t ghcr.io/rust-cross/cargo-zigbuild:local-1.87.0 -f Dockerfile.macos-cross .

clean:
    sudo rm -rf target/

collect:
    rm -r build
    mkdir -p build/{{id}}
    cp -r assets build/{{id}}
    cp manifest.json build/{{id}}
    cp target/plugin-linux/x86_64-unknown-linux-gnu/release/opendeck-akp03 build/{{id}}/opendeck-akp03-linux
    cp target/plugin-mac/universal2-apple-darwin/release/opendeck-akp03 build/{{id}}/opendeck-akp03-mac
    cp target/plugin-win/x86_64-pc-windows-gnu/release/opendeck-akp03.exe build/{{id}}/opendeck-akp03-win.exe

[working-directory: "build"]
zip:
    zip -r opendeck-akp03.plugin.zip {{id}}/
