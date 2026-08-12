# typed: false
# frozen_string_literal: true

class PwaBrowserSwitcher < Formula
  desc "Convert macOS PWA desktop apps between Safari, Chromium, and Firefox-family browsers"
  homepage "https://github.com/tariqwest/pwa-browser-switcher#readme"
  url "https://github.com/tariqwest/pwa-browser-switcher/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "15bc2d834f0166c548945a1af14ad14cd0e8a65fb80d141c1d15eb575e706045"
  license "MIT"
  head "https://github.com/tariqwest/pwa-browser-switcher.git", branch: "main"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
  end

  def caveats
    <<~EOS
      pwa-switch migrates macOS PWA desktop apps between browsers.

        #{bin}/pwa-switch --help
        #{bin}/pwa-switch browsers
        #{bin}/pwa-switch scan

      UI-driven installs (Safari / Chromium / Orion) need Accessibility
      permission for your terminal:

        System Settings → Privacy & Security → Accessibility

      Firefox targets need PWAsForFirefox (firefoxpwa) on PATH.

      Docs: https://github.com/tariqwest/pwa-browser-switcher#readme
    EOS
  end

  test do
    assert_path_exists bin/"pwa-switch"
    pkg_json = libexec/"lib/node_modules/pwa-browser-switcher/package.json"
    assert_path_exists pkg_json
    assert_match version.to_s, pkg_json.read
    assert_match "pwa-switch", shell_output("#{bin}/pwa-switch --help")
  end
end
