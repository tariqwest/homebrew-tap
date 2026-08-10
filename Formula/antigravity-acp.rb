class AntigravityAcp < Formula
  desc "Agent Client Protocol server for Google Antigravity's agy CLI"
  homepage "https://github.com/tariqwest/antigravity-acp"
  version "1.3.14"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/tariqwest/antigravity-acp/releases/download/v1.3.14/agy-acp-darwin-arm64"
      sha256 "$(curl -sL https://github.com/tariqwest/antigravity-acp/releases/download/v1.3.14/agy-acp-darwin-arm64 | shasum -a 256 | cut -d' ' -f1)"
    else
      url "https://github.com/tariqwest/antigravity-acp/releases/download/v1.3.14/agy-acp-darwin-x64"
      sha256 "$(curl -sL https://github.com/tariqwest/antigravity-acp/releases/download/v1.3.14/agy-acp-darwin-x64 | shasum -a 256 | cut -d' ' -f1)"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/tariqwest/antigravity-acp/releases/download/v1.3.14/agy-acp-linux-arm64"
      sha256 "$(curl -sL https://github.com/tariqwest/antigravity-acp/releases/download/v1.3.14/agy-acp-linux-arm64 | shasum -a 256 | cut -d' ' -f1)"
    else
      url "https://github.com/tariqwest/antigravity-acp/releases/download/v1.3.14/agy-acp-linux-x64"
      sha256 "$(curl -sL https://github.com/tariqwest/antigravity-acp/releases/download/v1.3.14/agy-acp-linux-x64 | shasum -a 256 | cut -d' ' -f1)"
    end
  end

  def install
    bin.install "antigravity-acp"
  end
end
