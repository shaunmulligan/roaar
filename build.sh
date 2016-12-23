#!/bin/bash
set -e; set -o pipefail

function say()
{
	echo "$@">&2
}

function usage()
{
	say "usage: $0 <opts>"
	say
	say "       $0 will build your rust code on your local machine and spitout a binary into /artifacts."
	say
	say "       options:"
	say
	say "         --unsafe     - attempt to fix device unconditionally. WARNING: May break device."

	exit 1
}

unsafe=0
while [[ $# -gt 0 ]]; do
	case $1 in
		"--unsafe")
			unsafe=1
			;;
		*)
			# Unknown option.
			(! [[ "$1" =~ ^- ]]) || usage

			break
			;;
	esac
	shift
done

if [ $unsafe -eq 1 ]
then
	# Build a container in an armv7 emulated one, which allows you to link against some C libraries.
	echo "Building for unsafe code with linked C libraries"
	# Build our armv7 image with the rust toolchain and our dependencies we need to link against
	docker build --tag arm7_rust_builder_unsafe --file Dockerfile.build_unsafe .
	docker run -it --rm \
    --volume="$PWD:/build" \
    arm7_rust_builder_unsafe /usr/bin/qemu-arm-static /root/.cargo/bin/cargo build

    #Copy the binary into our release folder so it can be bundled into the runtime container
    cp target/debug/my_project release/rust-bin

else
	# Cross compile rust the regular way, this will only work with pure rust libraries.
	echo "Building pure rust stuff"
	docker build --tag arm7_rust_builder --file Dockerfile.build .
	docker run -it --rm \
	--volume="$PWD:/build" \
	arm7_rust_builder cargo build --target=armv7-unknown-linux-gnueabihf

	#Copy the binary into our release folder  so it can be bundled into the runtime container
	cp target/armv7-unknown-linux-gnueabihf/debug/my_project release/rust-bin
fi