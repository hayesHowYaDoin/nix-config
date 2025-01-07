{ user, ...}:

{ 
  programs.git = {
    enable = true;
    userName = "${user.gitUser}";
    userEmail = "${user.email}";
  };
}

