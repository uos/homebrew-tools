# Maintainer: Christopher Sieh (stelzo) <stelzo@steado.de>
# Template file — CI replaces 0.10.2 and f0dac16a04d6a10158279649da6cc436db3ce040d9fb5a95c0be820d28a5d518 before publishing to the tap.
class Minot < Formula
  desc "A versatile toolset for debugging and verifying stateful robot perception software"
  homepage "https://codeberg.org/stelzo/minot"
  version "0.10.2"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    on_arm do
      url "https://codeberg.org/stelzo/minot/releases/download/v#{version}/minot-aarch64-apple-darwin.tar.gz"
      sha256 "f0dac16a04d6a10158279649da6cc436db3ce040d9fb5a95c0be820d28a5d518"
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
