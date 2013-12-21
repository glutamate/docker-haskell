# This file creates a container with the GHC Haskell Platform
# installed and ready to use.
#
# Author: Martin Rehfeld 
# forked with thanks, from https://github.com/martinrehfeld/docker-haskell-platform
# Date: 09/05/2013 

FROM ubuntu
MAINTAINER Tom Nielsen <tomn@openbrain.org>

RUN sed 's/main$/main universe/' -i /etc/apt/sources.list
RUN apt-get update
RUN apt-get upgrade -y # DATE: 2013-09-05
ENV DEBIAN_FRONTEND noninteractive

# Installing the required packages
RUN apt-get install -y build-essential libedit2 libglu1-mesa-dev libgmp3-dev libgmp3c2 zlib1g-dev freeglut3-dev wget

# Download and extract GHC and the Haskell Platform
RUN wget -q http://www.haskell.org/ghc/dist/7.6.3/ghc-7.6.3-x86_64-unknown-linux.tar.bz2
RUN tar xjf ghc-7.6.3-x86_64-unknown-linux.tar.bz2
RUN rm ghc-7.6.3-x86_64-unknown-linux.tar.bz2

RUN wget -q http://hackage.haskell.org/package/cabal-install-1.18.0.2/cabal-install-1.18.0.2.tar.gz
RUN tar xzf cabal-install-1.18.0.2.tar.gz
RUN rm cabal-install-1.18.0.2.tar.gz

# Build and install GHC
RUN cd ghc-7.6.3; ./configure && make install

# Build and install the Haskell Platform
RUN cd cabal-install-1.18.0.2; ./bootstrap.sh

# Clean up build files
RUN rm -rf ghc-7.6.3 cabal-install-1.18.0.2

ENV PATH /.cabal/bin:$PATH

RUN echo $PATH

# Update Hackage package list and cabal-install
RUN cabal update

