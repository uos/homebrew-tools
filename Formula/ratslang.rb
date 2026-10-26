# Maintainer: stelzo <stelzo@steado.de>
# Template file. CI fills in the version and one checksum per downloaded file before publishing to the tap.
class Ratslang < Formula
  desc "Configuration language for building physical systems in Rust: CLI and language server"
  homepage "https://stelzo.codeberg.page/ratslang/"
  version "0.5.0"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    on_arm do
      url "https://codeberg.org/stelzo/ratslang/releases/download/v#{version}/ratslang-aarch64-apple-darwin"
      sha256 "3359ae7b78f40dbff6ae4ba4c7eaceee0be1fd8d3d9b3a25e1f3a2d3707a5361"

      resource "ratslang-lsp" do
        url "https://codeberg.org/stelzo/ratslang/releases/download/v#{version}/ratslang-lsp-aarch64-apple-darwin"
        sha256 "a892c4a72e5cdd5ba02d7df760e720ed21ea079f128de17b8138bad9fa980e3d"
      end
    end
  end

  def install
    bin.install "ratslang-aarch64-apple-darwin" => "ratslang"
    resource("ratslang-lsp").stage { bin.install "ratslang-lsp-aarch64-apple-darwin" => "ratslang-lsp" }
  end

  test do
    system bin/"ratslang", "--version"
    (testpath/"rat.rl").write("rat.mood = CURIOUS\n")
    system bin/"ratslang", "check", testpath/"rat.rl"
  end
end
