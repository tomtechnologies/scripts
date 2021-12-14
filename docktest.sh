sudo apt-get update -y && sudo apt-get upgrade -y


list="github.com/nextcloud/docker github.com/phpmyadmin/docker github.com/deviantony/docker-elk github.com/nginx-proxy/nginx-proxy github.com/sameersbn/docker-gitlab github.com/creack/docker-firefox"

images=$(docker image ls | grep -v REPOS | awk '{print $3}')

IFS='\n'
for image in $images
do
 docker image rm $image # Will remove any existing images
done


IFS=" "
for proj in $list
do
 time docker build $proj --no-cache
done
