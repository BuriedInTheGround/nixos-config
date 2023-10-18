{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;

let

  cfg = config.modules.develop.flyctl;

  flyctl = pkgs.buildGo121Module rec {
    pname = "flyctl";
    version = "0.1.110";

    src = pkgs.fetchFromGitHub {
      owner = "superfly";
      repo = "flyctl";
      rev = "v${version}";
      hash = "sha256-uvwJr/YWkfvrch9e0RB/7rzK6O3dQg/bjLZsJPEntZ0=";
    };

    vendorHash = "sha256-mEHo7pmXsrYhGlNqGXXlFVXIyWTeUy4Sv045yLvJcrc=";

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
