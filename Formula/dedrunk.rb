# Maintainer: Christopher Sieh (stelzo) <stelzo@steado.de>
# Template file — CI replaces 0.1.0 and ef4caf6a38cf653a8ad0d1d0867c8deb793cc557cdf0607721f3787486d6fddf
# before publishing to the tap.
class Dedrunk < Formula
  desc "Kalibr IMU calibration from MCAP recordings."
  homepage "https://codeberg.org/stelzo/dedrunk"
  version "0.1.0"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    on_arm do
      url "https://uos-robotics.codeberg.page/ppa/bin/dedrunk-#{version}-macos-arm64.tar.gz"
      sha256 "ef4caf6a38cf653a8ad0d1d0867c8deb793cc557cdf0607721f3787486d6fddf"
    end
  end

  def install
    chmod 0755, "dedrunk"
    bin.install "dedrunk"

    generate_completions_from_executable(bin/"dedrunk", "completions")
  end

  test do
    system "#{bin}/dedrunk", "--version"
  end
end
