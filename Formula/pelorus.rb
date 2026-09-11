# Maintainer: Christopher Sieh (stelzo) <stelzo@steado.de>
# Template file — CI replaces 0.0.7, 6450c7d75fb19e97a7dda7e4a851a747bd75f64d13f6aaab49ce77c4a7757c43,
# before publishing to the tap.
class Pelorus < Formula
  desc "Highly efficient Lidar Inertial Odometry"
  homepage "https://codeberg.org/stelzo/pelorus"
  version "0.0.7"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    on_arm do
      url "https://uos-robotics.codeberg.page/ppa/bin/pelorus-#{version}-macos-arm64.tar.gz"
      sha256 "6450c7d75fb19e97a7dda7e4a851a747bd75f64d13f6aaab49ce77c4a7757c43"
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
