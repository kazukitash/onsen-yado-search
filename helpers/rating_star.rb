def rating_star rating
  star      = rating.floor
  half_star = rating == star ? 0 : 1
  no_star   = 5 - star - half_star
  [star, half_star, no_star]
end
