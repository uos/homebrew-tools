# Maintainer: stelzo <stelzo@steado.de>
# Template file — CI replaces 0.1.1 and 76ebd4d6134d137240b658aa7b55af43a6da2d07f2ee4ccc0c725cfc00dd96c0
# before publishing to the tap.
class Dedrunk < Formula
  desc "Kalibr IMU calibration from MCAP recordings."
  homepage "https://codeberg.org/stelzo/dedrunk"
  version "0.1.1"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    on_arm do
      url "https://ppa.steado.tech/bin/dedrunk-#{version}-macos-arm64.tar.gz"
      sha256 "76ebd4d6134d137240b658aa7b55af43a6da2d07f2ee4ccc0c725cfc00dd96c0"
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
