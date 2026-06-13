predict_match <- function(
  team1,
  team2,
  venue,
  toss_decision,
  innings_score,
  wickets_lost
) {
  history <- readRDS(
    "historical_data.rds"
  )

  model <- readRDS(
    "rf_ga_prob.rds"
  )

  new_row <- generate_features(
    team1 = team1,
    team2 = team2,
    venue = venue,
    toss_decision = toss_decision,
    innings_score = innings_score,
    wickets_lost = wickets_lost,
    history = history
  )

  probs <- predict(
    model,
    data = new_row
  )$predictions

  team2_prob <- probs[1, "1"]
  team1_prob <- probs[1, "0"]

  prediction <- ifelse(
    team2_prob >= 0.5,
    "Team 2 likely to win",
    "Team 1 likely to win"
  )

  list(
    team1_probability = round(team1_prob * 100, 2),
    team2_probability = round(team2_prob * 100, 2),
    prediction = prediction
  )
}
