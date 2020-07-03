#!/bin/bash

# assuming image is built with
# docker build -t cross-build-arm .

# binfmt_misc registration should be done with this
# docker run --rm --privileged multiarch/qemu-user-static --reset -p yes --credential yes

# Mount yay cache so that we don't have to extract packages built by yay manually
# Example, building [neovim-git](https://aur.archlinux.org/packages/neovim-git/)
#   `yay neovim-git` from the docker guest.
# The built package will be available in host dir `yay-cache/neovim-git`
docker run --rm -v "$(pwd)/yay-cache:/home/builder/.cache/yay" -it cross-build-arm
