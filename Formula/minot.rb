# Maintainer: stelzo <stelzo@steado.de>
# Template file. CI fills in the version and one checksum per downloaded file before publishing to the tap.
class Minot < Formula
  desc "A versatile toolset for debugging and verifying stateful robot perception software"
  homepage "https://minot.steado.tech"
  version "0.14.1"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    on_arm do
      url "https://codeberg.org/stelzo/minot/releases/download/v#{version}/minot-aarch64-apple-darwin"
      sha256 "c20c04104767f704c7dd121223b44bd5670a891002792994e295de7dc5ce6a74"

      resource "librat.a" do
        url "https://codeberg.org/stelzo/minot/releases/download/v#{version}/librat-aarch64-apple-darwin.a"
        sha256 "067b98081b4a0b10868bb361155f9983cab5ccde6d516f61f043324a535eb9af"
      end

      resource "librat.dylib" do
        url "https://codeberg.org/stelzo/minot/releases/download/v#{version}/librat-aarch64-apple-darwin.dylib"
        sha256 "657664fb4284d4cc513fd4787f7af645b7fd6164ae367b58e488245a9ae93e0d"
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
    sha256 "542a747ef1f6ae44e55787bc2a1e18abf4116750216e08340200f3bf7f5f7788"
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
