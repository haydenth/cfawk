BEGIN {
  CORRELATION_FILE = "/tmp/results_reduced.txt"
  while ((getline line < CORRELATION_FILE) > 0) {
    split(line, correlations, ",")
    user1 = correlations[1]
    user2 = correlations[2]
    score = correlations[3]
    corr_matrix[user1][user2] = score
  }
}

{
  split($1, user, ",")
  total_ratings = sum_squared_ratings = count = 0
  for (i=2; i<length(user); i++) {
    users[user[1]][i] = user[i]
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
  user_mean[user[1]] = mean
  user_stddev[user[1]] = sqrt(sum_squared_ratings)
}


END {
  for (u in users) {
    joined = "" 
    for (i=2; i<length(user); i++) {
      prediction = 0
      true_value = users[n][i]

      if (length(corr_matrix[u]) > 0) {
        for (n in corr_matrix[u]) {
          prediction += corr_matrix[u][n] * users[n][i]
        }
        predicted_score = (user_mean[u] + (prediction * user_stddev[u]))
        #if (predicted_score > 5) { predicted_score = 5 }
        if (predicted_score < 1) { predicted_score = 1 }

        joined = joined "," predicted_score 
        if (length(true_value) > 0) {
          error_count++
          total_errors += (predicted_score - true_value) ** 2
        }
      }
    }
    #print u "," user_review_counts[u] "," user_mean[u] "," user_stddev[u] > "/dev/stderr"
    print u "," joined
  }
  print "RMSE = " sqrt(total_errors/error_count) > "/dev/stderr"
}
