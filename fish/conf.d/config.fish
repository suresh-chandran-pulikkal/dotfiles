# ~/.config/fish/config.fish

# Environment variables
set -gx LC_ALL en_US.UTF-8
set -gx LANG en_US.UTF-8
set -gx FONT Hack
set -gx LD_LIBRARY_PATH "/usr/lib64/libreadline.so.8.2"
set -gx DISPLAY (ip route list default | awk '{print $3}'):0
set -gx LIBGL_ALWAYS_INDIRECT 1
set -gx MANPAGER 'nvim +Man!'
set -gx MANWIDTH 999
set -gx LS_OPTIONS '--color=auto'
set -gx CLICOLOR Yes
set -gx LSCOLORS gxfxbEaEBxxEhEhBaDaCaD
set -gx el7 centos-7-x86_64

# Fish settings
set -g fish_greeting
set -g fish_term24bit 1
set -g fish_color_command green
set -g fish_color_param cyan

# Aliases - Disabled in fish shell. Fish uses functions instead.
# alias lsd 'eza -lhDF' # list only directories
# alias lsf "ls -lArth | grep -v '^d'" # list only files
# alias ll 'eza -lhaF -s=modified'
# alias .. 'cd ..'
# alias refresh 'export (tmux show-environment SSH_AUTH_SOCK)'
# alias today 'date +%F'
# alias yesterday 'date --date yesterday +%F'
# alias vimdiff 'nvim -d'
# alias vim nvim
# alias ping 'ping -c 8'
# alias cp 'cp -i'
# alias mv 'mv -i'
# alias rm 'rm -i'
# alias sm 'cd /home/suresh/trading'
# alias gt 'cd /home/suresh/git'
# alias lg 'tmux set -g window-active-style "fg=default,bg=black"; lazygit; tmux set -g window-active-style "fg=colour40,bg=black"'
# # alias lg 'lazygit'
# alias kbn 'killbyname'
# alias docker-compose 'docker compose'
# alias dops 'docker ps'
# alias dopsa 'docker ps -a'
# alias dopsl 'docker ps -l'
# alias dopsf 'docker ps -f'
# alias dostop 'docker stop'
# alias dokill 'docker kill'
# alias dorm 'docker rm'
# alias dormf 'docker rm -f'
# alias dormv 'docker rm -v'
# alias dormp 'docker rm -p'
# alias dostopa 'docker stop $(docker ps -a -q)'
# alias dokilla 'docker kill $(docker ps -a -q)'
#
# Functions

function lsd --description "List only directories"
    eza -lhDF $argv
end

function lsf --description "List only files, sorted by modification time"
    ls -lArth | grep -v '^d' $argv
end

function ll --description "List all files in long format, sorted by modified time"
    eza -lhaF -s=modified $argv
end

function .. --description "Move up one directory"
    cd .. $argv
end

function cd- --description "Go back to previous directory"
    cd - $argv
end

function refresh --description "Refresh tmux SSH environment"
    export (tmux show-environment SSH_AUTH_SOCK) $argv
end

function today --description "Display today's date in YYYY-MM-DD format"
    date +%F $argv
end

function yesterday --description "Display yesterday's date in YYYY-MM-DD format"
    date --date yesterday +%F $argv
end

function vimdiff --description "Open Neovim in diff mode"
    nvim -d $argv
end

function vim --description "Open Neovim"
    nvim $argv
end

function ping --description "Ping with 8 packets"
    ping -c 8 $argv
end

function cp --description "Copy with interactive prompt"
    command cp -i $argv
end

function mv --description "Move with interactive prompt"
    command mv -i $argv
end

function rm --description "Remove with interactive prompt"
    command rm -i $argv
end

function sm --description "Navigate to trading directory"
    cd /home/suresh/trading $argv
end

function gt --description "Navigate to git directory"
    cd /home/suresh/git $argv
end

function lg --description "Run lazygit with tmux window style adjustments"
    tmux set -g window-active-style "fg=default,bg=black"; lazygit; tmux set -g window-active-style "fg=colour40,bg=black" $argv
end

function kbn --description "Kill process by its name"
    killbyname $argv
end

#Docker
function dc --description "Run docker compose"
    docker compose $argv
end

function dcd --description "Docker compose down"
    docker compose down $argv
end

function dps --description "List running docker container"
    docker ps --format "table {{.Name}}\t{{.Status}}\t{{.Ports}}" $argv
end

function docker-compose --description "Run docker compose"
    docker compose $argv
end

function dops --description "List running docker containers"
    docker ps $argv
end

function dopsa --description "List all docker containers"
    docker ps -a $argv
end

function dopsl --description "List latest docker container"
    docker ps -l $argv
end

function dopsf --description "List docker containers with filter"
    docker ps -f $argv
end

function dostop --description "Stop docker container"
    docker stop $argv
end

function dokill --description "Kill docker container"
    docker kill $argv
end

function dorm --description "Remove docker container"
    docker rm $argv
end

function dormf --description "Force remove docker container"
    docker rm -f $argv
end

function dormv --description "Remove docker container with volumes"
    docker rm -v $argv
end

function dormp --description "Remove docker container with ports"
    docker rm -p $argv
end

function dostopa --description "Stop all docker containers"
    docker stop (docker ps -a -q) $argv
end

function dokilla --description "Kill all docker containers"
    docker kill (docker ps -a -q) $argv
end

function mkcd
    mkdir -p $argv[1] && cd $argv[1] --description "Create a directory and cd into it"
end

function killbyname --description "Kill a process by its name"
  set process_name $argv[1]
  if test -z "$process_name"
    printf "Usage: killbyname <process-name>"
    return 1
  end

  set num_processes $(pgrep -f "$process_name" | wc -l)
  if test "$num_processes" -gt 0
    printf "There are $num_processes process(es) matching '$process_name' \n"
    ps aux | grep "$process_name" | grep -v grep
    printf "Do you want to kill these processes? (y/N): \n"
    read confirm
    if string match -qr '^[Yy]' -- $confirm
      pkill -f "$process_name"
      printf "Killed all processes matching: '$process_name' \n"
    else
      printf "Action canceled. \nExiting..."
    end
  else
    printf "There are no process matching '$process_name' !Exiting..."
  end
end


# Go up a directory
function up --description "Go up a directory"
    set limit $argv[1]
    if test -z "$limit" -o "$limit" -le 0
        set limit 1
    end

    set d ""
    for i in (seq 1 $limit)
        set d "../$d"
    end

    if not cd "$d"
        echo "Couldn't go up $limit dirs."
    end
end



# Extract a file
function extract --description "Extract a file"
    if test -f "$argv[1]"
        switch "$argv[1]"
            case '*.tar.bz2'
                tar xvjf "$argv[1]"
            case '*.tar.gz'
                tar xvzf "$argv[1]"
            case '*.bz2'
                bunzip2 "$argv[1]"
            case '*.rar'
                unrar x "$argv[1]"
            case '*.gz'
                gunzip "$argv[1]"
            case '*.tar'
                tar xvf "$argv[1]"
            case '*.tbz2'
                tar xvjf "$argv[1]"
            case '*.tgz'
                tar xvzf "$argv[1]"
            case '*.zip'
                unzip "$argv[1]"
            case '*.Z'
                uncompress "$argv[1]"
            case '*.7z'
                7za x "$argv[1]"
            case '*'
                echo "Oops.. Don't know how to extract '$argv[1]'..."
        end
    else
        echo "'$argv[1]' is not a valid file!"
    end
end

# Generate a random password
function passwd-generate --description "Generate a random password"
    python3 -c "import string,random; print (''.join(random.sample(string.punctuation+string.ascii_lowercase+string.ascii_uppercase+string.digits, 14)))"
end

# SSH agent setup
if not set -q SSH_AUTH_SOCK
    eval (ssh-agent -c) >/dev/null
    set -gx SSH_AUTH_SOCK $SSH_AUTH_SOCK
    set -gx SSH_AGENT_PID $SSH_AGENT_PID
end

# Load SSH keys
ssh-add "~/.ssh/*rsa" 2>/dev/null

# Tmux management functions
function manage_tmux
    if not command -v tmux >/dev/null
        echo "tmux not found on this machine"
    else if not set -q TMUX
        if test -z (tmux list-sessions 2>/dev/null)
            exec tmux new-session
        else
            exec tmux attach
        end
    end
end

# SSH with tmux color change
function ssh --description "SSH with tmux color change"
    if set -q TMUX
        switch "$argv[1]"
            case 'suresh*'
                tmux set-option -g window-status-current-style bg=green
            case '*'
                tmux set-option -g window-status-current-style bg=red
                tmux selectp -P 'fg=white,bg=colour52'
        end
    end
    command ssh $argv
    if set -q TMUX
        tmux selectp -P default
    end
end

# # FZF setup
# if test -f ~/.fzf.bash
#     source ~/.fzf.bash
# end
#
# Local RPM repository functions
if test -f ~/.localrpm
    source ~/.localrpm
end

# Set umask
umask 0022

# Start tmux automatically
manage_tmux

function reloadconf --description "Reload Fish config"
    source ~/.config/fish/conf.d/config.fish
    echo "✨ Fish config reloaded!"
end


# System management
function cleanmem --description "Clean memory"
    sync; echo 3 | sudo tee /proc/sys/vm/drop_caches
end

function findbig --description "Find big files"
    du -ah . | sort -rh | head -20
end

# Key Bindings (Like Bash/Zsh)
# function fish_user_key_bindings --description "Key Bindings (Like Bash/Zsh)"
#     bind \cr 'fzf history'
#     bind \cf 'z'  # Ctrl+F for directory jumping
# end
#
# Improved command history
set -g fish_history_limit 100000  # Increase history size
set -g fish_escape_delay_ms 10    # Faster escape key response

starship init fish | source

# Make Starship even faster by reducing Git checks
set -gx STARSHIP_CONFIG ~/.config/starship.toml
set -gx STARSHIP_CACHE ~/.starship/cache

# Optional: Reduce prompt delay (Fish-specific)
set -g fish_escape_delay_ms 10
