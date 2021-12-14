list="github.com/nextcloud/docker github.com/phpmyadmin/docker github.com/deviantony/docker-elk github.com/nginx-proxy/nginx-proxy github.com/sameersbn/docker-gitlab github.com/creack/docker-firefox"

IFS=" "
for proj in $list
do
 time docker build $proj
done
