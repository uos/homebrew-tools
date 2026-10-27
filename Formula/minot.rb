# Maintainer: stelzo <stelzo@steado.de>
# Template file. CI fills in the version and one checksum per downloaded file before publishing to the tap.
class Minot < Formula
  desc "A versatile toolset for debugging and verifying stateful robot perception software"
  homepage "https://codeberg.org/stelzo/minot"
  version "0.14.0"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    on_arm do
      url "https://codeberg.org/stelzo/minot/releases/download/v#{version}/minot-aarch64-apple-darwin"
      sha256 "213e6f6ee5520220ee5457a238cdb8c5834443bbc54da8f5bbe99c51de94c238"

      resource "librat.a" do
        url "https://codeberg.org/stelzo/minot/releases/download/v#{version}/librat-aarch64-apple-darwin.a"
        sha256 "de617f7c6eb3539042e83de10ceabda19744ada9bde94f839cd2e0bdea844652"
      end

      resource "librat.dylib" do
        url "https://codeberg.org/stelzo/minot/releases/download/v#{version}/librat-aarch64-apple-darwin.dylib"
        sha256 "7efa06c27c5c664c91317e66f236041d81d2421de0a42003eed9e23d7f0bd268"
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
    sha256 "996cb4a49da4df0f8fbce44d270a989ea40a1fe835729c9193d53c21aa7eb1ff"
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
