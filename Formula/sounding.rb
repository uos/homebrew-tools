# Maintainer: Christopher Sieh (stelzo) <stelzo@steado.de>
# Template file — CI replaces 0.4.0 and 8cf0bbc4f0f46f9b5631d3fd46fefe0fe12dcffb3903d8ef1daee13a59a8843d
# before publishing to the tap.
class Sounding < Formula
  desc "A SLAM evaluation tool."
  homepage "https://codeberg.org/stelzo/sounding"
  version "0.4.0"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    on_arm do
      url "https://uos-robotics.codeberg.page/ppa/bin/sounding-#{version}-macos-arm64.tar.gz"
      sha256 "8cf0bbc4f0f46f9b5631d3fd46fefe0fe12dcffb3903d8ef1daee13a59a8843d"
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
