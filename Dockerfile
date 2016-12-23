# Use the debian base if you want run ./build --unsafe
#FROM resin/armv7hf-debian:jessie
# Use alpine if you want a way smaller runtime image, but things get more difficult with linked C libraries:
FROM ctarwater/armhf-alpine-rpi-glibc:latest

COPY /release/ /release/
CMD /release/rust-bin 