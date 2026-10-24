#!/usr/bin/env fish

# add as many directories as you want
set -g query_dirs ~/Documents ~/Pictures ~/Projects ~/Code ~/.local/share/snippets ~/.local/share/dotfiles ~/.config/nvim ~/.config/hypr

if not test -d ~/.cache/find_files
    mkdir -p ~/.cache/find_files
end

set -g dir_cache ~/.cache/find_files

function update_db
    set -l lines_for_dirs_db
    for query_dir in $query_dirs
        if not test -e $query_dir
            continue
        end
        set -l str_to_replace
        set -l replacement
        switch "$query_dir"
            case ~/.local/share/dotfiles
                set str_to_replace "/home/tom/.local/share/dotfiles"
                set replacement "DOTFILES"
            case ~/.local/share/snippets
                set str_to_replace "/home/tom/.local/share/snippets"
                set replacement "SNIPPETS"
            case ~/.config/nvim
                set str_to_replace "/home/tom/.config/nvim"
                set replacement "NVIM"
            case ~/.config/hypr
                set str_to_replace "/home/tom/.config/hypr"
                set replacement "HYPRLAND"
            case ~/Documents
                set str_to_replace "/home/tom/Documents"
                set replacement "DOCS"
            case ~/Pictures
                set str_to_replace "/home/tom/Pictures"
                set replacement "PICS"
            case ~/Projects
                set str_to_replace "/home/tom/Projects"
                set replacement "PROJECTS"
            case ~/Code
                set str_to_replace "/home/tom/Code"
                set replacement "CODE"
            case '*'
                set str_to_replace "/home/tom"
                set replacement "~"
        end

        set -l dir_paths (fd . --type directory $query_dir)
        for dir_path in $dir_paths
            set dir_path (string trim -- "$dir_path")
            if test -d "$dir_path"
                set -l short_dir_path (string replace "$str_to_replace" "$replacement" -- "$dir_path")
                set -l line_for_dirs_db "$dir_path:$short_dir_path"
                set -a lines_for_dirs_db "$line_for_dirs_db"
            end
        end
    end
    set -a lines_for_dirs_db Update:Update
    printf '%s\n' $lines_for_dirs_db >$dir_cache/dirs-db.txt
    # sort file in place based on the second field separated by :
    sort --field-separator : --key 2 --output $dir_cache/dirs-db.txt $dir_cache/dirs-db.txt
end

if not test -e $dir_cache/dirs-db.txt
    update_db
    notify-send -i emblem-default "Created Database" "Directory database created in .cache/find_files"
end

set chosen_line (fuzzel --dmenu --counter --nth-delimiter=":" --with-nth 2 --accept-nth 1 --width 60 --prompt="$prompt" --placeholder=" 󰌑 Strata 󰘵 1 Yazi 󰘵 2 Kitty 󰘵 3 Zen 󰘵 4 Imv" < $dir_cache/dirs-db.txt)
set -l fuzzel_status $status

# on pressing Esc Fuzzel status is 2
if test $fuzzel_status -eq 2
    exit 0
end

if test "$chosen_line" = Update
    update_db
    notify-send -i emblem-default "Updated Database" "Directory database updated in .cache/find_files"
    exit 0
end

# $status 2 means fuzzel was exited using Esc, $status 0 Return fuzzel value
# $status 10 Alt+1 plays in amberol; $11 Alt+2 eartag
switch $fuzzel_status
    case 0
        strata $chosen_line &
        disown
    case 10
        kitty --app-id yazi-dir -e yazi $chosen_line &
        disown
    case 11
        kitty --app-id kitty-editor -e nvim $chosen_line &
        disown
    case 12
        zen --new-tab $chosen_line &
        disown
    case 13
        imv $chosen_line &
        disown
    case '*'
        exit 0
end
