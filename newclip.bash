cd "$(dirname "$0")"

link="$(xclip -o)"
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
echo 'summary = ""' >> $filename
echo '' >> $filename
echo '+++' >> $filename

vim +'execute "normal! /!#title#!\<CR>"' $filename

git add $filename
git commit -m 'New log.'
