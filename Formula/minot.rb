# Maintainer: Christopher Sieh (stelzo) <stelzo@steado.de>
# Template file — CI replaces 0.11.0 and 7553a79d4636bca5e7a1cc1befd4e9018808cf2197d8c82bfa13fb7fc906dfeb before publishing to the tap.
class Minot < Formula
  desc "A versatile toolset for debugging and verifying stateful robot perception software"
  homepage "https://codeberg.org/stelzo/minot"
  version "0.11.0"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    on_arm do
      url "https://codeberg.org/stelzo/minot/releases/download/v#{version}/minot-aarch64-apple-darwin.tar.gz"
      sha256 "7553a79d4636bca5e7a1cc1befd4e9018808cf2197d8c82bfa13fb7fc906dfeb"
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
