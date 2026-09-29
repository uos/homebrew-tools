# Maintainer: stelzo <stelzo@steado.de>
# Template file — CI replaces 0.4.1 and 9f247985903a1fef07baf0ea503ceead30d9ff3163666efaf88a54dc3b34f854
# before publishing to the tap.
class Sounding < Formula
  desc "A SLAM evaluation tool."
  homepage "https://codeberg.org/stelzo/sounding"
  version "0.4.1"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    on_arm do
      url "https://ppa.steado.tech/bin/sounding-#{version}-macos-arm64.tar.gz"
      sha256 "9f247985903a1fef07baf0ea503ceead30d9ff3163666efaf88a54dc3b34f854"
    end
  end

  def install
    chmod 0755, "sounding"
    bin.install "sounding"

    generate_completions_from_executable(bin/"sounding", "completions")
  end

  test do
    system "#{bin}/sounding", "--version"
  end
end
