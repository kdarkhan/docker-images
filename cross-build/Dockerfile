FROM agners/archlinuxarm-arm64v8

ENV PATH="/opt/bin:${PATH}"

RUN pacman -Syu base-devel --noconfirm python wget neovim pigz pbzip2 --needed

RUN groupadd users && \
    useradd -ms /bin/bash builder && \
    # enable sudo for user builder
    echo -e '\n\nbuilder ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers


WORKDIR /home/builder

# Install fakeroot-tcp
ADD silence-dlerror.patch /home/builder
RUN wget http://ftp.debian.org/debian/pool/main/f/fakeroot/fakeroot_1.24.orig.tar.gz && \
    tar xf fakeroot_1.24.orig.tar.gz && \
    cd fakeroot-1.24 && \
    patch -p1 -i /home/builder/silence-dlerror.patch && \
    ./bootstrap && \
    ./configure --prefix=/opt \
        --libdir=/usr/lib/libfakeroot \
        --disable-static \
        --with-ipc=tcp && \
    make -j $(nproc) && \
    make DESTDIR=/ install && \
    echo '/usr/lib/libfakeroot' > /etc/ld.so.conf.d/fakeroot.conf

RUN sed -i "s,#MAKEFLAGS=\"-j2\",MAKEFLAGS=\"-j$(nproc)\",g" /etc/makepkg.conf && \
    sed -i 's,COMPRESSXZ=(xz -c -z -),COMPRESSXZ=(xz -c -z - --threads=0),g' /etc/makepkg.conf && \
    sed -i 's,COMPRESSGZ=(gzip -c -f -n),COMPRESSGZ=(pigz -c -f -n),g' /etc/makepkg.conf && \
    sed -i 's,COMPRESSBZ2=(bzip2 -c -f),COMPRESSBZ2=(pbzip2 -c -f),g' /etc/makepkg.conf && \
    sed -i 's,COMPRESSZST=(zstd -c -z -q -),COMPRESSZST=(zstd -c -z -q - --threads=0),g' /etc/makepkg.conf


USER builder

# Install aurutils
# RUN cd /home/builder && \
#     wget https://aur.archlinux.org/cgit/aur.git/snapshot/aurutils-git.tar.gz && \
#     tar xf aurutils-git.tar.gz && \
#     cd aurutils-git && \
#     makepkg -si --noconfirm

# Install yay
RUN cd /home/builder && \
    wget https://aur.archlinux.org/cgit/aur.git/snapshot/yay.tar.gz && \
    tar xf yay.tar.gz && \
    cd yay && \
    makepkg -si --noconfirm


CMD /bin/bash
