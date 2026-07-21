class Rwx < Formula
  desc "A terminal-based utility for inspecting and modifying file and directory permissions, ownership, and other metadata."
  homepage "https://github.com/vncsmnl/rwx"
  version "1.0.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/vncsmnl/rwx/releases/download/v1.0.5/rwx-aarch64-apple-darwin.tar.xz"
      sha256 "1946d136df68b23ea41910ff372c4fc9ff0ed979659d47073c076d675e9a8436"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vncsmnl/rwx/releases/download/v1.0.5/rwx-x86_64-apple-darwin.tar.xz"
      sha256 "42e5c4facb52b939f7eef19341b7131c678f62a3f46bf6d38eb27e20ac6d4032"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/vncsmnl/rwx/releases/download/v1.0.5/rwx-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "762e9b4c89919d69f5acfbd30395d64cff88fe51ee4358802d015e2d855e746f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vncsmnl/rwx/releases/download/v1.0.5/rwx-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "22d9ae2861eb3b9bbd4b838bebf5376b4e3ce315c7091afcd206d864c7becabe"
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
