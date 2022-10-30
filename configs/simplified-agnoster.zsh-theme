() {
    _segment_separator="%F{red}:%f"

    # colors
    _red="%F{red}"
    _blue="%F{blue}"
    _cyan="%F{cyan}"
    _white="%F{white}"
    _yellow="%F{yellow}"
    _magenta="%F{magenta}"
    _nc="%f"

    # font
    _bold="%B"
    _nb="%b"
}

prompt_start() {
    echo -n "${_blue}${_bold}%n${_nc}${_nb}"
}

prompt_segment() {
    local segment=$1
    [[ -n ${segment} ]] && echo -n "${_segment_separator}${segment}"
}

prompt_end() {
    echo -n "${_blue}${_bold} >${_nc}${_nb}"
}

prompt_git() {
    (( $+commands[git] )) || return
    if [[ "$(git config --get oh-my-zsh.hide-status 2>/dev/null)" = 1 ]]; then
        return
    fi

    local ref dirty head mode repo_path
    if [[ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" = "true" ]]; then
        repo_path=$(git rev-parse --git-dir 2>/dev/null)
        ref=$(git symbolic-ref HEAD 2> /dev/null) || ref="$(git rev-parse --short HEAD 2> /dev/null)"
        head="${${ref:gs/%/%%}/refs\/heads\//}"

        if [[ -n $(parse_git_dirty) ]]; then
            dirty="${_blue}[${_nc}!${_blue}]${_nc}"
        else
            dirty=""
        fi

        if [[ -e "${repo_path}/BISECT_LOG" ]]; then
            mode="${_blue}{${_nc}B${_blue}}${_nc}"
        elif [[ -e "${repo_path}/MERGE_HEAD" ]]; then
            mode="${_blue}{${_nc}M${_blue}}${_nc}"
        elif [[ -e "${repo_path}/rebase" || -e "${repo_path}/rebase-apply" || -e "${repo_path}/rebase-merge" || -e "${repo_path}/../.dotest" ]]; then
            mode="${_blue}{${_nc}R${_blue}}${_nc}"
        fi

        setopt promptsubst
        autoload -Uz vcs_info
    
        zstyle ':vcs_info:*' enable git
        zstyle ':vcs_info:*' get-revision true
        zstyle ':vcs_info:*' check-for-changes true
        zstyle ':vcs_info:*' stagedstr "${_blue}[${_nc}+${_blue}]${_nc}"
        zstyle ':vcs_info:*' unstagedstr "${_blue}[${_nc}?${_blue}]${_nc}"
        zstyle ':vcs_info:*' formats '%u%c'
        zstyle ':vcs_info:*' actionformats '%u%c'
        vcs_info
		
        prompt_segment "${_blue}git(${_nc}${head}${vcs_info_msg_0_%% }${_blue})${_nc}${mode}"
    fi
}
 
prompt_dir() {
    prompt_segment "${_magenta}%(5~|%-1~/…/%3~|%4~)${_nc}"
}
 
prompt_virtualenv() {
    if [[ -n "$VIRTUAL_ENV" && -n "$VIRTUAL_ENV_DISABLE_PROMPT" ]]; then
        prompt_segment "${_cyan}(${VIRTUAL_ENV:t:gs/%/%})${_nc}"
    fi
}

prompt_exit_code() {
    [[ $RETVAL -ne 0 ]] && prompt_segment "${_red}${RETVAL}${_nc}"
}

prompt_number_of_jobs_in_background() {
    local number_of_jobs=$(jobs -l | wc -l | tr -d " ")
    [[ number_of_jobs -gt 0 ]] && prompt_segment "${_yellow}${number_of_jobs}${_nc}"
}

prompt_aws() {
    [[ -z "$AWS_PROFILE" || "$SHOW_AWS_PROMPT" = false ]] && return
    prompt_segment "${_yellow}AWS(${_nc}${AWS_PROFILE}${_yellow})${_nc}"
}

build_prompt() {
    RETVAL=$?
    prompt_start
    prompt_virtualenv
    prompt_git
    prompt_aws
    prompt_dir
    prompt_number_of_jobs_in_background
    prompt_exit_code
    prompt_end
}

PROMPT='$(build_prompt) '
