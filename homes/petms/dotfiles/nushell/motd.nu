def logo [] {

    let colors = [ '#D60270' '#9B4F96' '#0038A8' ]

    let lines = [ $colors.0 $colors.0 $colors.1 $colors.2 $colors.2 ]

    let spaces = '' | fill -c ' ' -w 18

    let logo = ($lines | each { |color| [ (ansi -e { bg: $color }) ($spaces) (ansi reset) ] | str join })

    $logo

}

def sysinfo [] {

    let primary_color = (ansi magenta_bold)
    let secondary_color = (ansi blue_bold)

    let host = (sys host)
    let mem = (sys mem)

    let os_name = [ $host.name? $host.os_version? ]
        | compact
        | where {|it| not ($it | is-empty) }
        | str join " "

    let os_final = if ($os_name | is-empty) { "Unknown OS" } else { $os_name }

    let info = {
        OS: $os_final
        Kernel: ($host.kernel_version)
        Uptime: ($host.uptime)
        Memory: $"($mem.used) / ($mem.total)"
        Shell: $"nushell ($env.NU_VERSION)"
    }

    let first_line = ([
        $primary_color
        ($env.USER)
        (ansi reset)
        "@"
        $primary_color
        ($host.hostname)
        (ansi reset)
    ] | str join)

    let separator_length = ($env.USER | str length) + ($host | get hostname | str length)

    let info_lines = ($info | transpose key value | each {|e|
        [
            ($secondary_color)
            ($e.key)
            (ansi reset)
            ": "
            ($e.value)
        ] | str join
    })

    let out_lines = ([
        $first_line
        (0..$separator_length | each {|_| "-"} | str join)
    ] | append $info_lines)

    $out_lines

}

def motd [] {

    let logo = (logo)
    let sysinfo = (sysinfo)

    let gap = 3

    let sections = [ $logo $sysinfo ] | wrap lines | insert width { get lines | ansi strip | str length | math max }

    let max_len = $sections | get lines | each { length } | math max

    let zipped = 0..<$max_len | each { |i|
        $sections | each { |s| $s.lines | get -o $i | default '' | fill -c (char sp) -w ($s.width + $gap) }
    }

    [
        "\e[?7l"
        ($zipped | each { str join } | str join (char nl))
        "\e[?7h"
        (ansi reset)
    ] | str join

}

export def show_motd [] {
    motd | print
}

export def main [] {
    show_motd
}
