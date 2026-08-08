class Allbrew < Formula
  desc "Generate Homebrew formulas and casks from arbitrary URLs"
  homepage "https://github.com/tariqwest/allbrew"
  url "https://github.com/tariqwest/allbrew/releases/download/v0.0.25/allbrew-v0.0.25.tar.gz"
  sha256 "ba3a90100f2bf80d10dce6ef8571d27bdc9b6642a9fbbb875c4289b87dbcc81c"
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

    (buildpath/"allbrew-brew-wrap").write <<~EOS
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
    # etc.install refuses to overwrite existing conf files on upgrade.
    rm_f etc/"allbrew-brew-wrap"
    etc.install "allbrew-brew-wrap"

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
