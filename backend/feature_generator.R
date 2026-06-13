library(dplyr)

generate_features <- function(
  team1,
  team2,
  venue,
  toss_decision,
  innings_score,
  wickets_lost,
  history
) {
  venue_matches <- history %>%
    filter(venue == !!venue)

  venue_avg_score <-
    if (nrow(venue_matches) == 0) {
      mean(history$innings_score)
    } else {
      mean(venue_matches$innings_score)
    }

  score_above_venue_avg <-
    innings_score - venue_avg_score

  team2_matches <- history %>%
    filter(team2 == !!team2)

  team2_avg_chase_score <-
    if (nrow(team2_matches) == 0) {
      mean(history$innings_score)
    } else {
      mean(team2_matches$innings_score)
    }

  team1_matches <- history %>%
    filter(team1 == !!team1)

  team1_avg_defend_score <-
    if (nrow(team1_matches) == 0) {
      mean(history$innings_score)
    } else {
      mean(team1_matches$innings_score)
    }

  score_vs_venue_avg <-
    innings_score / venue_avg_score

  team1_venue_matches <- history %>%
    filter(
      team1 == !!team1,
      venue == !!venue
    )

  team1_avg_score_at_venue <-
    if (nrow(team1_venue_matches) == 0) {
      mean(history$innings_score)
    } else {
      mean(team1_venue_matches$innings_score)
    }

  venue_score_matches <- history %>%
    filter(
      venue == !!venue,
      innings_score >= innings_score - 5,
      innings_score <= innings_score + 5
    )

  venue_score_win_rate <-
    if (nrow(venue_score_matches) < 5) {
      mean(history$team2_win)
    } else {
      mean(venue_score_matches$team2_win)
    }

  recent_team1 <- history %>%
    filter(
      team1 == !!team1 |
        team2 == !!team1
    ) %>%
    tail(5)

  if (nrow(recent_team1) == 0) {
    team1_recent_win_rate <- 0.5
  } else {
    wins <- 0

    for (i in 1:nrow(recent_team1)) {
      row <- recent_team1[i, ]

      if (row$team1 == team1) {
        wins <- wins + (1 - row$team2_win)
      } else {
        wins <- wins + row$team2_win
      }
    }

    team1_recent_win_rate <-
      wins / nrow(recent_team1)
  }

  recent_chases <- history %>%
    filter(team2 == !!team2) %>%
    tail(5)

  team2_recent_chase_rate <-
    if (nrow(recent_chases) == 0) {
      0.5
    } else {
      mean(recent_chases$team2_win)
    }

  team2_venue_matches <- history %>%
    filter(
      team2 == !!team2,
      venue == !!venue
    )

  team2_avg_score_at_venue <-
    if (nrow(team2_venue_matches) == 0) {
      mean(history$innings_score)
    } else {
      mean(team2_venue_matches$innings_score)
    }

  score_pressure <-
    innings_score -
    team2_avg_score_at_venue

  data.frame(
    venue = venue,
    team2 = team2,
    toss_decision = toss_decision,
    wickets_lost = wickets_lost,
    score_above_venue_avg = score_above_venue_avg,
    team2_avg_chase_score = team2_avg_chase_score,
    team1_avg_defend_score = team1_avg_defend_score,
    score_vs_venue_avg = score_vs_venue_avg,
    team1_avg_score_at_venue = team1_avg_score_at_venue,
    venue_score_win_rate = venue_score_win_rate,
    team1_recent_win_rate = team1_recent_win_rate,
    team2_recent_chase_rate = team2_recent_chase_rate,
    score_pressure = score_pressure
  )
}
