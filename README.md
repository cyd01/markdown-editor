[//]: # (title:Markdown editor)
[//]: # (icon:coffee.ico)
[//]: # (style:md)

# Welcome to markdown-editor

This markdown-editor is a 99% client-side javascript viewer and editor for markdown.

Why 1% missing. Because when you finished to edit your document you can upload it directly to your web server.

It can easily be used to powered client-side Javascript Web site. Jump to the [demo](https://cyd01.github.io/markdown-editor/#/README.md).

---

## How to compile ?

Just clone the repository and run the **compile.sh** provided script file.

```
git clone git@github.com:cyd01/markdown-editor.git
cd markdown-editor
./compile.sh
```

It produces a new file **install.php**. Just upload it on your web site and call it.

---

## How does it work ?

The `index.html` page embed at the same time

- the client-side markdown to html renderer
- the markdown editor

Markdown file are read directly from the directory. 

Example: this `README` page is read from a `README.md` file near the `index.html` main file.

Here are the editor shortcuts

- To switch from page viewer to page editor, just triple-click
- To swith between plain text or base64 press ATL+b
- To clear local storage press ALT+c
- To protect the page with password ALT+p
- To revert current changes press ALT+r
- To save the page press ALT+s
- To change style sheet press ALT+t
- To print help page press ALT+F1 or ALT+z
- To switch back to the viewer press escape key
  
---

## Special features

### Parameters

| Parameter | Description                   | Example                                                                                        |
| --------- | ----------------------------- | ---------------------------------------------------------------------------------------------- |
| data      | the base64 encoded text       | [example](/?data=Wy8vXTogIyAodGl0bGU6VGl0bGUpCgojIE1haW4gdGl0bGUKClRoaXMgaXMgYSBzaG9ydCB0ZXh0) |
| engine    | the markdown rendering engine | choose between markedjs, mardown-it and showdown ([markedjs](/?engine=marked) is the default)  |
| style     | choose a embedded style       | see this page in [retro style](/?style=retro#/README.md)                                       |

### Special startup tags

Use Markdown comments to define special page settings at the very start of the page:

| Comment                             | Description             |
| ----------------------------------- | ----------------------- |
| `[//]: # (title:This is the title)` | Define the page title   |
| `[//]: # (style:css/united)`        | Define the page style   |
| `[//]: # (icon:coffee.ico)`         | Define the favicon page |
| `[//]: # (readonly)`                | Force read only page    |

### Integrated special emoji

Emojis from this [markdown emojis](https://github.com/markdown-templates/markdown-emojis) page is included.

Example: use this special tag &colon;<wbr>coffee&shy;: to print this emoji :coffee:

### Integrated themes

Some style are already embedded into markdown-editor:

[comment]: <> ( https://github.com/gadenbuie/cleanrmd )

- original
- normalize
- [github](https://github.com/sindresorhus/github-markdown-css)
- gitlab
- minist
- [air](http://markdowncss.github.io/air/)
- [modest](http://markdowncss.github.io/modest/)
- [retro](http://markdowncss.github.io/retro/)
- [splendor](http://markdowncss.github.io/splendor/)
- [screen](https://jasonm23.github.io/markdown-css-themes/)
- [markdown](https://mrcoles.com/demo/markdown-css/)
- [foghorn](https://github.com/jasonm23/markdown-css-themes/)
- [md](https://github.com/elrrrrrrr/markdown-css/blob/master/css/md.css)

### Integrated mermaid

It is possible ton include [mermaid](https://mermaid-js.github.io/mermaid/#/) diagram.

The mermaid code

    ``` mermaid
    graph TD
      A[Christmas] -->|Get money| B(Go shopping)
      B -->C{Let me think}
      C -->|One| D[Laptop]
      C -->|Two| E[iPhone]
      C -->|Three| F[fa:fa-car Car]
    ```

will produce the graph

[![](https://mermaid.ink/img/eyJjb2RlIjoiZ3JhcGggVERcbiAgICBBW0NocmlzdG1hc10gLS0-fEdldCBtb25leXwgQihHbyBzaG9wcGluZylcbiAgICBCIC0tPiBDe0xldCBtZSB0aGlua31cbiAgICBDIC0tPnxPbmV8IERbTGFwdG9wXVxuICAgIEMgLS0-fFR3b3wgRVtpUGhvbmVdXG4gICAgQyAtLT58VGhyZWV8IEZbZmE6ZmEtY2FyIENhcl1cbiAgIiwibWVybWFpZCI6eyJ0aGVtZSI6ImRlZmF1bHQifSwidXBkYXRlRWRpdG9yIjpmYWxzZSwiYXV0b1N5bmMiOnRydWUsInVwZGF0ZURpYWdyYW0iOnRydWV9)](https://mermaid-js.github.io/mermaid-live-editor/edit/#eyJjb2RlIjoiZ3JhcGggVERcbiAgICBBW0NocmlzdG1hc10gLS0-fEdldCBtb25leXwgQihHbyBzaG9wcGluZylcbiAgICBCIC0tPiBDe0xldCBtZSB0aGlua31cbiAgICBDIC0tPnxPbmV8IERbTGFwdG9wXVxuICAgIEMgLS0-fFR3b3wgRVtpUGhvbmVdXG4gICAgQyAtLT58VGhyZWV8IEZbZmE6ZmEtY2FyIENhcl1cbiAgIiwibWVybWFpZCI6IntcbiAgXCJ0aGVtZVwiOiBcImRlZmF1bHRcIlxufSIsInVwZGF0ZUVkaXRvciI6ZmFsc2UsImF1dG9TeW5jIjp0cnVlLCJ1cGRhdGVEaWFncmFtIjp0cnVlfQ)

> For further informations See [mermaid online editor](https://mermaid-js.github.io/mermaid-live-editor/edit#eyJjb2RlIjoiZ3JhcGggVERcbiAgICBBW0NocmlzdG1hc10gLS0-fEdldCBtb25leXwgQihHbyBzaG9wcGluZylcbiAgICBCIC0tPiBDe0xldCBtZSB0aGlua31cbiAgICBDIC0tPnxPbmV8IERbTGFwdG9wXVxuICAgIEMgLS0-fFR3b3wgRVtpUGhvbmVdXG4gICAgQyAtLT58VGhyZWV8IEZbZmE6ZmEtY2FyIENhcl1cbiAgIiwibWVybWFpZCI6IntcbiAgXCJ0aGVtZVwiOiBcImRlZmF1bHRcIlxufSIsInVwZGF0ZUVkaXRvciI6dHJ1ZSwiYXV0b1N5bmMiOnRydWUsInVwZGF0ZURpYWdyYW0iOnRydWV9)
