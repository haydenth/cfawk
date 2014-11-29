{
  # on input store into a couple arrays
  # user-movie-rating
  arr[$2][$1]=$3
  # this user's total scores
  user_review_scores[$2] += $3
  # number of reviews this user has
  user_review_counts[$2]++
  # numver of times this movie has been reviewed
  items[$1]++
}

# basic algorithm to go through each user and
# each item and generate a user-movie score
# based on the user's mean and sd adjusted 
# ratings
END{
  for (a in arr) {
    line = a
    sum_squares = 0
    mean_review = user_review_scores[a]/user_review_counts[a]
    for (i in arr[a]) { sum_squares += (arr[a][i] - mean_review) ** 2 }
    sd_review = sqrt(sum_squares)

    for (i in items) {
      if (arr[a][i]) {
        if (sd_review > 0 ) { line = line "," (arr[a][i] - mean_review)/sd_review }
        if (sd_review == 0) { line = line "," 0 }
      } else {
        line = line ","
      }
    }
    print line
  }
}
