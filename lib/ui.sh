#!/usr/bin/env bash

UI_ORIGINAL_STTY=""

ui_cleanup() {
    if [[ -n "$UI_ORIGINAL_STTY" ]]; then
        stty "$UI_ORIGINAL_STTY"
    fi
}

ui_init() {
    UI_ORIGINAL_STTY=$(stty -g)
    trap ui_cleanup EXIT INT TERM
    stty -echo -icanon min 1 time 0
}

ui_clear_screen() {
    printf '\033[H\033[2J'
}

# checkbox_menu title items_array_name selected_array_name
# items_array_name: array of "id|label" strings
# selected_array_name: associative array name for selected state (1=on, 0=off)
# Returns 0 on confirm, 1 on cancel/empty
checkbox_menu() {
    local title="$1"
    local items_name="$2"
    local selected_name="$3"
    local -n items_ref="$items_name"
    local -n selected_ref="$selected_name"

    local count=${#items_ref[@]}
    if (( count == 0 )); then
        return 1
    fi

    local cursor=0
    local key

    ui_init

    while true; do
        ui_clear_screen
        echo "$title"
        echo ""
        echo "  Space: toggle   a: all   n: none   Enter: confirm   q: cancel"
        echo ""

        local i=0
        for item in "${items_ref[@]}"; do
            local id="${item%%|*}"
            local label="${item#*|}"
            local marker=" "
            if [[ "${selected_ref[$id]:-0}" == "1" ]]; then
                marker="x"
            fi
            local prefix="  "
            if (( i == cursor )); then
                prefix="> "
            fi
            printf '%s[%s] %s\n' "$prefix" "$marker" "$label"
            i=$((i + 1))
        done

        IFS= read -rsn1 key
        case "$key" in
            $'\x1b')
                read -rsn2 -t 0.1 key
                case "$key" in
                    '[A'|'OA')
                        cursor=$(( (cursor - 1 + count) % count ))
                        ;;
                    '[B'|'OB')
                        cursor=$(( (cursor + 1) % count ))
                        ;;
                esac
                ;;
            ' '|$'\x20')
                local current_item="${items_ref[$cursor]}"
                local current_id="${current_item%%|*}"
                if [[ "${selected_ref[$current_id]:-0}" == "1" ]]; then
                    selected_ref[$current_id]=0
                else
                    selected_ref[$current_id]=1
                fi
                ;;
            'a'|'A')
                for item in "${items_ref[@]}"; do
                    local id="${item%%|*}"
                    selected_ref[$id]=1
                done
                ;;
            'n'|'N')
                for item in "${items_ref[@]}"; do
                    local id="${item%%|*}"
                    selected_ref[$id]=0
                done
                ;;
            ''|$'\n'|$'\r')
                ui_cleanup
                trap - EXIT INT TERM
                return 0
                ;;
            'q'|'Q')
                ui_cleanup
                trap - EXIT INT TERM
                return 1
                ;;
            'j'|'J')
                cursor=$(( (cursor + 1) % count ))
                ;;
            'k'|'K')
                cursor=$(( (cursor - 1 + count) % count ))
                ;;
        esac
    done
}

# Returns selected ids (one per line) from associative array
get_selected_ids() {
    local selected_name="$1"
    local -n selected_ref="$selected_name"
    local id
    for id in "${!selected_ref[@]}"; do
        if [[ "${selected_ref[$id]}" == "1" ]]; then
            echo "$id"
        fi
    done
}
