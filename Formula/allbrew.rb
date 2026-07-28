class Allbrew < Formula
  desc "Generate Homebrew formulas and casks from arbitrary URLs"
  homepage "https://github.com/tariqwest/allbrew"
  url "https://github.com/tariqwest/allbrew/releases/download/v0.0.5/allbrew-v0.0.5.tar.gz"
  sha256 "1f627a66b6798820db08186a852fedd1e26dcb4e3b34274f865fc61ab307531e"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "bun"

  def install
    libexec.install Dir["*"]

    (libexec/"allbrew").install libexec/"scripts"/"update-managed.sh"
    chmod 0755, libexec/"allbrew"/"update-managed.sh"

    (etc/"allbrew-brew-wrap").write <<~EOS
      # allbrew brew update hook
      # Source from your shell profile:
      #   source "$(brew --prefix)/etc/allbrew-brew-wrap"

      allbrew_brew() {
        command brew "$@"
        local ret=$?
        if [ $ret -eq 0 ] && [ "$1" = "update" ]; then
          brew livecheck --installed --newer-only --json --quiet 2>/dev/null | #{bin}/allbrew update-formulas
          command brew update
        fi
        return $ret
      }

      # Opt in by aliasing brew:
      # alias brew=allbrew_brew
    EOS

    (bin/"allbrew").write <<~EOS
      #!/bin/bash
      exec "#{Formula["bun"].opt_bin}/bun" "#{libexec}/bin/allbrew.ts" "$@"
    EOS
    chmod 0755, bin/"allbrew"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/allbrew --version")
  end
end
