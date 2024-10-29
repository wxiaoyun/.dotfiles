#!/bin/sh

alias ls="eza --color --icons --group-directories-first"
alias cd="z"
alias mv="mv -iv"
alias rm="rm -I"
alias grep="grep --color=always"

alias pn="pnpm"

alias v="nvim"
alias vim="nvim"

# Composite shortcuts
alias lla="ls -la"
alias lc="code $HOME/code/leetcode"
alias vpnsoc="sudo openfortivpn webvpn.comp.nus.edu.sg --username=e0702008"

cdc() {
  cd "$HOME/code/$1"
}

stirling() {
  usage() {
    echo "Error: Exactly one argument is required."
    echo "Usage: $0 {run|start|stop|rm|open}"
  }

  if [ "$#" -ne 1 ]; then
    usage
    return
  fi

  local CONTAINER_NAME="stirling-pdf"
  local IMAGE_NAME="frooodle/s-pdf:latest"

  case "$1" in
  run)
    local user_dir=$(eval echo ~$USER)
    local stirling_dir="$user_dir/Documents/stirling"

    local TESS_DATA_DIR="$stirling_dir/trainingData"
    local CONFIG_DIR="$stirling_dir/configs"
    local LOG_DIR="$stirling_dir/logs"

    mkdir -p $TESS_DATA_DIR
    mkdir -p $CONFIG_DIR
    mkdir -p $LOG_DIR

    docker run -d \
      -p 8080:8080 \
      -v "$TESS_DATA_DIR:/usr/share/tessdata" \
      -v "$CONFIG_DIR:/configs" \
      -v "$LOG_DIR:/logs" \
      -e DOCKER_ENABLE_SECURITY=false \
      -e INSTALL_BOOK_AND_ADVANCED_HTML_OPS=false \
      -e LANGS=en_GB \
      --name "$CONTAINER_NAME" \
      "$IMAGE_NAME"
    echo "Container $CONTAINER_NAME is running."

    ;;

  start)
    # Start the existing container
    docker start "$CONTAINER_NAME"
    echo "Container $CONTAINER_NAME started."
    ;;

  stop)
    # Stop the container
    docker stop "$CONTAINER_NAME"
    echo "Container $CONTAINER_NAME stopped."
    ;;

  rm)
    # Remove the container
    docker rm "$CONTAINER_NAME"
    echo "Container $CONTAINER_NAME removed."
    ;;

  open)
    open "http://localhost:8080"
    ;;

  *)
    usage
    ;;
  esac
}
