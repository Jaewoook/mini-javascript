// var sum = 0;
// let counter = 0;

while (counter < 5) {
    sum = 0;
}

while (true) {
    while (false) {}
    break;
}

let str;

for (var i = 1; i <= 10; i++) {
    sum += i;
    str = ''
    for (var j = 1; j <= i; j++) {
        str += '*';
    }
    console.log(str);
}