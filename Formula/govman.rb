class Govman < Formula
  desc "Go Version Manager — Fast, lightweight Go version manager"
  homepage "https://govman.dev"
  url "https://github.com/justjundana/govman/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "0019dfc4b32d63c1392aa264aed2253c1e0c2fb09216f8e2cc269bbfb8bb49b5"
  license "MIT"

  def install
    bin.install "scripts/install.sh" => "govman"
    chmod 0755, bin/"govman"
  end

  test do
    system "#{bin}/govman", "--version"
  end
end
