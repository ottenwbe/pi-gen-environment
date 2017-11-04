FROM ubuntu:16.04
RUN apt update
RUN apt install -y sudo git ruby ruby-dev build-essential \
        quilt parted realpath qemu-user-static debootstrap zerofree pxz zip \
        dosfstools bsdtar libcap2-bin grep rsync xz-utils fakeroot curl vim
CMD ["/sbin/init"]