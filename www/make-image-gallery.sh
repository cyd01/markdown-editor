#!/bin/sh

echo "[//]: # (title:Images Gallery)"
echo "[//]: # (style:md)"
echo "[//]: # (https://pixabay.com/fr/users/happymom33-7463641/)"

printf '\n# Images Gallery\n\n'
	
printf '<style>\n  @keyframes slidy {\n    from { left: 100%%; }\n'
nb=$(ls -1 img/*.jpg | wc -l)
i=1
while [ $i -le $nb ] ; do
  echo $i $nb | awk '{printf("    %d%% { left: -%d%%; }\n",(100*($1-1)/$2)+2,(($1-1)*100));}'
  echo $i $nb | awk '{printf("    %d%% { left: -%d%%; }\n",(100*$1/$2),(($1-1)*100));}'
  i=$(expr $i + 1 )
done
printf '  }\n'
printf '  div#slider { overflow: hidden; }\n'
echo $nb | awk '{printf("  div#slider figure img { width: %f%%; float: left; }\n",(100/$1));}'
printf '  div#slider figure {\n'
printf '  position: relative;\n'
echo $nb | awk '{printf("  width: %d%%;\n",100*$1);}'
printf '  margin: 0;\n'
printf '  left: 0;\n'
printf '  text-align: left;\n'
printf '  font-size: 0;\n'
printf '  animation: 30s slidy infinite;\n'
printf '  }\n'
printf '</style>\n'

printf '<div id="slider">\n  <figure>\n'; for f in $(ls -1 img/*.jpg) ; do printf '    <img src="'$f'" alt>\n' ; done ; printf '  </figure>\n</div>\n'
