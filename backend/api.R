library(plumber)

source("feature_generator.R")
source("predict_function.R")

#* @filter cors
cors <- function(req, res){

  res$setHeader("Access-Control-Allow-Origin", "*")
  res$setHeader("Access-Control-Allow-Headers", "*")
  res$setHeader("Access-Control-Allow-Methods", "POST, GET, OPTIONS")

  if(req$REQUEST_METHOD == "OPTIONS"){
    res$status <- 200
    return(list())
  }

  plumber::forward()
}

#* Predict IPL match
#* @post /predict
predict_endpoint <- function(
  team1,
  team2,
  venue,
  toss_decision,
  innings_score,
  wickets_lost
){

  predict_match(
    team1 = as.numeric(team1),
    team2 = as.numeric(team2),
    venue = venue,
    toss_decision = toss_decision,
    innings_score = as.numeric(innings_score),
    wickets_lost = as.numeric(wickets_lost)
  )
}