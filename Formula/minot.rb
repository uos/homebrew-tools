# Maintainer: Christopher Sieh (stelzo) <stelzo@steado.de>
# Template file — CI replaces 0.10.1 and 70465603b0533ef99ff634b3db7545807c0278fb2acce927b8da4823051f9a7f before publishing to the tap.
class Minot < Formula
  desc "A versatile toolset for debugging and verifying stateful robot perception software"
  homepage "https://codeberg.org/stelzo/minot"
  version "0.10.1"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    on_arm do
      url "https://codeberg.org/stelzo/minot/releases/download/v#{version}/minot-aarch64-apple-darwin.tar.gz"
      sha256 "70465603b0533ef99ff634b3db7545807c0278fb2acce927b8da4823051f9a7f"
    end
  end

  def install
    bin.install "min/minot"

    lib.install "librat.a"
    lib.install "librat.dylib"
    (include/"rat").install "rat.h"

    inreplace "librat.pc", "prefix=/usr", "prefix=#{prefix}"
    (lib/"pkgconfig").install "librat.pc"
    (lib/"cmake/minot").install "libratConfig.cmake"

    # Fix install name for dylib to use @rpath
    system "install_name_tool", "-id", "@rpath/librat.dylib", lib/"librat.dylib"

    generate_completions_from_executable(bin/"minot", "completions")
  end

  test do
    system "#{bin}/minot", "--version"
    system "#{bin}/minot", "coord", "--help"
  end
end
