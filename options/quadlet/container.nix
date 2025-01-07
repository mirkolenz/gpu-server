{ systemdUtils, unitConfigToText }:
{
  name,
  lib,
  config,
  ...
}:
let
  inherit (systemdUtils.unitOptions) unitOption;
  inherit (lib) mkOption types;
in
{
  options = {
    name = mkOption {
      type = types.str;
      default = name;
    };
    ref = mkOption { readOnly = true; };
    text = mkOption { internal = true; };

    Container = mkOption {
      type = types.attrsOf unitOption;
      default = { };
    };
    Unit = mkOption {
      type = types.attrsOf unitOption;
      default = { };
    };
    Service = mkOption {
      type = types.attrsOf unitOption;
      default = { };
    };
    Install = mkOption {
      type = types.attrsOf unitOption;
      default = { };
    };
    Quadlet = mkOption {
      type = types.attrsOf unitOption;
      default = { };
    };
  };
  config = {
    ref = "${name}.container";
    text = unitConfigToText {
      Container = {
        Name = name;
      } // config.container;
      Unit = {
        Description = "Podman container ${name}";
      } // config.unit;
      Install = {
        WantedBy = "system-manager.target";
      } // config.install;
      Service = {
        Restart = "always";
        # podman rootless requires "newuidmap" (the suid version, not the non-suid one from pkgs.shadow)
        Environment = "PATH=/usr/bin";
        TimeoutStartSec = 900;
      } // config.service;
      Quadlet = config.quadlet;
    };
  };
}
