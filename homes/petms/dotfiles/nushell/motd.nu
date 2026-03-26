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

    let info_lines = ([
        $first_line
        (0..$separator_length | each {|_| "-"} | str join)
    ] ++ ($info | | transpose key value | each {|e| $"($secondary_color)($e.key)(ansi reset): ($e.value)"}))

    $info_lines

}

export def show_motd [] {

    let logo = (logo)
    let sysinfo = (sysinfo)

    let table = [ $logo $sysinfo ]

    let max_length = ($table | each { length } | math max)

    let gap = 3

    let padded = $table | drop 1
        | each { |x| append (0..<($max_length - ($x | length)) | each { |x| '' }) }
        | each { |section|
            let max_width = $section | ansi strip | str length | math max
            $section | each { |line| $line | fill -c (char sp) -a left -w ($max_width + $gap) }
        }
        | append [($table | last)]

    $padded.0 | zip $padded.1 | each { str join } | str join (char nl)

}

export def main [] {
    show_motd
}
