class Govman < Formula
  desc "Fast, lightweight Go version manager"
  homepage "https://govman.dev"
  version "1.0.0"
  license "MIT"

  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/justjundana/govman/releases/download/v1.0.0/govman-darwin-amd64"
    sha256 "66b3e14f223bbc475abf201ea0ba256d9981e845b664c2addf8b51adb97f6d52"
  elsif OS.mac? && Hardware::CPU.arm?
    url "https://github.com/justjundana/govman/releases/download/v1.0.0/govman-darwin-arm64"
    sha256 "a87692174abd45d2677ccd0960582745ae2c0431654546fa795d1dd79f8609d6"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/justjundana/govman/releases/download/v1.0.0/govman-linux-amd64"
    sha256 "e724494f67bfc68ec7a9b40cd18f27081fdd232cae36fec966de63b12294ba24"
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://github.com/justjundana/govman/releases/download/v1.0.0/govman-linux-arm64"
    sha256 "d1656e9dc5d682a6379dfeb9316d4ebd7bdb26542149d091e29fe5ed41d99f76"
  end

  def install
    # Determine the downloaded binary name based on OS and architecture
    if OS.mac? && Hardware::CPU.intel?
      binary_name = "govman-darwin-amd64"
    elsif OS.mac? && Hardware::CPU.arm?
      binary_name = "govman-darwin-arm64"
    elsif OS.linux? && Hardware::CPU.intel?
      binary_name = "govman-linux-amd64"
    elsif OS.linux? && Hardware::CPU.arm?
      binary_name = "govman-linux-arm64"
    end
    
    # Install binary to Homebrew's bin
    bin.install binary_name => "govman"
  end

  def post_install
    # Create govman home directory structure
    govman_home = "#{Dir.home}/.govman"
    
    # Create necessary directories
    FileUtils.mkdir_p "#{govman_home}/versions"
    FileUtils.mkdir_p "#{govman_home}/cache"
    FileUtils.mkdir_p "#{govman_home}/bin"
    
    # Create symlink from Homebrew binary to govman bin
    # This ensures govman can find its binary where it expects
    govman_bin = "#{govman_home}/bin/govman"
    FileUtils.rm_f govman_bin if File.exist?(govman_bin)
    FileUtils.ln_s "#{bin}/govman", govman_bin
    
    # Set proper permissions
    FileUtils.chmod 0755, govman_bin
  end

  def caveats
    <<~EOS
      ╔═══════════════════════════════════════════════════════════════════╗
      ║                   govman Installation Complete!                   ║
      ╚═══════════════════════════════════════════════════════════════════╝
      
      ⚡ QUICK SETUP (Required for first time):
          
          1. Initialize govman:
             $ govman init
          
          2. Reload your shell:
             $ source ~/.zshrc   # For Zsh
             $ source ~/.bashrc  # For Bash
      
      🚀 USAGE:
          $ govman install 1.23.0
          $ govman use 1.23.0
          $ govman list
      
      🗑️  TO UNINSTALL:
          
          Option A - Using brew (removes binary only):
             $ brew uninstall govman
          
          Option B - Complete removal (binary + all data):
             $ curl -fsSL https://get.govman.dev/uninstall.sh | bash
      
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      📚 Docs: https://govman.dev
      🐛 Issues: https://github.com/justjundana/govman/issues
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/govman --version")
  end
end