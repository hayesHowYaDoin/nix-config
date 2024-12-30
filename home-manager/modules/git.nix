{ 
  programs.git = {
    enable = true;
    userName = "hayesHowYaDoin";
    userEmail = "jordanhayes98@gmail.com";
    config = { 
        credential.helper = "libsecret";
    };
  };
}

