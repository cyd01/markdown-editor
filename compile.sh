#!/bin/sh

main_file="edit.html"

{

sed  '/INCLUDE_START/,$d' ${main_file}

echo -n '<link rel="icon" type="image/x-icon" href="data:image/x-icon;base64,' ; base64 favicon.ico|tr -d '\n' ; echo '">'
echo -n '<style type="text/css" title="original">' ; cat css/style.min.css | tr -d '\n' ; echo '</style>'

for style in test normalize github gitlab minist air modest retro splendor screen markdown foghorn md ; do
	echo -n '<style type="text/css" title="'${style}'">' ; cat css/${style}.min.css | tr -d '\n' ; echo '</style>'
done

echo -n '<style type="text/css">' ; cat css/highlight.min.css | tr -d '\n' ; echo '</style>'
#echo -n '<style type="text/css">' ; cat css/menu.min.css | tr -d '\n' ; echo '</style>'

echo -n '<script type="text/javascript">' ; cat js/sweetalert2.all.min.js | tr -d '\n' ; echo '</script>'
echo -n '<!--[if IE]><!--><script type="text/javascript">' ; cat js/promise.min.js | tr -d '\n' ; echo '</script><!--<![endif]-->'
echo -n '<script type="text/javascript">' ; cat js/base64.min.js | tr -d '\n' ; echo '</script>'
echo -n '<script type="text/javascript">' ; cat js/crc32.min.js | tr -d '\n' ; echo '</script>'
echo -n '<script type="text/javascript">' ; cat js/vue.min.js | tr -d '\n' ; echo '</script>'

echo -n '<script type="text/javascript">' ; cat js/marked.min.js | tr -d '\n' ; echo '</script>'
echo -n '<script type="text/javascript">' ; cat js/markdown-it.min.js | tr -d '\n' ; echo '</script>'
echo -n '<script type="text/javascript">' ; cat js/markdown-it-emoji.min.js | tr -d '\n' ; echo '</script>'
echo -n '<script type="text/javascript">' ; cat js/markdown-it-footnote.min.js | tr -d '\n' ; echo '</script>'
echo -n '<script type="text/javascript">' ; cat js/markdown-it-abbr.min.js | tr -d '\n' ; echo '</script>'
echo -n '<script type="text/javascript">' ; cat js/markdown-it-mark.min.js | tr -d '\n' ; echo '</script>'
echo -n '<script type="text/javascript">' ; cat js/markdown-it-ins.min.js | tr -d '\n' ; echo '</script>'
echo -n '<script type="text/javascript">' ; cat js/markdown-it-sub.min.js | tr -d '\n' ; echo '</script>'
echo -n '<script type="text/javascript">' ; cat js/markdown-it-sup.min.js | tr -d '\n' ; echo '</script>'
echo -n '<script type="text/javascript">' ; cat js/showdown.min.js | tr -d '\n' ; echo '</script>'

echo -n '<script type="text/javascript">' ; cat js/lodash.min.js | tr -d '\n' ; echo '</script>'
echo '<!-- highlight.js: Syntax highlighting for the Web -->'
echo -n '<script type="text/javascript">' ; cat js/highlight.min.js | tr -d '\n' ; echo '</script>'
echo -n '<script type="text/javascript">' ; cat js/com.js ; echo '</script>'
echo '<!-- SJCL: Stanford Javascript Crypto Library -->'
echo -n '<script type="text/javascript">' ; cat js/sjcl.js ; echo '</script>'
echo '<!-- Mermaid -->'
echo -n '<script type="text/javascript">' ; cat js/mermaid.min.js ; echo '</script>'
echo -n '<script type="text/javascript">' ; cat js/mermaid-converter.js ; echo '</script>'
echo
echo '<!--THE END-->'

sed  '1,/INCLUDE_END/d' ${main_file}

} > index.html

sed -i 's/var debug = true/var debug = false/' index.html

{
echo '<?php'

echo '/* Markdown Editor Installer */' ;
echo -n '$index="' ; base64 index.html|tr -d '\n' ; echo '";' ;
echo -n '$htaccess="' ; base64 .htaccess|tr -d '\n' ; echo '";' ;
echo -n '$edit="' ; base64 edit.php|tr -d '\n' ; echo '";' ;
echo -n '$fav="' ; base64 favicon.ico|tr -d '\n' ; echo '";' ;
echo
echo 'if( !file_exists("index.html") ) { file_put_contents( "index.html", base64_decode($index) ) ; }'
echo 'if( !file_exists(".htaccess") ) { file_put_contents( ".htaccess", base64_decode($htaccess) ) ; }'
echo 'if( !file_exists("edit.php") ) { file_put_contents( "edit.php", base64_decode($edit) ) ; }'
echo 'if( !file_exists("favicon.ico") ) { file_put_contents( "favicon.ico", base64_decode($fav) ) ; }'
echo 'if( !file_exists("pass") ) { mkdir("pass") ; }'
echo 'if( !file_exists("pass/.htaccess") ) { file_put_contents( "pass/.htaccess", "deny from all" ) ; }'
echo 'if( !file_exists("pages") ) { mkdir("pages") ; }'
echo 'if( !file_exists("img") ) { mkdir("img") ; }'
echo 'header("Location: index.html");'

echo '?>'
} > install.php
