# This script performs a speed test against fast.com
# Avoids any pre-requirements
# Tested on Unifi USG


# 10 and 30 results in 2500MB
count=10||$1 # How many url endpoints fast.com will give back
max=30 # Change line 39 if you change me. Sets a loop count



echo "Starting"

# Gets the start time
st=$(awk 'BEGIN {srand(); print srand()}')

jobdir='/tmp/jobs'
mkdir -p $jobdir

# Not sure why first and next are separate, copied this behaviour from internet, doesn't matter too much.
first_sz=2048 
next_sz=26214400
j=0

first_xfer=$(expr $first_sz \* $count)
second_xfer=$(expr $next_sz \* $count \* $max)
total_xfer=$(expr $first_xfer + $second_xfer)


token=$(curl -s https://fast.com/app-ed402d.js|egrep -om1 'token:"[^"]+'|cut -f2 -d'"')
curl -s 'https://api.fast.com/netflix/speedtest/v2?https=true&urlCount='$count'&token='$token|egrep -o 'https[^"]+'|while read url
do
    j=$(expr $j + 1)

    first=${url/speedtest/speedtest\/range\/0-}$first_sz # Pretty sure this is in bits? :)
    next=${url/speedtest/speedtest\/range\/0-}$next_sz
    f=$(mktemp -p $jobdir)
    (curl -w "%{size_download}" -s -H 'Referer: https://fast.com/' -H 'Origin: https://fast.com' "$first" -o /dev/null > /dev/null
        for i in {1..30} # $max variable doesn't work here
            do 
                curl -w "%{size_download}" -s -H 'Referer: https://fast.com/' -H 'Origin: https://fast.com'  "$next" -o /dev/null > /dev/null
                rm -f $f
                if [ $i -eq $max ] && [ $j -eq $count ]; then
                    echo "Finish"
                    et=$(awk 'BEGIN {srand(); print srand()}')
                    rt=$(expr $et - $st)
                    speed=$(expr $total_xfer / $rt / 1024 / 1024)

                    # Assumes that the last queued test job is finished
                    echo "Start: $st End: $et Runtime: $rt seconds Speed: $speed Mbps"
                fi
        done)&
done

