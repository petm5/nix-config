.pragma library

function getIcon(icons, percentage) {
    var index = Math.round(percentage * (icons.length - 1));

    if (index >= icons.length) {
        index = icons.length - 1;
    }

    return icons[index]
}
