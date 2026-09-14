#!/usr/bin/env bash

# Category definitions: id|label|default_on (1 or 0)
CATALOG_CATEGORIES=(
    "base_os|Base OS|1"
    "dev|Dev tools|0"
    "ai|AI worker|0"
    "apps|Apps|0"
    "multimedia|Multimedia|0"
    "wine|Wine|0"
    "network|Network / firewall|0"
    "games|Games|0"
    "nonfree|Non-free|0"
    "legacy|Legacy|0"
)

# Script definitions: id|category|path|label|default_on
# Order in this array is execution order.
CATALOG_SCRIPTS=(
    "presetup|base_os|os/presetup.sh|Presetup (gnome-terminal)|1"
    "extra|base_os|os/extra.sh|OS tweaks (GNOME, lid, kernels)|1"
    "shrink|base_os|os/shrink.sh|Shrink OS (remove bloat)|1"
    "hotkeys|base_os|os/hotkeys.sh|Custom keyboard shortcuts|1"
    "git|dev|dev/git.sh|Git setup|1"
    "gcc|dev|dev/gcc.sh|GCC toolchain|1"
    "gpu|dev|dev/gpu.sh|GPU drivers (CUDA/ROCm)|1"
    "keyd|dev|dev/keyd.sh|Keyd remapping|1"
    "java|dev|dev/java.sh|Java|0"
    "javascript|dev|dev/javascript.sh|JavaScript (Node.js)|0"
    "docker|dev|dev/docker.sh|Docker|0"
    "claude|dev|dev/claude.sh|Claude CLI|0"
    "macro_buttons|dev|dev/macro_buttons.sh|Macro buttons|0"
    "gpu_ai|ai|dev/gpu.sh|GPU drivers (CUDA/ROCm)|1"
    "ollama|ai|ai/ollama.sh|Ollama|1"
    "autologin|ai|os/autologin.sh|GDM autologin|1"
    "comfyui|ai|ai/comfyui.sh|ComfyUI|0"
    "obs|apps|apps/obs-studio.sh|OBS Studio|1"
    "dropbox|apps|apps/dropbox.sh|Dropbox|0"
    "chromium|apps|apps/chromium.sh|Chromium|0"
    "zoom|apps|apps/zoom.sh|Zoom|0"
    "productivity|apps|apps/productivity.sh|Productivity tools|0"
    "multimedia|multimedia|multimedia/multimedia.sh|Codecs and VLC|1"
    "wine|wine|wine/wine.sh|Wine (manual winetricks steps)|1"
    "local_firewall|network|network/local-only-firewall.sh|Local-only firewall|0"
    "reset_firewall|network|network/reset-firewall.sh|Reset firewall|0"
    "quake|games|games/quake.sh|Quake (requires Wine)|0"
    "accurig|nonfree|non-free/accurig.sh|AccuRig|0"
    "fireworks|nonfree|non-free/fireworks.sh|Adobe Fireworks|0"
    "adobe_flash|legacy|legacy/adobe_flash.sh|Adobe Flash|0"
    "heroku|legacy|legacy/heroku.sh|Heroku CLI|0"
    "opengl|legacy|legacy/opengl.sh|OpenGL|0"
    "rpm_fusion|legacy|legacy/rpm_fusion.sh|RPM Fusion|0"
)

# Script ids that map to the same underlying path (for deduplication)
CATALOG_SCRIPT_PATH_FOR_ID() {
    local script_id="$1"
    for entry in "${CATALOG_SCRIPTS[@]}"; do
        local id="${entry%%|*}"
        if [[ "$id" == "$script_id" ]]; then
            local rest="${entry#*|}"
            local _category="${rest%%|*}"
            rest="${rest#*|}"
            echo "${rest%%|*}"
            return 0
        fi
    done
    return 1
}

# Get script path for a given id
catalog_get_script_path() {
    local script_id="$1"
    CATALOG_SCRIPT_PATH_FOR_ID "$script_id"
}

# Get all script ids for given category ids (space-separated)
catalog_scripts_for_categories() {
    local category_ids=("$@")
    local entry
    for entry in "${CATALOG_SCRIPTS[@]}"; do
        local id="${entry%%|*}"
        local rest="${entry#*|}"
        local category="${rest%%|*}"
        local cat
        for cat in "${category_ids[@]}"; do
            if [[ "$category" == "$cat" ]]; then
                echo "$id"
                break
            fi
        done
    done
}

# Build script menu items for given script ids (deduped by path)
catalog_build_script_items() {
    local -n result_ref=$1
    shift
    local script_ids=("$@")
    result_ref=()
    local seen_paths=()
    local entry
    for entry in "${CATALOG_SCRIPTS[@]}"; do
        local id="${entry%%|*}"
        local sid
        for sid in "${script_ids[@]}"; do
            if [[ "$id" == "$sid" ]]; then
                local rest="${entry#*|}"
                rest="${rest#*|}"
                local path="${rest%%|*}"
                rest="${rest#*|}"
                local label="${rest%%|*}"
                local seen=0
                local p
                for p in "${seen_paths[@]}"; do
                    if [[ "$p" == "$path" ]]; then
                        seen=1
                        break
                    fi
                done
                if (( seen == 0 )); then
                    seen_paths+=("$path")
                    result_ref+=("$id|$label")
                fi
                break
            fi
        done
    done
}

# Initialize default selections for categories
catalog_init_category_defaults() {
    local -n selected_ref=$1
    selected_ref=()
    local entry
    for entry in "${CATALOG_CATEGORIES[@]}"; do
        local id="${entry%%|*}"
        local rest="${entry#*|}"
        rest="${rest#*|}"
        local default_on="${rest%%|*}"
        selected_ref[$id]="$default_on"
    done
}

# Initialize default selections for scripts given script ids (deduped by path)
catalog_init_script_defaults() {
    local -n selected_ref=$1
    shift
    local script_ids=("$@")
    selected_ref=()
    local seen_paths=()
    local entry
    for entry in "${CATALOG_SCRIPTS[@]}"; do
        local id="${entry%%|*}"
        local sid
        for sid in "${script_ids[@]}"; do
            if [[ "$id" == "$sid" ]]; then
                local rest="${entry#*|}"
                rest="${rest#*|}"
                local path="${rest%%|*}"
                rest="${rest#*|}"
                rest="${rest#*|}"
                local default_on="${rest}"
                local seen=0
                local p
                for p in "${seen_paths[@]}"; do
                    if [[ "$p" == "$path" ]]; then
                        seen=1
                        break
                    fi
                done
                if (( seen == 0 )); then
                    seen_paths+=("$path")
                    selected_ref[$id]="$default_on"
                fi
                break
            fi
        done
    done
}

# Deduplicate selected script ids by path, preserving order
catalog_dedupe_by_path() {
    local script_ids=("$@")
    local seen_paths=()
    local result=()
    local entry
    for entry in "${CATALOG_SCRIPTS[@]}"; do
        local id="${entry%%|*}"
        local sid
        for sid in "${script_ids[@]}"; do
            if [[ "$id" == "$sid" ]]; then
                local rest="${entry#*|}"
                rest="${rest#*|}"
                local path="${rest%%|*}"
                local seen=0
                local p
                for p in "${seen_paths[@]}"; do
                    if [[ "$p" == "$path" ]]; then
                        seen=1
                        break
                    fi
                done
                if (( seen == 0 )); then
                    seen_paths+=("$path")
                    result+=("$id")
                fi
                break
            fi
        done
    done
    printf '%s\n' "${result[@]}"
}

# Reorder: base_os scripts first, wine last, rest in catalog order
catalog_order_for_execution() {
    local script_ids=("$@")
    local base_os_ids=()
    local wine_ids=()
    local other_ids=()
    local entry
    for entry in "${CATALOG_SCRIPTS[@]}"; do
        local id="${entry%%|*}"
        local sid
        for sid in "${script_ids[@]}"; do
            if [[ "$id" == "$sid" ]]; then
                local rest="${entry#*|}"
                local category="${rest%%|*}"
                if [[ "$category" == "base_os" ]]; then
                    base_os_ids+=("$id")
                elif [[ "$category" == "wine" ]]; then
                    wine_ids+=("$id")
                else
                    other_ids+=("$id")
                fi
                break
            fi
        done
    done
    printf '%s\n' "${base_os_ids[@]}" "${other_ids[@]}" "${wine_ids[@]}"
}
