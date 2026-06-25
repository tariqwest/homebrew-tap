class FmServer < Formula
  desc "Apple Foundation Models for Node.js — OpenAI-compatible HTTP server + CLI"
  homepage "https://github.com/tariqwest/fm-server"
  url "https://github.com/tariqwest/fm-server/releases/download/v0.1.1/fm-server-prebuilt-arm64-apple-darwin-0.1.1.tar.gz"
  sha256 "375bf0de9267d3f81a7c3fb601d1196c2397288e1aa6d773179b9b59df9bd8d0"
  license "MIT"
  version "0.1.1"

  depends_on "node"
  on_macos do
    depends_on arch: :arm64
  end

  def install
    libexec.install "dist", "bin", "node_modules"

    (bin/"fm-server").write <<~EOS
      #!/bin/bash
      exec "#{Formula["node"].opt_bin}/node" "#{libexec}/bin/fm-server.js" "$@"
    EOS
    chmod 0755, bin/"fm-server"
  end

  service do
    run [opt_bin/"fm-server", "serve"]
    keep_alive true
    log_path var/"log/fm-server.log"
    error_log_path var/"log/fm-server-error.log"
    environment_variables FM_SERVER_PORT: "1337",
                          FM_SERVER_TOKEN: "fm-server"
    require_root false
  end

  def caveats
    <<~EOS
      fm-server requires:
        - macOS 26 (Tahoe) or later
        - Apple Silicon (M1+)
        - Apple Intelligence enabled in System Settings

      To start the server manually:
        fm-server serve --port 1337

      To run as a background service (auto-starts at login):
        brew services start fm-server

      Manage the service:
        brew services stop fm-server
        brew services restart fm-server
        brew services info fm-server
    EOS
  end

  test do
    assert_match "fm-server", shell_output("#{bin}/fm-server --help")
  end
end
