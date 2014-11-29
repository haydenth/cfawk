{
  arr[$2][$1]=$3
}

END{
  for (a in arr) {
    print a
    m=""
    for (v in arr[a]) {
      m=m "(" v arr[a][v] ")"
    }
    print a "\t" m
  }
}
