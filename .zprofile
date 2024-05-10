case $OS in
    $MACOS)
        [ -f "${CONFIG_HOME}/shell/macosprofile.sh" ] && source "${CONFIG_HOME}/shell/macosprofile.sh"
        ;;
esac
