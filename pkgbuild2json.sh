#!/bin/bash

usage() {
    cat <<EOF >&2
usage: $0 <pkgbuild>

Convert the metadata in a pkgbuild file to json.

Positional Arguments:
    pkgbuild: Path to a PKGBUILD file.
EOF
}

error() {
    echo "$0: error: $*" >&2
    exit 1
}

# Trim whitespace from strings.
trim() {
    echo -e "${1}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'
}

# Convert a Bash array to a JSON array.
toArray() {
    # Make $arr a reference to the variabl named by $1
declare -n arr="$1"
    if [ "$arr" = "" ]; then
        # Variable is empty
        echo '[]'
    else
        printf "%s\n" "${arr[@]}" | jq -R . | jq -s .
    fi
}

main() {
    if [ "$#" -lt 1 ]; then
        usage
        exit 1
    elif [ -f "$1" ] && [ -r "$1" ]; then
        PKGBUILD="$1"
        # PKGBUILD is readable
        # Read the maintainer info (if any)
        declare -a maintainers=()
        while read maintainer_text; do
                maintainer_name="$(echo "$maintainer_text" | cut -d: -f2 | cut -d '<' -f1)"
                maintainer_email="$(echo "$maintainer_text" | cut -d '<' -f2 | cut -d '>' -f1)"
                maintainers+=("$(jq -n \
                    --arg name "$(trim "$maintainer_name")" \
                    --arg email "$(trim "$maintainer_email")" \
                    '{"name": $name, "email": $email}')")
            done < <(grep '\# Maintainer: .\+ <.\+@.\+>' "$PKGBUILD")
                if [ "${#maintainers[@]}" -gt 0 ]; then
            maintainers_json="$(printf "%s\n" "${maintainers[@]}" | jq -s .)"
        else
            maintainers_json='[]'
                fi

            # Source the PKGBUILD to get the rest of the variables
        source "$PKGBUILD" || error "Failed to source $1."

        # Convert the arrays to json
        pkg_name="$(toArray pkgname)"
        pkg_arch="$(toArray arch)"
        pkg_license="$(toArray license)"
        pkg_groups="$(toArray groups)"
        pkg_depends="$(toArray depends)"
        pkg_makedepends="$(toArray makedepends)"
        pkg_checkdepends="$(toArray checkdepends)"
        pkg_optdepends="$(toArray optdepends)"
        pkg_provides="$(toArray provides)"
        pkg_conflicts="$(toArray conflicts)"
        pkg_replaces="$(toArray replaces)"
        pkg_backup="$(toArray backup)"
        pkg_options="$(toArray options)"
        pkg_source="$(toArray source)"
        pkg_noextract="$(toArray noextract)"
        pkg_md5sums="$(toArray md5sums)"
        pkg_validpgpkeys="$(toArray validpgpkeys)"

# Output the converted JSON
jq -n \
    --argjson maintainers "$maintainers_json" \
        --argjson name "$pkg_name" \
        --arg version "$pkgver" \
        --arg release "$pkgrel" \
        --arg epoch "$epoch" \
        --arg desc "$pkgdesc" \
        --argjson arch "$pkg_arch" \
        --argjson license "$pkg_license" \
        --arg url "$url" \
        --argjson groups "$pkg_groups" \
        --argjson depends "$pkg_depends" \
        --argjson makedepends "$pkg_makedepends" \
        --argjson checkdepends "$pkg_checkdepends" \
        --argjson optdepends "$pkg_optdepends" \
        --argjson provides "$pkg_provides" \
        --argjson conflicts "$pkg_conflicts" \
        --argjson replaces "$pkg_replaces" \
        --argjson backup "$pkg_backup" \
        --argjson options "$pkg_options" \
        --arg install "$install" \
        --arg changelog "$changelog" \
        --argjson source "$pkg_source" \
        --argjson noextract "$pkg_noextract" \
        --argjson md5sums "$pkg_md5sums" \
        --argjson validpgpkeys "$pkg_validpgpkeys" \
                    '{
    "maintainers": $maintainers,
        "name": $name,
        "version": $version,
        "release": $release,
        "epoch": $epoch,
        "desc": $desc,
        "arch": $arch,
        "url": $url,
        "license": $license,
        "groups": $groups,
        "depends": $depends,
        "makedepends": $makedepends,
        "checkdepends": $checkdepends,
        "optdepends": $optdepends,
        "provides": $provides,
        "conflicts": $conflicts,
        "replaces": $replaces,
        "backup": $backup,
        "options": $options,
        "install": $install,
        "changelog": $changelog,
        "source": $source,
        "noextract": $noextract,
        "md5sums": $md5sums,
        "validpgpkeys": $validpgpkeys
    }'
    else
        error "$1 is not a readable file."
    fi
}

main $*
