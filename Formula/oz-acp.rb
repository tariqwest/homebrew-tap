# typed: false
# frozen_string_literal: true

# Warp packages `oz` as a cask (warpdotdev/warp/oz), not a formula.
# Formulae cannot declare cask deps via depends_on, so require the binary.
class OzCliRequirement < Requirement
  fatal true
  cask "warpdotdev/warp/oz"

  satisfy(build_env: false) { which("oz") }

  def message
    <<~EOS
      oz-acp requires the Warp Oz CLI (`oz`) on PATH.

      Install from the Warp Homebrew tap:

        brew install --cask warpdotdev/warp/oz

      Or:

        brew tap warpdotdev/warp
        brew install --cask oz

      Then re-run: brew install oz-acp
    EOS
  end

  def display_s
    "oz (Warp CLI cask warpdotdev/warp/oz)"
  end
end

class OzAcp < Formula
  desc "ACP stdio adapter for Warp Oz CLI"
  homepage "https://github.com/tariqwest/oz-acp#readme"
  url "https://github.com/tariqwest/oz-acp/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "3bd45dc6b1fc8f12006d68b7b3ed29494b9460d00865012e770646f5a8d7b793"
  license "MIT"
  head "https://github.com/tariqwest/oz-acp.git", branch: "main"

  depends_on "node"
  depends_on OzCliRequirement

  def install
    system "npm", "install", *std_npm_args
  end

  def caveats
    <<~EOS
      oz-acp is an ACP stdio agent server. Configure your ACP host to run:

        #{bin}/oz-acp

      Runtime dependency: Warp Oz CLI (`oz`) from warpdotdev/homebrew-warp:

        brew install --cask warpdotdev/warp/oz

      Auth with `oz login` or set WARP_API_KEY. Override binary via OZ_BIN_PATH.
    EOS
  end

  test do
    assert_path_exists bin/"oz-acp"
    pkg_json = libexec/"lib/node_modules/oz-acp/package.json"
    assert_path_exists pkg_json
    assert_match version.to_s, pkg_json.read
  end
end
