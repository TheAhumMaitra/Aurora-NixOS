{
  description = "Aurora Flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    hyprland.url = "github:hyprwm/Hyprland";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      hyprland,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = {
          inherit hyprland;
        };

        modules = [
          ./configuration.nix

          home-manager.nixosModules.home-manager

          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.ahummaitra = ./home.nix;
          }
        ];
      };

      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          rustup

          gcc
          gnumake
          binutils
          clang
          llvm
          lld

          pkg-config
          cmake
          meson
          ninja

          gtk3
          gtk4
          glib
          gobject-introspection
          libadwaita
          pango
          cairo
          gdk-pixbuf
          librsvg
          graphene
          harfbuzz
          libepoxy

          libsoup_3
          json-glib
          libxml2
          libxslt
          openssl
          sqlite
          curl
          zlib
          zstd

          wayland
          wayland-protocols
          libxkbcommon

          xorg.libX11
          xorg.libXext
          xorg.libXcursor
          xorg.libXi
          xorg.libXrandr
          xorg.libXinerama
          xorg.libXfixes
          xorg.libxcb

          mesa
          libGL
          vulkan-loader

          fontconfig
          freetype
          libpng
          libjpeg
          libtiff

          gdb
          lua
          valgrind
          strace
          elfutils
          autoconf
          automake
          libtool

          rofi

        ];
      };
    };
}
