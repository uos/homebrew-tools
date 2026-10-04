# Maintainer: stelzo <stelzo@steado.de>
# Template file. CI fills in the version and one checksum per downloaded file before publishing to the tap.
class Minot < Formula
  desc "A versatile toolset for debugging and verifying stateful robot perception software"
  homepage "https://codeberg.org/stelzo/minot"
  version "0.13.0"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    on_arm do
      url "https://codeberg.org/stelzo/minot/releases/download/v#{version}/minot-aarch64-apple-darwin"
      sha256 "ded26d1e375d127cf71bdc12d24765a75418226790ca178a9b8ef3db12ad9d30"

      resource "librat.a" do
        url "https://codeberg.org/stelzo/minot/releases/download/v#{version}/librat-aarch64-apple-darwin.a"
        sha256 "38720170b99a67514713ec5da516ae3b7671d350e7771010030d507c8483d77a"
      end

      resource "librat.dylib" do
        url "https://codeberg.org/stelzo/minot/releases/download/v#{version}/librat-aarch64-apple-darwin.dylib"
        sha256 "b7e4231d6ec30a801dbd0a62ea9cdca60a383f1ced01c02f2ed421a990b7b541"
      end
    end
  end

  resource "rat.h" do
    url "https://codeberg.org/stelzo/minot/releases/download/v#{version}/rat.h"
    sha256 "388bbf73819fe6ff37b196484746f216482cdb898dc1223cc8a548530c29b2f7"
  end

  resource "librat.pc" do
    url "https://codeberg.org/stelzo/minot/releases/download/v#{version}/librat.pc"
    sha256 "7285504d682381881e0bc69eacf6286015fe95c7413d653bbd46152e4bfbbd68"
  end

  resource "libratConfig.cmake" do
    url "https://codeberg.org/stelzo/minot/releases/download/v#{version}/libratConfig.cmake"
    sha256 "5f43f062c9b349da2a5cb22a48b43a27923a5eb71e0380715c4379475e29c309"
  end

  def install
    bin.install "minot-aarch64-apple-darwin" => "minot"

    resource("librat.a").stage { lib.install "librat-aarch64-apple-darwin.a" => "librat.a" }
    resource("librat.dylib").stage { lib.install "librat-aarch64-apple-darwin.dylib" => "librat.dylib" }
    resource("rat.h").stage { (include/"rat").install "rat.h" }
    resource("librat.pc").stage do
      inreplace "librat.pc", "prefix=/usr", "prefix=#{prefix}"
      (lib/"pkgconfig").install "librat.pc"
    end
    resource("libratConfig.cmake").stage { (lib/"cmake/minot").install "libratConfig.cmake" }

    # Fix install name for dylib to use @rpath
    system "install_name_tool", "-id", "@rpath/librat.dylib", lib/"librat.dylib"

    generate_completions_from_executable(bin/"minot", "completions")
  end

  test do
    system "#{bin}/minot", "--version"
    system "#{bin}/minot", "coord", "--help"
  end
end
