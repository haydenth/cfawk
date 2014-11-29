{
  # second file we're going to open
  # each line in the input has to open this independently
  # runs SO MUCH FASTER on SSD disks
  file = "/tmp/users.txt"
  split($1,group_i,",") # open file 1 csv
  while ((getline line < file) > 0) {
    split(line, group_j, ",") # open file 2 csv
    if (group_i[1] <= group_j[1]) {
      if (group_i[1] < group_j[1]) {
        n = sum1 = prodsum = sum2 = sum1sq = sum2sq = 0.0
        # here is where we compare all items in user1's vector
        # to user2's vector and generate the metrics for a 
        # correlation (see wikipedia page for defn of correlation)
        for (i=2; i<=length(group_i); i++){ 
          if (length(group_i[i]) != 0 && length(group_j[i]) != 0) {
          sum1 += group_i[i]
          sum1sq += (group_i[i] ** 2)
          sum2 += group_j[i]
          sum2sq += (group_j[i] ** 2)
          prodsum += group_j[i] * group_i[i]
          n++
          }
        }

        # if they have nothing in common, no correction
        if (n == 0) { correlation = 0 }

        # if they have at least one, compute the correlation
        # but use an adjustor to downplay 1-1 similarities
        if (n > 0) {
          numerator = prodsum - ((sum1 * sum2) / n)
          base_denom = sum1sq - ((sum1**2)/n) * (sum2sq - (sum2**2)/n)

          # min adjustment technique 
          # from: http://bit.ly/1vWVVzs
          if (n >= 50) min_adjustor = 1
          if (n < 50) min_adjustor = n / 50
  
          if (base_denom > 0) denom = sqrt(base_denom)
          
          if (denom == 0.0) { correlation = 0 }
          if (denom != 0) { correlation = (numerator / denom) * min_adjustor }
        }
        # output it all
        printf group_i[1] "," group_j[1] ",%1.5f\n", correlation
       }
    }
  }
  close(file)
}