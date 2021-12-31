# mini-javascript

A mini JavaScript parser using Lex & Yacc. This parser is not production ready version. So it might have potential syntax issue.

## What is mini-JavaScript?

It's not full featured, but it is a light version of JavaScript. It supports most used keywords in original JavaScript.

### Supported Keywords

Here is some major keywords the lexer can recognize.

| category                  | keywords                                                         |
| ------------------------- | ---------------------------------------------------------------- |
| variable declaration      | `var`, `let`, `const`                                            |
| function declaration      | `function`, `=>`                                                 |
| loop statements           | `for`, `while`, `do`                                             |
| conditional statement     | `if`, `else`, `switch`, `case`                                   |
| literal                   | `true`, `false`, `null`, `undefined`, `NaN`, `Infinity` and more |
| modern javascript keyword | `"use strict";`, `async`, `await`                                |
| logical operator          | `==`, `===`, `!=`, `!==`, `<`, `>`, `&&`, `\|\|` and more        |
| comment                   | `//`                                                             |

You can find the entire keywords in [this file](./mini-javascript.l).

### Supported Syntax

see [this yacc file](./mini-javascript.y).

### Parse Result

When the parser task ends, it prints debug messages and parse tree as the result.

**Here is the sample output**

<details>
  <summary><b>test.js (click to show / hide source</b>)</summary>
  <p>

  ```js
  "use strict";
  var a = 1;
  const b = 123;
  let c;
  const str = "Hello"
  const template_str = `hello`;

  function add() {
      return
  }
  ```

</p>
</details>
<br>

**output**

![parse output](./docs/screenshots/parse_output.png)

## Getting Started

This project does not provide compiled version of binary. So you should manually compile the parser to work on your system. The following steps describe how to compile the parser.

### Prerequisites

Before getting started, a few tools must be installed on your system.

- flex
- bison
- make
- gcc

<details>
  <summary><b>macOS Installation</b></summary>
  <p>

  ```sh
  # Install bison and flex
  brew install bison flex

  # Install gcc and make
  xcode-select --install
  ```

  </p>
</details>

### Installation

1. Clone this repository

```sh
git clone https://github.com/Jaewoook/mini-javascript.git
```

2. Run make command

```sh
make
```

3. Done!

also, lex and yacc standalone compile script is available.

```sh
# compile lex standalone
./lex.sh

# compile yacc standalone
./yacc.sh
```

> :warning: **Note: if you can't run .sh file, run following command:**  
> > **`chmod +x *.sh`**

### Usage

```sh
./javascript [FILE]
```

### Test

You can test the parser by executing following script. The test script automatically runs all `.js` files in the sample directory.

```sh
./test.sh
```

## Contribution

You can contribute this project 

## Author

- [Jaewook Ahn](https://github.com/Jaewoook)

## License

[MIT License](./LICENSE)