head -2000 ml-100k/u2.test | awk -F "\t" -f transform2.awk > /tmp/users.txt
#cat ml-100k/u1.test ml-100k/u2.test | awk -F "\t" -f transform2.awk > /tmp/users.txt
wc /tmp/users.txt
cat /tmp/users.txt | parallel --block 10K --progress --pipe awk -f blowup.awk > /tmp/results.txt
wc /tmp/results.txt
cat /tmp/results.txt | sort -k1,1n -k3,3n -t, > /tmp/results2.txt
