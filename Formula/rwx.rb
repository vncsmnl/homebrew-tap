class Rwx < Formula
  desc "A terminal-based utility for inspecting and modifying file and directory permissions, ownership, and other metadata."
  homepage "https://github.com/vncsmnl/rwx"
  version "1.0.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/vncsmnl/rwx/releases/download/v1.0.4/rwx-aarch64-apple-darwin.tar.xz"
      sha256 "923d45d307084b874f6858ed24cbff61110a0fdc6228c87859072d6726972093"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vncsmnl/rwx/releases/download/v1.0.4/rwx-x86_64-apple-darwin.tar.xz"
      sha256 "d908cee255f315482483bc9d79a84fcd221dcd82e066b7898ba85d6ac9289801"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/vncsmnl/rwx/releases/download/v1.0.4/rwx-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "fea040b59d740c9a4baee1add68f845f932653967aeccc62ebac35a6dad5dfb8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vncsmnl/rwx/releases/download/v1.0.4/rwx-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "118bf3417847de973bf1217da60d1e23c1ab31ba523264761a7d48f3713c27f6"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin": {},
    "x86_64-unknown-linux-gnu": {}
  }

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "rwx"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "rwx"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "rwx"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "rwx"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
