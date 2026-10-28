# Maintainer: stelzo <stelzo@steado.de>
# Template file — CI replaces 0.5.4 and 9361a5cef3ce7e48eda9dbd9ea8552fad9aac7b92f9f3d6606bb88e2444d2c8c
# before publishing to the tap.
class Marina < Formula
  desc "A dataset manager for robotics to organize, share, and discover datasets and metadata across storage backends."
  homepage "https://codeberg.org/stelzo/marina"
  version "0.5.4"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    on_arm do
      url "https://ppa.steado.tech/bin/marina-#{version}-macos-arm64.tar.gz"
      sha256 "9361a5cef3ce7e48eda9dbd9ea8552fad9aac7b92f9f3d6606bb88e2444d2c8c"
    end
  end

  def install
    chmod 0755, "marina"
    bin.install "marina"

    generate_completions_from_executable(bin/"marina", "completions")
  end

  test do
    system "#{bin}/marina", "--version"
  end
end
