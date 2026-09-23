# Maintainer: stelzo <stelzo@steado.de>
# Template file — CI replaces 0.11.3 and 78b701b710d07615a5380492582e5ae6a02db730a5d0d2b6ef614ed96c0a0351 before publishing to the tap.
class Minot < Formula
  desc "A versatile toolset for debugging and verifying stateful robot perception software"
  homepage "https://codeberg.org/stelzo/minot"
  version "0.11.3"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    on_arm do
      url "https://codeberg.org/stelzo/minot/releases/download/v#{version}/minot-aarch64-apple-darwin.tar.gz"
      sha256 "78b701b710d07615a5380492582e5ae6a02db730a5d0d2b6ef614ed96c0a0351"
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
