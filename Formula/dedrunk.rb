# Maintainer: stelzo <stelzo@steado.de>
# Template file — CI replaces 0.2.0 and 6cb7aed8c301ea7019ec1e130dee1ee5b3d9c9536813f64299c7f1ae57d6cc42
# before publishing to the tap.
class Dedrunk < Formula
  desc "Camera and IMU intrinsics and Lidar, camera and IMU extrinsics, with a GUI"
  homepage "https://codeberg.org/stelzo/dedrunk"
  version "0.2.0"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    on_arm do
      url "https://ppa.steado.tech/bin/dedrunk-#{version}-macos-arm64.tar.gz"
      sha256 "6cb7aed8c301ea7019ec1e130dee1ee5b3d9c9536813f64299c7f1ae57d6cc42"
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
