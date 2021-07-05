FROM ubuntu:bionic
ARG VERSION=1.4.0

LABEL maintainer="Thomas Nilefalk <thomas@nilefalk.se>"

ENV TZ=Europe/Stockholm
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

WORKDIR /home/cgreen-devs

# Make sure the package repository is up to date.
RUN apt-get update && \
    apt-get -qy full-upgrade && \
    apt-get install -qy git && \
# Install build tools
    apt-get install -qy build-essential make cmake && \
# Cleanup old packages
    apt-get -qy autoremove

# First build and install Cgreen
RUN git clone https://github.com/cgreen-devs/cgreen && \
    cd cgreen && \
    git checkout ${VERSION} && \
    make all install

# Then install it for packaging
RUN cd cgreen/build && \
    cmake -DCMAKE_INSTALL_PREFIX:Path=../../cgreen_${VERSION}_amd64 .. && make install

RUN cd cgreen_${VERSION}_amd64 && \
    mkdir DEBIAN && \
    printf '%s\n' \
    'Package: cgreen' \
    > DEBIAN/control && \
    printf 'Version: %s\n' ${VERSION} \
    >> DEBIAN/control && \
    printf '%s\n' \
    'Section: tools' \
    'Architecture: amd64' \
    'Priority: optional' \
    'Maintainer: Thomas Nilefalk <thomas@nilefalk.se>' \
    'Build-Depends: cmake, debhelper-compat (= 12)' \
    'Standards-Version: 4.5.0' \
    'Homepage: https://github.com/cgreen-devs/cgreen' \
    'Rules-Requires-Root: no' \
    'Description: Cgreen unit and mocking library for C and C++' \
    '    - fast build, clean code, highly portable' \
    '    - simple auto-discovery of tests' \
    '    - fluent, expressive and readable API' \
    '    - each test runs in isolation to prevent cross-test dependencies' \
    '    - built-in mocking for C, compatible other C++ mocking libraries' \
    >> DEBIAN/control

RUN dpkg-deb --build cgreen_${VERSION}_amd64
