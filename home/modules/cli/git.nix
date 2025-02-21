{ user, ... }:

{
  programs.git = {
    enable = true;
    lfs.enable = true;
    userName = "${user.gitUser}";
    userEmail = "${user.email}";
  };
}

