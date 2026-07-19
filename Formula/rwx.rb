class Rwx < Formula
  desc "A terminal-based utility for inspecting and modifying file and directory permissions, ownership, and other metadata."
  homepage "https://github.com/vncsmnl/rwx"
  version "1.0.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/vncsmnl/rwx/releases/download/v1.0.4/rwx-aarch64-apple-darwin.tar.xz"
      sha256 "d9e19842b105ce784ee0c76e1faa8190021ab0a7397e328f9fc4d2e04311031d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vncsmnl/rwx/releases/download/v1.0.4/rwx-x86_64-apple-darwin.tar.xz"
      sha256 "9a194a8b29a3e660c9c0c482bd1c48bf44c9cdf0e00d475615d78dcb9a00fa29"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/vncsmnl/rwx/releases/download/v1.0.4/rwx-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e4070b81299a3b02c88c6cd2eabbd7bbd9c92cb87560dc3bd93df1914daa1b9a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vncsmnl/rwx/releases/download/v1.0.4/rwx-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f3672b45e0d2b2b63dd0806802d958325ccdd91077e725708e58b2fe8b589f00"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

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
    bin.install "rwx" if OS.mac? && Hardware::CPU.arm?
    bin.install "rwx" if OS.mac? && Hardware::CPU.intel?
    bin.install "rwx" if OS.linux? && Hardware::CPU.arm?
    bin.install "rwx" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
