# CSDealer

A simple bash script that updates your config files with Xresources color scheme and font (for now).


## How to use

Place a copy of your config file in `/template` folder and substitute color and font values with default tags.

Available tags:

```text
<bg> # background color
<fg> # foreground color
<color0> # base16 color 0 Xresources color
<color8> # base16 color 8 Xresources color
<color1> # base16 color 1 Xresources color
... and so on

<font> # font defined in .Xresources file like so: *.font-regular: FamilyFont regular fontSize
<fontBold> # font defined in .Xresources file like so: *.font-bold: FamilyFont bold fontSize
```

example:

```css
* {
    margin:                     0;
    spacing:                    0;
    border:                     0;
    scrollbar:                  false;
    text-color:                 <fg>;
    background-color:           transparent;
    border-color:               <bg>;
    fontSize:                   8;
    font:                       "<font> @fontSize";
}

...
```

Insert directory where your template should be printed, with this syntax:

```
// CSDdir:~/path/to/file/generatedFileName
```

There are some template example in `/template` folder

## Execution

When executed, CSDealer process every file in `/template` folder (even if there are sub-directories)  that has `CSDdir` directory declared.

## Notice

- You can declare `CSDdir` with absolute path or using `~`, the script will recognize it anyway.
- It works only with **.Xresources** file, because **CSD** uses `xrdb -query` command to gather color values.