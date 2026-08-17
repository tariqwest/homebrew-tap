class AllbrewDogfood < Formula
  desc "Dogfood build of allbrew"
  homepage "https://github.com/tariqwest/allbrew"
  url "https://github.com/tariqwest/allbrew/archive/refs/tags/v0.0.37-dogfood.1.tar.gz"
  sha256 "b6d2ce63688d29dc46bc98f340e1e19e78c131d4de1f0fc08d4f086a91c30986"
  version "0.0.37-dogfood.1"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+-dogfood(?:\.\d+)?)$/i)
  end

  depends_on "bun"

  def install
    libexec.install Dir["*"]

    (libexec/"allbrew-dogfood").install libexec/"scripts"/"update-managed.sh"
    chmod 0755, libexec/"allbrew-dogfood"/"update-managed.sh"

    (buildpath/"allbrew-dogfood-brew-wrap").write <<~EOS
      # allbrew-dogfood brew update hook
      # Source from your shell profile:
      #   source "$(brew --prefix)/etc/allbrew-dogfood-brew-wrap"

      allbrew_dogfood_brew() {
        command brew "$@"
        local ret=$?
        if [ $ret -eq 0 ] && [ "$1" = "update" ]; then
          brew livecheck --installed --newer-only --json --quiet 2>/dev/null | #{bin}/allbrew-dogfood update-formulas
          command brew update
        fi
        return $ret
      }

      # Opt in by aliasing brew:
      # alias brew=allbrew_dogfood_brew
    EOS
    # etc.install refuses to overwrite existing conf files on upgrade.
    rm_f etc/"allbrew-dogfood-brew-wrap"
    etc.install "allbrew-dogfood-brew-wrap"

    (bin/"allbrew-dogfood").write <<~EOS
      #!/bin/bash
      exec "#{Formula["bun"].opt_bin}/bun" "#{libexec}/bin/allbrew.ts" "$@"
    EOS
    chmod 0755, bin/"allbrew-dogfood"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/allbrew-dogfood --version")
  end
end
