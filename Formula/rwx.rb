class Rwx < Formula
  desc "A terminal-based utility for inspecting and modifying file and directory permissions, ownership, and other metadata"
  homepage "https://github.com/vncsmnl/rwx"
  url "https://github.com/vncsmnl/rwx/archive/refs/tags/v1.0.4.tar.gz"
  sha256 "40bc469ff23933f0bd15ad528ab36677281d0a58b6e33183f11f55c24756e9b3"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Verify that rwx is installed and runs
    system "#{bin}/rwx", "--version"
  end
end
