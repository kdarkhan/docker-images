I use this docker image to cross-build [AUR](https://aur.archlinux.org/) packages
using yay for arm64 Android device from my amd64 machine.

A weird workaround is needed to compile `fakeroot` from source
because the default IPC communication is not supported by
ARM docker image.
