#! /bin/sh
# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# self-cert.sh for ejabberd

openssl=$(which openssl)

[[ -z "${openssl}" ]] && openssl="/usr/bin/openssl"

if ! [[ -x "${openssl}" ]]; then
	echo "openssl required for certificates" >&2
	exit 1
fi

usage() {
	local error="$@"
	
	[[ -z "${error}" ]] || echo -e "Error: ${error}\n"

	cat <<USAGE | expand -t 8
Usage: $0 [options]

Options:
	-h --help		- this message

	-c --config=CONFIG	- use specified openssl config
	-o --output=PEMFILE	- put generated key+cert into PEMFILE
					[default: @SSL_CERT@]

	-f --force		- force overwrite if output already exists

	-r --rand-file=FILE	- use specified random file
	   --rand-source=DEV	- use DEV as source, if generating
	   				random file [defalt: /dev/urandom]
USAGE

	[[ -z "${error}" ]] && exit 0

	exit 1
}

main() {
	local config= output= rnd= rnd_source= force=false

	eval set -- x $(getopt -o c:r:o:hf -l config: -l help -l output: \
				-l force -l rand-file: -l rand-source: -- "$@")
	shift;

	while [[ $# -gt 0 ]]; do
		local arg=$1

		case "${arg}" in
			--help|-h) usage;;
			--force|-f) force=true;;
			--config|-c) config=$2; shift;;
			--output|-o) output=$2; shift;;
			--rand-file|-r) rnd=$2; shift;;
			--rand-source) rnd_source=$2; shift;;
			--) :;;
			*) usage "Bad argument: ${arg}";;
		esac

		shift;
	done

	[[ -z "${config}" ]] && config="@SSL_CONFIG@"
	[[ -z "${output}" ]] && output="@SSL_CERT@"
	[[ -z "${rnd}" ]] && rnd=$(mktemp)

	if [[ -z "${rnd_source}" ]]; then
		[[ -r /dev/urandom ]] && rnd_source=/dev/urandom

		rnd_source=/dev/random
	fi

	[[ -r "${config}" ]] || \
		usage "Config '${config}' not readable"

	[[ -w "${output}" || -w "$(dirname "${output}")" ]] || \
				usage "Output '${output}' not writable"

	[[ -r "${rnd_source}" ]] || \
		usage "rand-source '${rnd_source}' not readble"

	if [[ -f "${output}" ]]; then
		${force} || \
			usage "Output file '${output}' already exists."
	fi

	cp /dev/null "${output}"

	chmod 640 "${output}"
	chown root:jabber "${output}"

	cleanup() {
		local message=$1

		rm -f "${output}" "${rnd}"

		echo "Error: ${message}"
		exit 2
	}

	if ! [[ -r "${rnd}" ]]; then
		[[ -w ${rnd} ]] && \
			usage "No write permission for rand-file: '${rnd}'"

		dd if="${rnd_source}" of="${rnd}" count=1 2>/dev/null
	fi

	"${openssl}" req -new -x509 -days 365 -nodes -config "${config}" \
			-out "${output}" -keyout "${output}" || \
						cleanup "Creating key failed"

	"${openssl}" gendh -rand "${rnd}" 512 >> "${output}" || \
				cleanup "Adding of required extensions failed"

	"${openssl}" x509 -subject -dates -fingerprint \
					-noout -in "${output}" || \
						cleanup "Certificating failed"

	rm -f "${rnd}"

	exit 0
}

main "$@"
