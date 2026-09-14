#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/lib/ui.sh"
source "$SCRIPT_DIR/lib/catalog.sh"

GIT_USER_EMAIL=""
GIT_USER_NAME=""

build_category_items() {
    CATEGORY_ITEMS=()
    local entry
    for entry in "${CATALOG_CATEGORIES[@]}"; do
        local id="${entry%%|*}"
        local rest="${entry#*|}"
        local label="${rest%%|*}"
        CATEGORY_ITEMS+=("$id|$label")
    done
}

collect_selected_script_ids() {
    local ids=()
    local id
    while IFS= read -r id; do
        [[ -n "$id" ]] && ids+=("$id")
    done < <(get_selected_ids SCRIPT_SELECTED)
    printf '%s\n' "${ids[@]}"
}

ensure_wine_for_quake() {
    local ids=("$@")
    local has_quake=0
    local has_wine=0
    local id
    for id in "${ids[@]}"; do
        if [[ "$id" == "quake" ]]; then
            has_quake=1
        fi
        if [[ "$id" == "wine" ]]; then
            has_wine=1
        fi
    done
    if (( has_quake == 1 && has_wine == 0 )); then
        ids+=("wine")
    fi
    printf '%s\n' "${ids[@]}"
}

prompt_git_credentials() {
    echo ""
    read -rp "Git email: " GIT_USER_EMAIL
    read -rp "Git name: " GIT_USER_NAME
    if [[ -z "$GIT_USER_EMAIL" || -z "$GIT_USER_NAME" ]]; then
        echo "Git email and name are required when Git setup is selected."
        exit 1
    fi
}

run_script() {
    local script_id="$1"
    local path
    path="$(catalog_get_script_path "$script_id")"
    local full_path="$SCRIPT_DIR/$path"

    if [[ ! -f "$full_path" ]]; then
        echo "Warning: script not found: $full_path"
        return 1
    fi

    echo ""
    echo "========================================"
    echo "Running: $path"
    echo "========================================"

    if [[ "$script_id" == "git" ]]; then
        bash "$full_path" "$GIT_USER_EMAIL" "$GIT_USER_NAME"
    else
        bash "$full_path"
    fi
}

main() {
    declare -A CATEGORY_SELECTED=()
    declare -A SCRIPT_SELECTED=()

    build_category_items
    catalog_init_category_defaults CATEGORY_SELECTED

    if ! checkbox_menu "Select installation categories" CATEGORY_ITEMS CATEGORY_SELECTED; then
        echo "Cancelled."
        exit 0
    fi

    local selected_categories=()
    local cat_id
    while IFS= read -r cat_id; do
        [[ -n "$cat_id" ]] && selected_categories+=("$cat_id")
    done < <(get_selected_ids CATEGORY_SELECTED)

    if ((${#selected_categories[@]} == 0)); then
        echo "Nothing selected. Exiting."
        exit 0
    fi

    local script_ids=()
    local sid
    while IFS= read -r sid; do
        [[ -n "$sid" ]] && script_ids+=("$sid")
    done < <(catalog_scripts_for_categories "${selected_categories[@]}")

    catalog_init_script_defaults SCRIPT_SELECTED "${script_ids[@]}"

    local script_items=()
    catalog_build_script_items script_items "${script_ids[@]}"

    if ! checkbox_menu "Select scripts to install" script_items SCRIPT_SELECTED; then
        echo "Cancelled."
        exit 0
    fi

    local selected_scripts=()
    while IFS= read -r sid; do
        [[ -n "$sid" ]] && selected_scripts+=("$sid")
    done < <(get_selected_ids SCRIPT_SELECTED)

    if ((${#selected_scripts[@]} == 0)); then
        echo "Nothing selected. Exiting."
        exit 0
    fi

    local needs_git=0
    for sid in "${selected_scripts[@]}"; do
        if [[ "$sid" == "git" ]]; then
            needs_git=1
            break
        fi
    done

    if (( needs_git == 1 )); then
        prompt_git_credentials
    fi

    local deduped=()
    while IFS= read -r sid; do
        [[ -n "$sid" ]] && deduped+=("$sid")
    done < <(catalog_dedupe_by_path "${selected_scripts[@]}")

    local with_wine=()
    while IFS= read -r sid; do
        [[ -n "$sid" ]] && with_wine+=("$sid")
    done < <(ensure_wine_for_quake "${deduped[@]}")

    local ordered=()
    while IFS= read -r sid; do
        [[ -n "$sid" ]] && ordered+=("$sid")
    done < <(catalog_order_for_execution "${with_wine[@]}")

    echo ""
    echo "Installation plan:"
    local run_id
    for run_id in "${ordered[@]}"; do
        echo "  - $(catalog_get_script_path "$run_id")"
    done
    echo ""
    read -rp "Proceed? [y/N] " confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        echo "Cancelled."
        exit 0
    fi

    for run_id in "${ordered[@]}"; do
        run_script "$run_id"
    done

    echo ""
    echo "Installation complete."
}

main "$@"
