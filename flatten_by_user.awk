{
  users[$1][$2]=$3
  items[$2]++
}

END{
  for (u in users) {
    line = u
    for (i in items) {
      line = line "," users[u][i]
    }
    print line
  }
}
