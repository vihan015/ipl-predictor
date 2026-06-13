import { useState } from "react";
import axios from "axios";
import "./App.css";

function App() {

  const teams = [
    { id: 1, name: "Royal Challengers Bangalore" },
    { id: 2, name: "Sunrisers Hyderabad" },
    { id: 3, name: "Mumbai Indians" },
    { id: 4, name: "Rising Pune Supergiant" },
    { id: 5, name: "Gujarat Lions" },
    { id: 6, name: "Kolkata Knight Riders" },
    { id: 129, name: "Chennai Super Kings" },
    { id: 134, name: "Rajasthan Royals" },
    { id: 252, name: "Delhi Capitals" },
    { id: 494, name: "Punjab Kings" },
    { id: 614, name: "Lucknow Super Giants" }
  ];

  const venues = [
    "Wankhede Stadium",
    "MA Chidambaram Stadium",
    "M Chinnaswamy Stadium",
    "Eden Gardens",
    "Rajiv Gandhi International Stadium",
    "Arun Jaitley Stadium",
    "Narendra Modi Stadium, Ahmedabad",
    "Punjab Cricket Association IS Bindra Stadium",
    "Sawai Mansingh Stadium",
    "Maharaja Yadavindra Singh International Cricket Stadium, Mullanpur"
  ];

  const [team1, setTeam1] = useState(3);
  const [team2, setTeam2] = useState(129);
  const [venue, setVenue] = useState("Wankhede Stadium");
  const [tossDecision, setTossDecision] = useState("field");
  const [inningsScore, setInningsScore] = useState(180);
  const [wicketsLost, setWicketsLost] = useState(6);

  const [result, setResult] = useState(null);
  const [loading, setLoading] = useState(false);

  const predict = async () => {

    if (team1 === team2) {
      alert("Please select different teams");
      return;
    }

    try {

      setLoading(true);

      const response = await axios.post(
        "http://localhost:8000/predict",
        {
          team1,
          team2,
          venue,
          toss_decision: tossDecision,
          innings_score: Number(inningsScore),
          wickets_lost: Number(wicketsLost)
        }
      );

      setResult(response.data);

    } catch (error) {

      console.error(error);
      alert("Prediction failed");

    } finally {

      setLoading(false);

    }
  };

  return (
    <div className="app">

      <div className="card">

        <h1>🏏 IPL Match Predictor</h1>
        <p className="subtitle">
          Random Forest + Genetic Algorithm
        </p>

        <div className="form-grid">

          <div className="field">
            <label>Team 1</label>
            <select
              value={team1}
              onChange={(e) => setTeam1(Number(e.target.value))}
            >
              {teams.map(team => (
                <option key={team.id} value={team.id}>
                  {team.name}
                </option>
              ))}
            </select>
          </div>

          <div className="field">
            <label>Team 2</label>
            <select
              value={team2}
              onChange={(e) => setTeam2(Number(e.target.value))}
            >
              {teams.map(team => (
                <option key={team.id} value={team.id}>
                  {team.name}
                </option>
              ))}
            </select>
          </div>

          <div className="field">
            <label>Venue</label>
            <select
              value={venue}
              onChange={(e) => setVenue(e.target.value)}
            >
              {venues.map(v => (
                <option key={v}>
                  {v}
                </option>
              ))}
            </select>
          </div>

          <div className="field">
            <label>Toss Decision</label>
            <select
              value={tossDecision}
              onChange={(e) => setTossDecision(e.target.value)}
            >
              <option value="bat">Bat</option>
              <option value="field">Field</option>
            </select>
          </div>

          <div className="field">
            <label>First Innings Score</label>
            <input
              type="number"
              value={inningsScore}
              onChange={(e) => setInningsScore(e.target.value)}
            />
          </div>

          <div className="field">
            <label>Wickets Lost</label>
            <input
              type="number"
              min="0"
              max="10"
              value={wicketsLost}
              onChange={(e) => setWicketsLost(e.target.value)}
            />
          </div>

        </div>

        <button
          className="predict-btn"
          onClick={predict}
        >
          {loading ? "Predicting..." : "Predict Match"}
        </button>

        {result && (
          <div className="result-card">

            <h2>{result.prediction}</h2>

            <div className="probability">

              <span>Team 1</span>

              <div className="bar">
                <div
                  className="fill"
                  style={{
                    width: `${result.team1_probability}%`
                  }}
                />
              </div>

              <strong>
                {result.team1_probability}%
              </strong>

            </div>

            <div className="probability">

              <span>Team 2</span>

              <div className="bar">
                <div
                  className="fill fill2"
                  style={{
                    width: `${result.team2_probability}%`
                  }}
                />
              </div>

              <strong>
                {result.team2_probability}%
              </strong>

            </div>

          </div>
        )}

      </div>

    </div>
  );
}

export default App;