# Maintainer: stelzo <stelzo@steado.de>
# Template file. CI fills in the version and one checksum per downloaded file before publishing to the tap.
class Minot < Formula
  desc "A versatile toolset for debugging and verifying stateful robot perception software"
  homepage "https://codeberg.org/stelzo/minot"
  version "0.12.1"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    on_arm do
      url "https://codeberg.org/stelzo/minot/releases/download/v#{version}/minot-aarch64-apple-darwin"
      sha256 "df7474991e5d933d39ef65499255ac6343a10774136b252fc7279f9e01083413"

      resource "librat.a" do
        url "https://codeberg.org/stelzo/minot/releases/download/v#{version}/librat-aarch64-apple-darwin.a"
        sha256 "47f13f824245c17c144b76afaf6204c5b23820483df61d7b806aef944465e93c"
      end

      resource "librat.dylib" do
        url "https://codeberg.org/stelzo/minot/releases/download/v#{version}/librat-aarch64-apple-darwin.dylib"
        sha256 "5a3906e2cdd92c23d0a7864523b21a4330cc7d7d1c42dfd73ab12d9e783b7ade"
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
    sha256 "4c3f6ca163616baaffd7b5d1e9510fa8b8f7d9c622ab34c224512fc8f6b07425"
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
