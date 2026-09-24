{
  hayes.hypridle = {
    dimTimeout ? 300,
    lockTimeout ? 600,
    suspendTimeout ? 1800,
    ...
  }: {
    homeManager = {
      services.hypridle = {
        enable = true;
        settings = {
          general = {
            lock_cmd = "pidof hyprlock || hyprlock";
            before_sleep_cmd = "loginctl lock-session";
            after_sleep_cmd = "hyprctl dispatch dpms on";
          };

          listener = [
            {
              timeout = dimTimeout;
              on-timeout = "brightnessctl -s set 10";
              on-resume = "brightnessctl -r";
            }
            {
              timeout = lockTimeout;
              on-timeout = "loginctl lock-session";
            }
            {
              timeout = suspendTimeout;
              on-timeout = "systemctl suspend";
            }
          ];
        };
      };
    };
  };
}
