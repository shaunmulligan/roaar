# RoaaR - Rust on an ARMv7 ResinOS Device

This project allows you to develop minimal [rust](https://www.rust-lang.org/en-US/) based containers, which don't require that you push a 900MB+ image to the device with all the toolchain included

## Installation:

This project depends on [rdt - resin device toolbox](https://www.npmjs.com/package/resin-device-toolbox) and [docker](https://docs.docker.com/engine/installation/) so make sure you have both of these installed on your machine. I have also only tested this on Ubuntu 16.10, but I think it should work on OSX as well. 

Once you have your 

## Usage:

### Build

The `build.sh` script allows you to build your rust source code for an armv7 target, it does this by building it all in a docker container on your laptop. It then spits out a bundled up binary into `/release` which you can deploy to a local resinOS device with `rdt` or push to resin.io with git.

The build currently defaults to using [rustup](https://www.rustup.rs/) and a specified armv7 target to crosscompile (see Dockerfile.build). However, there is an option called `--unsafe` which will then build your code in an armv7 emulated container, this allows you to compile and link against C libraries that rust binds to using [ffi](https://doc.rust-lang.org/book/ffi.html)

### Deploy
The `deploy.sh` script allows you to push your runtime container (see Dockerfile) over to a local resinOS device. You will first have to follow the [resinOS getting started guide](https://resinos.io/docs/raspberrypi3/gettingstarted/) to get a device up and running on your local network. 

### Release on resin.io
To push this code to your fleet of resin.io device, you will first need to run `build.sh` to create the binary in `/release`. You then need to add your resin.io Application git remote to this repo and then do `git push resin master`. _Note_: this will build the `Dockerfile` and not the `Dockerfile.build`.

### Injecting Env vars into the ResinOS deployed container
If you want to add some ENV vars to the runtime container the you can specify these in the environment [] section of the .resin-sync.yml file.

## Notes:

### Alpine base image for smaller containers:

Note that if you are using only native rust (i.e. not using --unsafe) and not linking to any C libraries using FFI, then you can most likely switch your the base image in the `Dockerfile` to `FROM ctarwater/armhf-alpine-rpi-glibc:latest` which will result in a container with on disk size of about 21MB, which is pretty awesome.

### Looking in the build container:

`docker run -it --rm --entrypoint=/usr/bin/qemu-arm-static arm7_rust_builder /bin/bash`

## TODO:

* Allow the build script to build a library and its example to deploy.
* Allow `deploy.sh` to accept an IP address or `<hostname>.local` argument, so we can push to different devices.
* Clean up and trim down the Dockerfile.build_unsafe
* create `release.sh` which will push the project to a resin.io fleet of devices.
* Allow the `build.sh` to accept the --release argument so we can make smaller binaries when we wanna ship.