# Nushell config file

use std/config light-theme

$env.PROMPT_INDICATOR = {|| $"(ansi magenta)❭ " }

def create_left_prompt [] {
    let dir = match (do -i { $env.PWD | path relative-to $nu.home-dir }) {
        null => $env.PWD
        '' => '~'
        $relative_pwd => ([~ $relative_pwd] | path join)
    }

    let user_color = (ansi cyan_bold)

    let session_part = if ($env.CODESPACES? | default "false" | into bool) {
        ([
            ($user_color)
            "@"
            ($env.GITHUB_USER? | default "git")
        ] | str join)
    }

    let path_color = (ansi green_bold)
    let separator_color = (ansi light_green_bold)

    let path_part = ([
        $path_color
        ($dir | str replace --all (char path_sep) $"($separator_color)(char path_sep)($path_color)")
    ] | str join)

    ([
        $session_part
        $path_part
        (char nl)
    ] | compact | str join (char sp))
}

def create_right_prompt [] {
    let last_exit_code = if ($env.LAST_EXIT_CODE != 0) {([
        (ansi rb)
        "✗"
        (char space)
        ($env.LAST_EXIT_CODE)
    ] | str join)
    } else {""}

    ([$last_exit_code] | str join)
}

$env.PROMPT_COMMAND = {|| create_left_prompt }
$env.PROMPT_COMMAND_RIGHT = {|| create_right_prompt }

$env.config.color_config = (light-theme)

$env.config.show_banner = false;

$env.config.hooks.env_change.PWD = [
    { ||
        if (which direnv | is-empty) {
            return
        }

        direnv export json | from json | default {} | load-env
    }
]

$env.LS_COLORS = "di=1;34:fi=37:ln=36:ex=32:pi=5:so=5:bd=5:cd=5:or=31"
