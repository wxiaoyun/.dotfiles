OS=$(uname)
MACOS="Darwin"
LINUX="Linux"

if [[ $OS == $MACOS ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"

  # Setting PATH for Python 3.12
  # The original version is saved in .zprofile.pysave
  PATH="/Library/Frameworks/Python.framework/Versions/3.12/bin:${PATH}"

  export PATH
elif [[ $OS == $LINUX ]]; then
fi
