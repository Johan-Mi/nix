{ disko, username, ... }:

{
  imports = [
    disko.nixosModules.disko
  ];

  disko.devices = {
    disk = {
      main = {
        device = "/dev/nvme0n1";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              type = "EF00";
              size = "500M";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };
    };
  };

  networking.hostName = "tyko";

  services.openssh.enable = true;

  users.users.${username}.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDaFIEJQckUBYm+rXj/QOw2BEa4XVO/FQ1AIaR2vQsv3t0a+FXF9yJOhLcXIDAwwZWAeY/j0ciOpG6pIz/SbrP7ed5OKgIqltmyBezx9m4naqbhUNKnVQkJf90VB9KyiRIgOFpjv4r7CjRCYv2owxje2iaoD22Fd+NU6dwdhHr4+ny1u5dgJ1ACLfUXj8Zio/D5/Qpru2eyqk5BZDg6lZxahgShYsDTiKrRMshE3UcmrdG5KY1Zt3apzCaL+lK9qcKopm8SXmtmW2p5TSvqVYlLBRDhWJ9YZO35ZijcsUtCB6zIk4xE5j0/Z5hyPDZpZQihJKzFwIms+KDzUENm82luKtNNcNRkS5T/3pfWSiP0+jAhUsTU0y0rMZ/18gLc+mIrXRajvm5DbeDAfJ88sVRFvgabFeD2YONLCUWf6iGZ1m7oTtkoIANiRFCvOnNloidkK/r0Qwh2KqxGauFtQvRd1LHW2NJQBbNmS1RKOeA862Z5cbt/mJykp9PP0pJv1EE= johanmi@e14g6"
  ];

  system.stateVersion = "26.05";
}
