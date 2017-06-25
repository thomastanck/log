cd "$(dirname "$0")"

link="$1"
[ -z "$1" ] && read link
curdate=$(date +%Y_%m_%d)
timestamp=$(date -u +%FT%TZ)
filename=content/log/${curdate}_$(wc -w <<<$(ls content/log | grep ${curdate})).md

#hugo new $filename
#sed -i -e 's`^title=".*"$`title="'$title'`' content/$filename

echo '+++' > $filename
echo 'categories = ["log"]' >> $filename
echo 'date = "'$timestamp'"' >> $filename
echo 'tags = ["log"]' >> $filename
echo 'title = "!#title#!"' >> $filename
echo 'link = "'$link'"' >> $filename
echo '' >> $filename
echo '+++' >> $filename
echo '' >> $filename
echo '<!--more-->' >> $filename

vim +'execute "normal! /!#title#!\<CR>"' $filename

git add $filename
git commit
