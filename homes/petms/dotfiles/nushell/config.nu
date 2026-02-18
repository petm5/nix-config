# Nushell config file

$env.PROMPT_INDICATOR = {|| $"(ansi magenta)❭ " }

def create_left_prompt [] {
    let dir = match (do -i { $env.PWD | path relative-to $nu.home-path }) {
        null => $env.PWD
        '' => '~'
        $relative_pwd => ([~ $relative_pwd] | path join)
    }

    let path_color = (ansi green_bold)
    let separator_color = (ansi light_green_bold)

    ([
        $path_color
        ($dir | str replace --all (char path_sep) $"($separator_color)(char path_sep)($path_color)")
        (char nl)
    ] | str join)
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

$env.color_config = {
    separator: dark_gray
    leading_trailing_space_bg: { attr: n }
    header: green_bold
    empty: blue
    bool: dark_cyan
    int: dark_gray
    filesize: cyan_bold
    duration: dark_gray
    date: purple
    range: dark_gray
    float: dark_gray
    string: dark_gray
    nothing: dark_gray
    binary: dark_gray
    cell-path: dark_gray
    row_index: green_bold
    record: dark_gray
    list: dark_gray
    block: dark_gray
    hints: dark_gray
    search_result: { fg: white bg: red }
    shape_and: purple_bold
    shape_binary: purple_bold
    shape_block: blue_bold
    shape_bool: light_cyan
    shape_closure: green_bold
    shape_custom: green
    shape_datetime: cyan_bold
    shape_directory: cyan
    shape_external: cyan
    shape_externalarg: green_bold
    shape_external_resolved: light_purple_bold
    shape_filepath: cyan
    shape_flag: blue_bold
    shape_float: purple_bold
    shape_garbage: { fg: white bg: red attr: b}
    shape_globpattern: cyan_bold
    shape_int: purple_bold
    shape_internalcall: cyan_bold
    shape_keyword: cyan_bold
    shape_list: cyan_bold
    shape_literal: blue
    shape_match_pattern: green
    shape_matching_brackets: { attr: u }
    shape_nothing: light_cyan
    shape_operator: yellow
    shape_or: purple_bold
    shape_pipe: purple_bold
    shape_range: yellow_bold
    shape_record: cyan_bold
    shape_redirection: purple_bold
    shape_signature: green_bold
    shape_string: green
    shape_string_interpolation: cyan_bold
    shape_table: blue_bold
    shape_variable: purple
    shape_vardecl: purple
    shape_raw_string: light_purple
}

$env.config.show_banner = false;

def system_info [] {

    let primary_color = (ansi blue_bold);
    let secondary_color = (ansi cyan_bold);

    let host = (sys host);
    let mem = (sys mem)

    let info = {
        OS: $"($host.name) ($host.os_version)"
        Kernel: ($host.kernel_version)
        Uptime: ($host.uptime)
        Memory: $"($mem.used) / ($mem.total)"
        Shell: $"nu ($env.NU_VERSION)"
    };

    let first_line = ([
        $primary_color
        ($env.USER)
        (ansi reset)
        "@"
        $primary_color
        ($host.hostname)
        (ansi reset)
    ] | str join);

    let separator_length = ($env.USER | str length) + ($host | get hostname | str length)

    let info_lines = ([
        $first_line
        (0..$separator_length | each {|_| "-"} | str join)
    ] ++ ($info | | transpose key value | each {|e| $"($secondary_color)($e.key)(ansi reset): ($e.value)"}));

    echo $info_lines | str join (char nl)

}
