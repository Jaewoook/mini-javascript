"use strict";

let playing = false;
let score = 0;
let map = [];

window.onload = function() {
    init();
    draw();
}

document.getElementById("start_button").addEventListener("click", start);
document.getElementById("reset_button").addEventListener("click", reset);
const rows = document.getElementsByClassName("row");

window.addEventListener('keydown', function(event) {
    console.log("Key pressed: ", event.key);
    let direction = null;
    switch (event.key) {
        case "S":
        case "s":
            start();
            break;
        case "R":
        case "r":
            reset();
            break;
        case 'ArrowUp':
            direction = "UP";
            break;
        case 'ArrowDown':
            direction = "DOWN";
            break;
        case 'ArrowLeft':
            direction = "LEFT";
            break;
        case 'ArrowRight':
            direction = "RIGHT";
            break;
    }

    if (playing && direction) {
        move(direction);
    }
});

function init() {
    // map = Array(4).fill(Array(4)).map((row) => { return row.fill(0); });
    // map = Array(4).fill(null).map(() => { Array(4).fill(0) });
}

function start() {
    if (playing) {
        return;
    }

    playing = true;
    console.log("start game");
    createNewBlock();
    createNewBlock();
}

function reset() {
    if (!playing) {
        return;
    }

    playing = false;
    console.log("reset game");
    init();
    draw();
}

function move(direction) {
    console.log("move to", direction);

    const previous = Array(map);

}

function draw() {
    if (!map) {
        return;
    }

    console.log("Map:", map);
    for (let i = 0; i < 4; i++) {
        for (let j = 0; j < 4; j++) {
            rows.item(i).getElementsByClassName("block").item(j).innerHTML = map[i][j] > 0 ? map[i][j] : '';
        }
    }
}

function updateMap(position, value) {
    if (!(position && value)) {
        return;
    }

    map[position[0]][position[1]] = value;
    console.log("UpdateMap: ", map);
    draw();
}

function generateRandomAvailablePosition() {
    let position = [-1, -1];
    do {
        position[0] = Math.floor(Math.random() * 4);
        position[1] = Math.floor(Math.random() * 4);
    } while (map[position[0], position[1]] > 0);

    console.log("generated position: ", position);
    return position;
}

function createNewBlock() {
    const position = generateRandomAvailablePosition();
    const value = Math.random() < 0.9 ? 2 : 4;
    updateMap(position, value);
}