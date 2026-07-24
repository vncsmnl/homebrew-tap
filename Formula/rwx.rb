class Rwx < Formula
  desc "A terminal-based utility for inspecting and modifying file and directory permissions, ownership, and other metadata."
  homepage "https://github.com/vncsmnl/rwx"
  version "1.0.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/vncsmnl/rwx/releases/download/v1.0.6/rwx-aarch64-apple-darwin.tar.xz"
      sha256 "cc546c82424fcadd7b5fa08c819b2d00882f5428a504074424c635194ca66ce7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vncsmnl/rwx/releases/download/v1.0.6/rwx-x86_64-apple-darwin.tar.xz"
      sha256 "bccaa736b10cda1c9606136b0b70c33ad098eb582614b711daf779496d3ed2f3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/vncsmnl/rwx/releases/download/v1.0.6/rwx-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3339b7d39f4be4589d03af9cddf8517b54e483c6f6a2abcba57fe8fa6964c072"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vncsmnl/rwx/releases/download/v1.0.6/rwx-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8b576b81d51621e3bb36ccecc6fa346b4fb6028744aa9654b20bc8fa03dfbd11"
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
