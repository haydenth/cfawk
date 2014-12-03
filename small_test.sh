#head -4000 ml-100k/u1.test | gawk -F "\t" -f transform2.awk > /tmp/users.txt

# flatten out the sample set into a user-item matrix
echo "Processing input file"
cat ml-100k/u.data | gawk -f flatten_by_user.awk > /tmp/user_matrix.txt
wc /tmp/user_matrix.txt

# now convert these ratings to z-scores
echo "converting to z-scores"
cat /tmp/user_matrix.txt | gawk -f user_zscores.awk | sort -k1,1n -t, > /tmp/users.txt
wc /tmp/users.txt

# this generates the user-user matrix for one half of the matrix
echo "transforming and computing user-user matrix"
cat /tmp/users.txt | parallel --block 100K --pipe gawk -f blowup.awk > /tmp/half_matrix.txt
wc /tmp/half_matrix.txt

# this blows it out into a full matrix
echo "blowing matrix out into full matrix"
cat /tmp/half_matrix.txt | gawk 'BEGIN { FS="," } { print $1 "," $2 "," $3; print $2 "," $1 "," $3 }' > /tmp/full_matrix.txt
wc /tmp/full_matrix.txt

echo "reducing to top n per user"
cat /tmp/full_matrix.txt | sort -k1,1n -k3,3rn -t, | gawk 'BEGIN { FS = ","} { counts[$1]++; if(counts[$1]<=50) print $0 }' > /tmp/results_reduced.txt
wc /tmp/results_reduced.txt

echo "generating expected ratings"
cat /tmp/user_matrix.txt | gawk -f compute_ratings.awk | sort -k1,1n -t, > /tmp/recommend.txt
wc /tmp/recommend.txt
