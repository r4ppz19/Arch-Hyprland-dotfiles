#!/usr/bin/bash

set -o noclobber -o noglob -o nounset -o pipefail
IFS=$'\n'

## If the option `use_preview_script` is set to `true`,
## then this script will be called and its output will be displayed in ranger.
## ANSI color codes are supported.
## STDIN is disabled, so interactive scripts won't work properly

## This script is considered a configuration file and must be updated manually.
## It will be left untouched if you upgrade ranger.

## Because of some automated testing we do on the script #'s for comments need
## to be doubled up. Code that is commented out, because it's an alternative for
## example, gets only one #.

## Meanings of exit codes:
## code | meaning    | action of ranger
## -----+------------+-------------------------------------------
## 0    | success    | Display stdout as preview
## 1    | no preview | Display no preview at all
## 2    | plain text | Display the plain content of the file
## 3    | fix width  | Don't reload when width changes
## 4    | fix height | Don't reload when height changes
## 5    | fix both   | Don't ever reload
## 6    | image      | Display the image `$IMAGE_CACHE_PATH` points to as an image preview
## 7    | image      | Display the file directly as an image

## Script arguments
FILE_PATH="${1}"
PV_WIDTH="${2}"
PV_HEIGHT="${3}"
IMAGE_CACHE_PATH="${4}"
PV_IMAGE_ENABLED="${5}"

FILE_EXTENSION_LOWER="$(printf "%s" "${FILE_PATH##*.}" | tr '[:upper:]' '[:lower:]')"

## Settings
HIGHLIGHT_SIZE_MAX=262143
HIGHLIGHT_TABWIDTH=${HIGHLIGHT_TABWIDTH:-8}
HIGHLIGHT_STYLE=${HIGHLIGHT_STYLE:-pablo}
HIGHLIGHT_OPTIONS="--replace-tabs=${HIGHLIGHT_TABWIDTH} --style=${HIGHLIGHT_STYLE} ${HIGHLIGHT_OPTIONS:-}"
PYGMENTIZE_STYLE=${PYGMENTIZE_STYLE:-autumn}

handle_extension() {
    case "${FILE_EXTENSION_LOWER}" in
        pdf)
            pdftotext -l 10 -nopgbrk -q -- "${FILE_PATH}" - | fmt -w "${PV_WIDTH}" && exit 5
            mutool draw -F txt -i -- "${FILE_PATH}" 1-10 | fmt -w "${PV_WIDTH}" && exit 5
            exiftool "${FILE_PATH}" && exit 5
            exit 1;;
        json)
            jq --color-output . "${FILE_PATH}" && exit 5
            python -m json.tool -- "${FILE_PATH}" && exit 5
            exit 1;;
        torrent)
            transmission-show -- "${FILE_PATH}" && exit 5
            exit 1;;
    esac
}

handle_image() {
    local mimetype="${1}"
    case "${mimetype}" in
        image/*)
            convert -- "${FILE_PATH}" -auto-orient "${IMAGE_CACHE_PATH}" && exit 6
            exit 7;;
    esac
}

handle_mime() {
    local mimetype="${1}"
    case "${mimetype}" in
        text/* | */xml)
            if [[ "$(stat --printf='%s' -- "${FILE_PATH}")" -gt "${HIGHLIGHT_SIZE_MAX}" ]]; then
                exit 2
            fi
            if [[ "$(tput colors)" -ge 256 ]]; then
                local pygmentize_format='terminal256'
                local highlight_format='xterm256'
            else
                local pygmentize_format='terminal'
                local highlight_format='ansi'
            fi
            env HIGHLIGHT_OPTIONS="${HIGHLIGHT_OPTIONS}" highlight --out-format="${highlight_format}" --force -- "${FILE_PATH}" && exit 5
            env COLORTERM=8bit bat --color=always --style="plain" -- "${FILE_PATH}" && exit 5
            pygmentize -f "${pygmentize_format}" -O "style=${PYGMENTIZE_STYLE}" -- "${FILE_PATH}" && exit 5
            exit 2;;
    esac
}

handle_fallback() {
    file --dereference --brief -- "${FILE_PATH}" && exit 5
    exit 1
}

MIMETYPE="$(file --dereference --brief --mime-type -- "${FILE_PATH}")"
if [[ "${PV_IMAGE_ENABLED}" == 'True' ]]; then
    handle_image "${MIMETYPE}"
fi
handle_extension
handle_mime "${MIMETYPE}"
handle_fallback

exit 1