head -4000 ml-100k/u1.test | gawk -F "\t" -f transform2.awk > /tmp/users.txt
#cat ml-100k/u1.test ml-100k/u2.test | awk -F "\t" -f transform2.awk > /tmp/users.txt
wc /tmp/users.txt
echo "transforming and computing user-user matix"
cat /tmp/users.txt | parallel --no-notice --block 10K --pipe gawk -f blowup.awk > /tmp/results.txt
wc /tmp/results.txt
echo "reducing to top n per user"
cat /tmp/results.txt | sort -k1,1n -k3,3rn -t, | gawk 'BEGIN { FS = ","} { counts[$1]++; if(counts[$1]<=20) print $0 }' > /tmp/results_reduced.txt
wc /tmp/results_reduced.txt
