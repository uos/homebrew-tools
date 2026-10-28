# Maintainer: stelzo <stelzo@steado.de>
# Template file — CI replaces 0.0.9, d1470fbf8604985b1ba7300389259349f8de4c665fd7ba992c817d7a43a33ce8,
# before publishing to the tap.
class Pelorus < Formula
  desc "Highly efficient Lidar Inertial Odometry"
  homepage "https://codeberg.org/stelzo/pelorus"
  version "0.0.9"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "minot"
  depends_on "dedrunk"
  depends_on "marina"

  on_macos do
    on_arm do
      url "https://ppa.steado.tech/bin/pelorus-#{version}-macos-arm64.tar.gz"
      sha256 "d1470fbf8604985b1ba7300389259349f8de4c665fd7ba992c817d7a43a33ce8"
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
