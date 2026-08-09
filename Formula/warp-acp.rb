# typed: false
# frozen_string_literal: true

# Warp packages `oz` as a cask (warp), not a formula.
# Formulae cannot declare cask deps via depends_on, so require the binary.
class WarpCliRequirement < Requirement
  fatal true
  cask "warp"

  satisfy(build_env: false) { which("warp") }

  def message
    <<~EOS
      warp-acp requires the Warp Oz CLI (`oz`) on PATH.

      Install Warp Agent CLI:

        curl https://app.warp.dev/download/agent-cli | bash  # or brew install warp

      Or:

        # see https://docs.warp.dev/cli
        curl https://app.warp.dev/download/agent-cli | bash

      Then re-run: brew install warp-acp
    EOS
  end

  def display_s
    "oz (Warp CLI cask warp)"
  end
end

class WarpAcp < Formula
  desc "ACP stdio adapter for Warp Agent CLI"
  homepage "https://github.com/tariqwest/warp-acp#readme"
  url "https://github.com/tariqwest/warp-acp/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "a578db6330aa7c48445fbbb0dd84b2b0df19e71388af1226a3b0ac853bc31a6d"
  license "MIT"
  head "https://github.com/tariqwest/warp-acp.git", branch: "main"

  depends_on "node"
  depends_on WarpCliRequirement

  def install
    system "npm", "install", *std_npm_args
  end

  def caveats
    <<~EOS
      warp-acp is an ACP stdio agent server. Configure your ACP host to run:

        #{bin}/warp-acp

      Runtime dependency: Warp Oz CLI (`oz`) from warpdotdev/homebrew-warp:

        curl https://app.warp.dev/download/agent-cli | bash  # or brew install warp

      Auth with `warp login` or set WARP_API_KEY. Override binary via WARP_BIN_PATH.
    EOS
  end

  test do
    assert_path_exists bin/"warp-acp"
    pkg_json = libexec/"lib/node_modules/warp-acp/package.json"
    assert_path_exists pkg_json
    assert_match version.to_s, pkg_json.read
  end
end
