
# Setting PATH for Python 3.13
# The original version is saved in .zprofile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.13/bin:${PATH}"
export PATH

eval "$(/opt/homebrew/bin/brew shellenv)"
export GEMINI_API_KEY="AIzaSyApNJBC4CDTaATSHGInusP70zTFC6n24Gw"

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init.zsh 2>/dev/null || :
