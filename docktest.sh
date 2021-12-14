list="https://github.com/nextcloud/docker https://github.com/phpmyadmin/docker https://github.com/deviantony/docker-elk https://github.com/nginx-proxy/nginx-proxy https://github.com/sameersbn/docker-gitlab https://github.com/creack/docker-firefox"


for proj in $list
do
 docker build $proj
done
