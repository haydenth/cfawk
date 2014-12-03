{
  split($1, user, ",")
  user_id = user[1]
  total_ratings = sum_squared_ratings = count = 0
  for (i=2; i<length(user); i++) {
    if(length(user[i]) > 0) {
      count++
      total_ratings += user[i]
    }
  }
  mean = total_ratings / count
  for (i=2; i<length(user); i++) {
    if(length(user[i]) > 0) {
      sum_squared_ratings += (user[i] - mean) ** 2
    }
  }
  stddev = sqrt(sum_squared_ratings / count)

  print user_id "," count "," mean "," stddev
}
