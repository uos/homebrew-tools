# Maintainer: stelzo <stelzo@steado.de>
# Template file — CI replaces 0.5.2 and 38ab6f8e37bff558abce3800074e2f6cde4ecd1e45142d8a7464cd098adb4f77
# before publishing to the tap.
class Marina < Formula
  desc "A dataset manager for robotics to organize, share, and discover datasets and metadata across storage backends."
  homepage "https://codeberg.org/stelzo/marina"
  version "0.5.2"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    on_arm do
      url "https://uos-robotics.codeberg.page/ppa/bin/marina-#{version}-macos-arm64.tar.gz"
      sha256 "38ab6f8e37bff558abce3800074e2f6cde4ecd1e45142d8a7464cd098adb4f77"
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
