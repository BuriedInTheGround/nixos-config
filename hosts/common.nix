{ config, lib, pkgs, ... }:

with lib;

{
  # Set the time zone.
  time.timeZone = mkDefault "Europe/Rome";

  # Set the location (for Redshift).
  location = (if config.time.timeZone == "Europe/Rome" then {
    latitude = 45.4799;
    longitude = 11.9872;
  } else {
    # Add --here-- other locations if needed.
  });

  # Select internationalisation properties.
  i18n.defaultLocale = mkDefault "en_US.UTF-8";
}
