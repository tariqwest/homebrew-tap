class AllbrewDogfood < Formula
  desc "Dogfood build of allbrew (drop-in allbrew command)"
  homepage "https://github.com/tariqwest/allbrew"
  url "https://github.com/tariqwest/allbrew/archive/refs/tags/v0.0.38-dogfood.2.tar.gz"
  sha256 "2bf85dd69765ed785b7b7c13f004f6073f6dc80553c8db99c2836833e88b2004"
  version "0.0.38-dogfood.2"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+-dogfood(?:\.\d+)?)$/i)
  end

  depends_on "bun"

  conflicts_with "allbrew", because: "allbrew-dogfood is a drop-in replacement for allbrew; both install the same /opt/homebrew/bin/allbrew command"

  def install
    libexec.install Dir["*"]
    system "bun", "install", "--cwd", libexec

    (libexec/"allbrew").install libexec/"scripts"/"update-managed.sh"
    chmod 0755, libexec/"allbrew"/"update-managed.sh"

    (buildpath/"allbrew-brew-wrap").write <<~EOS
      # allbrew-dogfood brew update hook
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
