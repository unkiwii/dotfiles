# custom theme based on steeef
# https://github.com/ohmyzsh/ohmyzsh/blob/master/themes/steeef.zsh-theme

export VIRTUAL_ENV_DISABLE_PROMPT=1

function virtualenv_info {
    [ $VIRTUAL_ENV ] && echo '('%F{blue}`basename $VIRTUAL_ENV`%f') '
}
PR_GIT_UPDATE=1

setopt prompt_subst

autoload -U add-zsh-hook
autoload -Uz vcs_info

#use extended color palette if available
if [[ $terminfo[colors] -ge 256 ]]; then
    color_git_branch="%F{6}"
    color_git_unstaged="%F{3}"
    color_git_untracked="%F{1}"
    color_git_staged="%F{2}"
    color_hostname="%F{3}"
    color_username="%F{5}"
    color_pwd="%F{2}"
    color_dark="%F{0}"
else
    color_git_branch="%F{cyan}"
    color_git_unstaged="%F{yellow}"
    color_git_untracked="%F{red}"
    color_git_staged="%F{green}"
    color_hostname="%F{yellow}"
    color_username="%F{magenta}"
    color_pwd="%F{green}"
    color_dark="%F{grey}"
fi

# enable VCS systems you use
zstyle ':vcs_info:*' enable git svn

# check-for-changes can be really slow.
# you should disable it, if you work with large repositories
zstyle ':vcs_info:*:prompt:*' check-for-changes true

# set formats
# %b - branchname
# %u - unstagedstr (see below)
# %c - stagedstr (see below)
# %a - action (e.g. rebase-i)
# %R - repository path
# %S - path in the repository
PR_RST="%f"
FMT_BRANCH="(%{$color_git_branch%}%b%u%c${PR_RST})"
FMT_ACTION="(%{$color_git_staged%}%a${PR_RST})"
FMT_UNSTAGED="%{$color_git_unstaged%}●"
FMT_STAGED="%{$color_git_staged%}●"

zstyle ':vcs_info:*:prompt:*' unstagedstr   "${FMT_UNSTAGED}"
zstyle ':vcs_info:*:prompt:*' stagedstr     "${FMT_STAGED}"
zstyle ':vcs_info:*:prompt:*' actionformats "${FMT_BRANCH}${FMT_ACTION}"
zstyle ':vcs_info:*:prompt:*' formats       "${FMT_BRANCH}"
zstyle ':vcs_info:*:prompt:*' nvcsformats   ""


function unkiwii_preexec {
    case "$2" in
        *git*)
            PR_GIT_UPDATE=1
            ;;
        *hub*)
            PR_GIT_UPDATE=1
            ;;
        *svn*)
            PR_GIT_UPDATE=1
            ;;
    esac
}
add-zsh-hook preexec unkiwii_preexec

function unkiwii_chpwd {
    PR_GIT_UPDATE=1
}
add-zsh-hook chpwd unkiwii_chpwd

function unkiwii_precmd {
    if [[ -n "$PR_GIT_UPDATE" ]] ; then
        # check for untracked files or updated submodules, since vcs_info doesn't
        if git ls-files --other --exclude-standard 2> /dev/null | grep -q "."; then
            PR_GIT_UPDATE=1
            FMT_BRANCH="(%{$color_git_branch%}%b%u%c%{$color_git_untracked%}●${PR_RST})"
        else
            FMT_BRANCH="(%{$color_git_branch%}%b%u%c${PR_RST})"
        fi
        zstyle ':vcs_info:*:prompt:*' formats "${FMT_BRANCH} "

        vcs_info 'prompt'
        PR_GIT_UPDATE=
    fi
}
add-zsh-hook precmd unkiwii_precmd

PROMPT=$'
%{$color_username%}%n${PR_RST} at %{$color_hostname%}%m${PR_RST} in %{$color_git_staged%}%~${PR_RST} $vcs_info_msg_0_$(virtualenv_info)
%(0?.%{$PR_RST%}.%{%F{red}%})$%{$PR_RST%} '
RPROMPT='%{$color_dark%}[$(vi_mode_prompt_info)]'
