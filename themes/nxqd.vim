minutes_since_last_commit() {
    now=`date +%s`
    last_commit=`git log --pretty=format:'%at' -1 2>/dev/null`
    if $lastcommit ; then
      seconds_since_last_commit=$((now-last_commit))
      minutes_since_last_commit=$((seconds_since_last_commit/60))
      echo $minutes_since_last_commit
    else
      echo "-1"
    fi
}

color_minute_since_last_minute() {
  local MINUTES_SINCE_LAST_COMMIT=`minutes_since_last_commit`

  if [ $MINUTES_SINCE_LAST_COMMIT -eq -1 ]; then
    color="${fg[gray]}"
    content="uncommitted"
    local return_value="${color}${content} "
  else
    content="${MINUTES_SINCE_LAST_COMMIT}m"
    if [ "$MINUTES_SINCE_LAST_COMMIT" -le 10 ]; then
      color="${fg[green]}"
    elif [ "$MINUTES_SINCE_LAST_COMMIT" -le 30 ]; then
      color="${fg[yellow]}"
    else
      color="${fg[red]}"
    fi
  fi

  #local return_value="${color}${content}"
  local return_value="%{${color}%}${content}"

  echo $return_value
}

if [ $UID -eq 0 ]; then CARETCOLOR="red"; else CARETCOLOR="blue"; fi

local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"

PROMPT='%{$reset_color%}%{${fg[green]}%}%3~ $(color_minute_since_last_minute) $(git_prompt_info)%{${fg_bold[$CARETCOLOR]}%}»%{${reset_color}%} '

RPS1="${return_code}"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}‹"
ZSH_THEME_GIT_PROMPT_SUFFIX="› %{$reset_color%}"
