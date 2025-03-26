#!/usr/bin/env bash

isCommand() {
    case "$1" in
    init | install | update | list | lock | uninstall | show | edit)
        return 0
        ;;
    *)
        echo "Unknown command '$1'"
        exit 1
        ;;
    esac

}

cmd=()

# check if the first argument passed in looks like a flag
if [[ "$1" == -* ]]; then
    cmd=(gitman "$@")
# check if the first argument passed in is gitman
elif [ "$1" = 'gitman' ]; then
    cmd=("$@")
# check if the first argument passed in matches a known command; (init|install|update|list|lock|uninstall|show|edit)
elif [[ "$1" =~ ^(init|install|update|list|lock|uninstall|show|edit)$ ]]; then
    cmd=(gitman "$@")
# check if being invoked from GitHub Actions
elif [[ "$1" == 'install-github-action' ]]; then
    # install-github-action passes in arguments as positional arguments
    # 1. quiet
    # 2. verbose
    # 3. root-dir
    # 4. depth
    # 5. no-scripts

    opts=()

    shift

    if [[ "$1" == 'true' ]]; then
        opts+=('--quiet')
    fi

    if [[ "$2" == 'true' ]]; then
        opts+=('--verbose')
    fi

    if [[ -n "$3" ]]; then
        opts+=('--root' "$3")
    fi

    if [[ -n "$4" ]]; then
        opts+=('--depth' "$4")
    fi

    if [[ "$5" == 'true' ]]; then
        opts+=('--no-scripts')
    fi

    cmd=(gitman install "${opts[@]}")

    # When run under GitHub Actions, the default working directory is the repository root
    # See https://docs.github.com/en/actions/sharing-automations/creating-actions/dockerfile-support-for-github-actions#workdir
    # Use `root-dir` to change the root directory used by gitman.
    PROJECT_DIR=.
fi

# Check if cmd is empty
if [[ ${#cmd[@]} -eq 0 ]]; then
    echo "Invalid command - $1"
    exit 1
fi

: "${PROJECT_DIR:=/project}"
# check if PROJECT_DIR is not the current directory; if not, change into it
if [[ "$PROJECT_DIR" != '.' ]]; then
    if ! cd "$PROJECT_DIR"; then
        echo "Cannot change directory into '$PROJECT_DIR'"
        exit 1
    fi
fi

export GITMAN_CACHE="${GITMAN_CACHE:=/tmp}"
exec "${cmd[@]}"
