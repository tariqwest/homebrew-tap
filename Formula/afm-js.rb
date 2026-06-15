class AfmJs < Formula
  desc "Apple Foundation Models for Node.js — OpenAI-compatible HTTP server + CLI"
  homepage "https://github.com/tariqwest/afm-js"
  url "https://github.com/tariqwest/afm-js/releases/download/v0.0.2/afm-js-prebuilt-arm64-apple-darwin-0.0.2.tar.gz"
  sha256 "86a35f2d13acc75b8c2b22e806c801fcfe6777836bdf05a09ec6ba2616789a0f"
  license "MIT"
  version "0.0.2"

  depends_on "node"
  depends_on :macos
  depends_on arch: :arm64

  resource "afm-fm-helper" do
    url "https://github.com/tariqwest/afm-js/releases/download/v0.0.2/afm-fm-helper-arm64-apple-darwin-0.0.2.tar.gz"
    sha256 "8b43671514f75be4efa387575bded3422b29ab3bfdfbab8dd2e202df6f21f897"
  end

  def install
    libexec.install Dir["dist"], "bin"

    (bin/"afm-js").write <<~EOS
      #!/bin/bash
      export AFM_JS_HELPER_PATH="#{opt_prefix}/libexec/afm-fm-helper"
      exec "#{Formula["node"].opt_bin}/node" "#{libexec}/bin/afm-js.js" "$@"
    EOS
    chmod 0755, bin/"afm-js"

    resource("afm-fm-helper").stage do
      libexec.install "afm-fm-helper"
    end
    chmod 0755, libexec/"afm-fm-helper"
  end

  def caveats
    <<~EOS
      afm-js requires:
        - macOS 26 (Tahoe) or later
        - Apple Silicon (M1+)
        - Apple Intelligence enabled in System Settings

      The helper binary is installed at:
        #{opt_prefix}/libexec/afm-fm-helper
    EOS
  end
end
