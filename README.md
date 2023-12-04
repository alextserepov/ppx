# Minimalist NixOS image for Contabo VPS

Welcome to the PPX repo dedicated to creating a minimalist NixOS ISO image, specifically designed for installation on Contabo VPS through custom image installation.
This is mainly intended for private use, so no guarantees provided.

## Building the image

To build your NixOS ISO image for Contabo VPS, execute:

nix build .#image.contabo
