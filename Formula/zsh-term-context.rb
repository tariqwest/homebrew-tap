# typed: false
# frozen_string_literal: true

class ZshTermContext < Formula
  desc "Detect terminal hosts and gate zsh config by capabilities, features, and hooks"
  homepage "https://github.com/tariqwest/zsh-term-context#readme"
  url "https://github.com/tariqwest/zsh-term-context/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "85348912a06d4155c8d126d8948384f402c5343e205adc2b828c411314edf7a9"
  license "MIT"
  head "https://github.com/tariqwest/zsh-term-context.git", branch: "main"

  uses_from_macos "zsh" => :test

  def install
    pkgshare.install "term-context.zsh", "zsh-term-context.plugin.zsh", "src", "contrib"
    doc.install "README.md", "LICENSE", "docs" if (buildpath/"docs").exist?
  end

  def caveats
    <<~EOS
      zsh-term-context detects your terminal / IDE / agent host and exposes
      capability flags so you can gate plugins and hooks in ~/.zshrc.

      Add near the top of your .zshrc (before zinit / terminal-specific config):

        source #{opt_pkgshare}/term-context.zsh

      Then:

        if term_cap wants_heavy_rc; then
          # zinit / autosuggestions / …
        fi

      Debug:

        term_print_context

      Docs: https://github.com/tariqwest/zsh-term-context#readme
    EOS
  end

  test do
    assert_path_exists pkgshare/"term-context.zsh"
    assert_path_exists pkgshare/"src/detect.zsh"
    output = shell_output(
      "env -i HOME='#{testpath}' PATH=/usr/bin:/bin TERM=xterm-256color " \
      "TERM_PROGRAM=WarpTerminal TERM_CONTEXT_AUTO_INTEGRATE=0 " \
      "zsh -f -i -c 'source #{pkgshare}/term-context.zsh; print -r -- $TERM_APP'"
    )
    assert_equal "warp", output.strip
  end
end
