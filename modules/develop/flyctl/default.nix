{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;

let

  cfg = config.modules.develop.flyctl;

  flyctl = pkgs.buildGo122Module rec {
    pname = "flyctl";
    version = "0.2.65";

    src = pkgs.fetchFromGitHub {
      owner = "superfly";
      repo = "flyctl";
      rev = "v${version}";
      hash = "sha256-TB0Y3QgoGM5RlKWBKg2XKuFQJz0mw6sqWuDn1z93+6g=";
    };

    vendorHash = "sha256-dQDkW1fSXn6c2bImnAyvb3WpdARe3EZdPkPkLZHMKzY=";

    subPackages = [ "." ];

    ldflags = [
      "-s" "-w"
      "-X github.com/superfly/flyctl/internal/buildinfo.commit=${src.rev}"
      "-X github.com/superfly/flyctl/internal/buildinfo.buildDate=1970-01-01T00:00:00Z"
      "-X github.com/superfly/flyctl/internal/buildinfo.environment=production"
      "-X github.com/superfly/flyctl/internal/buildinfo.version=${version}"
    ];

    nativeBuildInputs = [ pkgs.installShellFiles ];

    patches = [ ./disable-auto-update.patch ];

    preBuild = ''
      go generate ./...
    '';

    preCheck = ''
      HOME=$(mktemp -d)
    '';

    postCheck = ''
      go test ./... -ldflags="-X 'github.com/superfly/flyctl/internal/buildinfo.buildDate=1970-01-01T00:00:00Z'"
    '';

    postInstall = ''
      installShellCompletion --cmd flyctl \
        --bash <($out/bin/flyctl completion bash) \
        --fish <($out/bin/flyctl completion fish) \
        --zsh <($out/bin/flyctl completion zsh)
      ln -s $out/bin/flyctl $out/bin/fly
    '';

    passthru.tests.version = testers.testVersion {
      package = flyctl;
      command = "HOME=$(mktemp -d) flyctl version";
      version = "v${flyctl.version}";
    };

    meta = with lib; {
      description = "Command line tools for fly.io services";
      downloadPage = "https://github.com/superfly/flyctl";
      homepage = "https://fly.io/";
      license = licenses.asl20;
      mainProgram = "flyctl";
    };
  };

in {
  options.modules.develop.flyctl = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = [ flyctl ];
  };
}
