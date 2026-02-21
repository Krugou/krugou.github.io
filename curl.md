Generate a new game event and provide ONLY the one-line curl command to create it. Use this exact format, replacing the placeholder data with your imaginary event, and output NOTHING else (no markdown, no backticks, no explanations) except the raw command:

curl -X POST http://localhost:3000/api/admin/events -H "Content-Type: application/json" -d '{ "event": { "id": "evt_random", "title": "Example Title", "description": "Example description.", "type": "disaster", "populationChange": -50, "timestamp": 1710000000000 }, "territoryType": "forest" }'

Note: The server currently accepts a JSON body with an `event` object and `territoryType`. If your local admin server requires auth, add headers as needed.
