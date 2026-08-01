# typed: false
# frozen_string_literal: true

class OzAcp < Formula
  desc "ACP stdio adapter for Warp Oz CLI"
  homepage "https://github.com/tariqwest/oz-acp#readme"
  url "https://github.com/tariqwest/oz-acp/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "fc80d21af70e98b6bd1e70e35b200b6408a5ff7588cf1020f3eb24bde41ad2a4"
  license "MIT"
  head "https://github.com/tariqwest/oz-acp.git", branch: "main"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
  end

  def caveats
    <<~EOS
      oz-acp is an ACP stdio agent server. Configure your ACP host to run:

        #{bin}/oz-acp

      Requires the Warp oz CLI on PATH (or set OZ_BIN_PATH / WARP_API_KEY).
    EOS
  end

  test do
    assert_path_exists bin/"oz-acp"
    pkg_json = libexec/"lib/node_modules/oz-acp/package.json"
    assert_path_exists pkg_json
    assert_match version.to_s, pkg_json.read
  end
end
