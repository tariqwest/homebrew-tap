class Allbrew < Formula
  desc "Generate Homebrew formulas and casks from arbitrary URLs"
  homepage "https://github.com/tariqwest/allbrew"
  url "https://github.com/tariqwest/allbrew/releases/download/v0.0.9/allbrew-v0.0.9.tar.gz"
  sha256 "7c4b37736ff054a140615814d0cad49c88ba1e14f334754e3c373a211cfb915a"
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
