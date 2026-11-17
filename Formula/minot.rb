# Maintainer: stelzo <stelzo@steado.de>
# Template file. CI fills in the version and one checksum per downloaded file before publishing to the tap.
class Minot < Formula
  desc "A versatile toolset for debugging and verifying stateful robot perception software"
  homepage "https://minot.steado.tech"
  version "0.15.2"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    on_arm do
      url "https://codeberg.org/stelzo/minot/releases/download/v#{version}/minot-aarch64-apple-darwin"
      sha256 "6538863f479b104976f34c8d4d8726f811a3efab25a61f71a185bc56a8012f99"

      resource "librat.a" do
        url "https://codeberg.org/stelzo/minot/releases/download/v#{version}/librat-aarch64-apple-darwin.a"
        sha256 "09931b60d51842016e623e9ceb101ccce1ae89cc59ced67e871da6d975dd3fc3"
      end

      resource "librat.dylib" do
        url "https://codeberg.org/stelzo/minot/releases/download/v#{version}/librat-aarch64-apple-darwin.dylib"
        sha256 "153fa9d5f228ea0e0897f4e0d5011c40e808b37ca7740f41e00b96c9c4fc8332"
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
    sha256 "312daf0419374c87b66520d857782b93829e4e17d83af599bf336bc261462528"
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
