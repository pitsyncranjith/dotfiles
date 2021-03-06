# See this epic color codes guide: http://unix.stackexchange.com/a/124409/87343
PS1='\[\033[48;5;233;38;5;87m\]../\W\[\033[0m\] \[\033[33m\]`git branch 2> /dev/null | grep -e ^* | sed -E  s/^\\\\\*\ \(.+\)$/\<\\\\\1\>\ /`\[\033[01;32m\]$\[\033[0m\] '

# NOT SURE WHY THIS BREAKS SHIT
#export PYTHONPATH=/usr/local/lib/python2.7/site-packages:/usr/local/share/python:$PYTHONPATH
export PYTHONPATH=/usr/local/lib/python2.7/site-packages:/usr/local/share/python

# Node stuff
export NODE_PATH="/usr/local/lib/node_modules"

# Prefer /usr/local/bin over /usr/bin
export PATH="/usr/local/bin:$PATH:$HOME/bin"
export PATH="/usr/local/sbin:$PATH"

# Prefer Postgres.app over everything else.
export PATH="/Applications/Postgres.app/Contents/Versions/9.4/bin:$PATH"

# Make Haskell's stuff available
export PATH="$HOME/Library/Haskell/bin:$PATH"

# Go
export PATH="$PATH:/usr/local/opt/go/libexec/bin"
#export GOROOT="/usr/local/opt/go/libexec/bin"

# Load stuff for android
if [ -e ~/Library/Android/sdk/platform-tools ]; then
    export PATH=${PATH}:~/Library/Android/sdk/tools
    export PATH=${PATH}:~/Library/Android/sdk/platform-tools
fi

# Packer
export PATH="/usr/local/packer:$PATH"

# OpenCV libraries
#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib:/sw/lib
#export PKG_CONFIG_PATH=$PKG_CONFIG_PAGH:/usr/local/lib/pkgconfig
#DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:/usr/local/lib:/sw/lib:/usr/lib
#export DYLD_LIBRARY_PATH
#export DYLD_FALLBACK_LIBRARY_PATH=/sw/lib:$DYLD_FALLBACK_LIBRARY_PATH

# create some environment variables for svn
export SVN_EDITOR=/usr/bin/vi
export VISUAL=/usr/bin/vi
export EDITOR=/usr/bin/vi

# Virtualenvwrapper
export PIP_REQUIRE_VIRTUALENV=true
export PIP_RESPECT_VIRTUALENV=true
if [ -e /usr/local/bin/virtualenvwrapper.sh ]; then
    export WORKON_HOME=$HOME/.virtualenvs
    source /usr/local/bin/virtualenvwrapper.sh
fi

# For cx-Oracle
#export ORACLE_HOME=$HOME/Oracle10g_MacOSX/instantclient/instantclient_10_2
#export ORACLE_SID=ODSP
#export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:$ORACLE_HOME
#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$ORACLE_HOME

# GeoDjango Libraries
#GEOS_LIBRARY_PATH='/Library/Frameworks/GEOS.framework/GEOS'
#GDAL_LIBRARY_PATH='/Library/Frameworks/GDAL.framework/GDAL'
#GEOIP_LIBRARY_PATH='/usr/local/Cellar/geoip/1.5.1/lib/libGeoIP.dylib'
#export PATH=/Library/Frameworks/UnixImageIO.framework/Programs:$PATH
#export PATH=/Library/Frameworks/PROJ.framework/Programs:$PATH
#export PATH=/Library/Frameworks/GEOS.framework/Programs:$PATH
#export PATH=/Library/Frameworks/SQLite3.framework/Programs:$PATH
#export PATH=/Library/Frameworks/GDAL.framework/Programs:$PATH
#export PATH=/usr/local/pgsql/bin:$PATH

# pip bash completion start
_pip_completion()
{
    COMPREPLY=( $( COMP_WORDS="${COMP_WORDS[*]}" \
                   COMP_CWORD=$COMP_CWORD \
                   PIP_AUTO_COMPLETE=1 $1 ) )
}
complete -o default -F _pip_completion pip
# pip bash completion end

decrypt()
{
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo "USAGE: decrypt <input> <output>"
    else
        openssl des3 -d -salt -in $1 -out $2
    fi
}
encrypt()
{
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo "USAGE: decrypt <input> <output>"
    else
        openssl des3 -salt -in $1 -out $2
    fi
}

function convert_to_mp3
{
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo "USAGE: convert_to_mp3 <input_file> <output_file.mp3>"
    else
        ffmpeg -i $1 -acodec mp3 $2
    fi
}

function pyg()
{
    if [ -z "$1" ]; then
        echo "USAGE: pyg <input>"
    else
        echo "Running: pygmentize -f rtf $1 | pbcopy"
        pygmentize -f rtf $1 | pbcopy
    fi
}

function png2gif
{

    ## TODO: Make -r <rate> an input value.

    if [ -z "$1" ]; then
        echo "USAGE: png2gif <Filename> -- provide filename without -x.png, "
        echo "     e.g. ToastFox-1.png, ToastFox-2.png --> png2gif ToastFox "
    else
        FILE_PATTERN="$1-%d.png";
        OUTPUT="$1.gif";
        ffmpeg -f image2 -i $FILE_PATTERN -vcodec copy tmp-video.mkv && \
        ffmpeg -i tmp-video.mkv -pix_fmt rgb24 -loop 0 -r 5 $OUTPUT;
        rm tmp-video.mkv
    fi
}
function jpg2gif
{
    ## TODO: Make -r <rate> an input value.
    # TODO: figure out how to control speed :-/

    if [ -z "$1" ]; then
        echo "USAGE: jpg2gif <Filename> -- provide filename without -x.jpg, "
        echo "     e.g. ToastFox-1.jpg, ToastFox-2.jpg --> jpg2gif ToastFox "
    else
        FILE_PATTERN="$1-%d.jpg";
        OUTPUT="$1.gif";
        ffmpeg -f image2 -i $FILE_PATTERN -vcodec copy tmp-video.mkv && \
        ffmpeg -i tmp-video.mkv -pix_fmt rgb24 -loop 0 -r 20 -frames 6 -vframes 6 $OUTPUT;
        rm tmp-video.mkv
    fi
}


function timerequest
{
    # Use curl to TIME http requests.
    # Inspired by this: http://stackoverflow.com/a/22625150/182778

   FMT="
         http_code:  %{http_code}
     size_download:  %{size_download}
       size_header:  %{size_header}
    speed_download:  %{speed_download}\n
   time_namelookup:  %{time_namelookup}
      time_connect:  %{time_connect}
   time_appconnect:  %{time_appconnect}
  time_pretransfer:  %{time_pretransfer}
     time_redirect:  %{time_redirect}
time_starttransfer:  %{time_starttransfer}
                   ----------
        time_total:  %{time_total}
    "
    curl -w "$FMT" -o /dev/null -s $1
}

# Aliases
alias ls='ls -G'
alias ll='ls -lhG'
alias l='ls -lhG'
alias la='ls -ahG'
alias hig='history | grep --color'
alias top=htop
alias get=git
alias gti=git
alias br='git branch'
alias st='git status'
alias knive=knife
alias VAGRANTDESTROY='vagrant destroy'
alias clera=clear
alias tail='less +F'

# Nifty Python Aliases
alias nosetests="nosetests --with-yanc"
alias email='python -m smtpd -n -c DebuggingServer localhost:1025'
alias serve='python -m SimpleHTTPServer'
alias rmpyc='find ./ -type f -name "*.pyc" -exec rm {} \;'
alias mp3player="find . -name '*.mp3' -exec afplay '{}' \;"
alias m4aplayer="find . -name '*.m4a' -exec afplay '{}' \;"
alias ipython_console="ipython qtconsole --pylab=inline"
alias lolutc='python -c "for h in range(0,24): print \"{0} utc --- {1} cdt --- {2} pdt\".format(h, (h-5)%24, (h-8)%24)"'
#alias lolutc='python -c "for h in range(0,24): print \"{0} utc --- {1} cst --- {2} pst\".format(h, (h-6)%24, (h-8)%24)"'
alias 936='python -m ninethreesix.password'

# A Function to list all the python classes in a file
function listclasses()
{
    if [ -z "$1" ]; then
        F="models.py"
    else
        F="$1"
    fi
    cat $F | grep "^class " | sed "s/class //" | sed "s/(.*$//" | sort
}
alias listmodels=listclasses | grep -v Manager

# Pure Awesome. (brew install sox to get the play command)
alias impulsepower="play -n -c1 synth whitenoise band -n 100 20 band -n 50 20 gain +25  fade h 1 864000 1"

# Alias for Love2d
alias love="/Applications/love.app/Contents/MacOS/love"

# A little function to zip up the current directory contents into a .love file.
function loveit()
{
    if [ -z "$1" ]; then
        echo "USAGE: loveit <name>"
    else
        zip -9 -q -r $1.love .
    fi
}

# A little experiment: shortcuts for ssh'ing into various things
# The .ssh_hosts file will contain aliases that look like:
#
#   alias ssh_hostname="ssh user@hostname.example.com"
#
if [ -f ~/.ssh_hosts ]; then
    . ~/.ssh_hosts
fi

# sigh. put my homebrew ruby bin on the path
#export PATH="$PATH:/usr/local/Cellar/ruby/1.9.3-p0/bin"

# rbenv
#eval "$(rbenv init -)"

# Opscode/Chef stuff
export OPSCODE_ORGNAME="workforpie"
export OPSCODE_USER="workforpie"

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# Load the secret env vars.
source $HOME/Dropbox/dotfiles/secrets.sh
