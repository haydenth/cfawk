{ arr[$1]=$1 } 
END{
  for (a in arr){ 
    split(arr[a],group_i,",")
    for (a2 in arr){ 
      sum1 = prodsum = sum2 = 0
      sum1sq = sum2sq = 0
      split(arr[a2],group_j,",")

      if (group_i[1] <= group_j[1]) {
        for (i=2; i<=length(group_i); i++){ 
          sum1 += group_i[i]
          sum1sq += group_i[i] ** 2
          sum2 += group_j[i]
          sum2sq += group_j[i] ** 2
          prodsum += group_j[i] * group_i[i]
        }
        numerator = prodsum - ((sum1 * sum2) / length(group_i)-1)
        denom = sqrt((sum1sq - sum1**2)/length(group_i)-1 * ((sum2sq - sum2 ** 2) / length(group_i)-1))
        if (denom == 0) { correlation = 0 }
        if (denom != 0) { correlation = numerator / denom }
        printf group_i[1] "," group_j[1] ",%1.5f\n", 1-correlation
      }
    }
  }
}
