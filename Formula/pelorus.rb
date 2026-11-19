# Maintainer: stelzo <stelzo@steado.de>
# Template file — CI replaces 0.1.0, d6df5e93d3352a81b10750d05d75e6e343e509c8d640c237410573adc0ad6105,
# before publishing to the tap.
class Pelorus < Formula
  desc "Resource-Aware Lidar-Inertial Odometry"
  homepage "https://pelorus.steado.tech"
  version "0.1.0"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "minot"
  depends_on "dedrunk"
  depends_on "marina"

  on_macos do
    on_arm do
      url "https://ppa.steado.tech/bin/pelorus-#{version}-macos-arm64.tar.gz"
      sha256 "d6df5e93d3352a81b10750d05d75e6e343e509c8d640c237410573adc0ad6105"
    end
  end

  def install
    chmod 0755, "pelorus"
    bin.install "pelorus"

    inreplace "pelorus.pc", "prefix=/usr", "prefix=#{prefix}"

    chmod 0644, "libpelorus.dylib"
    lib.install "libpelorus.dylib"
    include.install "pelorus.h"
    include.install "pelorus.hpp"
    (lib/"pkgconfig").install "pelorus.pc"
    (lib/"cmake/pelorus").install "pelorusConfig.cmake"
    (lib/"cmake/pelorus").install "pelorusConfigVersion.cmake"

    # Fix install name for dylib to use @rpath
    system "install_name_tool", "-id", "@rpath/libpelorus.dylib", lib/"libpelorus.dylib"

    generate_completions_from_executable(bin/"pelorus", "completions")
  end

  test do
    system "#{bin}/pelorus", "--version"
  end
end
