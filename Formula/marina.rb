# Maintainer: Christopher Sieh (stelzo) <stelzo@steado.de>
# Template file — CI replaces 0.5.0 and 5263e6e9d9ce583133a3dae2ae8514f2a63e8a83b14fcd8467e870d920697843
# before publishing to the tap.
class Marina < Formula
  desc "A dataset manager for robotics to organize, share, and discover datasets and metadata across storage backends."
  homepage "https://codeberg.org/stelzo/marina"
  version "0.5.0"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    on_arm do
      url "https://uos-robotics.codeberg.page/ppa/bin/marina-#{version}-macos-arm64.tar.gz"
      sha256 "5263e6e9d9ce583133a3dae2ae8514f2a63e8a83b14fcd8467e870d920697843"
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
