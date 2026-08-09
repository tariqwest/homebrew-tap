# typed: false
# frozen_string_literal: true

# Command Code ships via npm (npm i -g command-code), not Homebrew.
# Formulae cannot declare npm-global deps via depends_on, so require the binary.
class CmdCliRequirement < Requirement
  fatal true
  satisfy(build_env: false) { which("cmd") }

  def message
    <<~EOS
      commandcode-acp requires the Command Code CLI (`cmd`) on PATH.

      Install with npm:

        npm install -g command-code

      Then re-run: brew install commandcode-acp
    EOS
  end

  def display_s
    "cmd (Command Code CLI)"
  end
end

class CommandcodeAcp < Formula
  desc "ACP stdio adapter for Command Code CLI (cmd)"
  homepage "https://github.com/tariqwest/commandcode-acp#readme"
  url "https://github.com/tariqwest/commandcode-acp/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "4968581e0029082439f9ff4e06d6748a18fcc78917a94d16ee10531e03fd8219"
  license "MIT"
  head "https://github.com/tariqwest/commandcode-acp.git", branch: "main"

  depends_on "node"
  depends_on CmdCliRequirement

  def install
    system "npm", "install", *std_npm_args
  end

  def caveats
    <<~EOS
      commandcode-acp is an ACP stdio agent server. Configure your ACP host to run:

        #{bin}/commandcode-acp

      Runtime dependency: Command Code CLI (`cmd`) via npm:

        npm install -g command-code

      Auth with `cmd login`. Override binary via CMD_BIN_PATH.
    EOS
  end

  test do
    assert_path_exists bin/"commandcode-acp"
    pkg_json = libexec/"lib/node_modules/commandcode-acp/package.json"
    assert_path_exists pkg_json
    assert_match version.to_s, pkg_json.read
  end
end
