To get started writing your own simple legal documents with Common Form markup, install GNU Make, Node.js, and npm, then do:

```shell
git clone https://github.com/commonform/commonform-starter yourproject
cd yourproject
make
```

GNU Make will install Common Form command line tools using npm, and then create a Microsoft Word copy of the bylaws included as `document.cform`.

Change `document.cform` as you like. You can check your work for structural and possible stylistic errors at any time by doing:

```shell
make lint
make critique
```
