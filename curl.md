# Creating a Game Event with cURL

Generate a new game event and provide ONLY the one-line curl command to create it. Use this exact format, replacing the placeholder data with your imaginary event, and output NOTHING else (no markdown, no backticks, no explanations) except the raw command:

curl -X POST http://localhost:3000/api/admin/events -H "Content-Type: application/json" -d '{ "event": { "id": "evt_random", "title": { "en": "Example Title", "fi": "Esimerkin otsikko" }, "description": { "en": "Example description.", "fi": "Esimerkkikuvaus." }, "type": "disaster", "populationChange": -50, "timestamp": 1710000000000 }, "territoryType": "forest" }'

Note: The server currently accepts a JSON body with an `event` object and `territoryType`. If your local admin server requires auth, add headers as needed.

## Creating a New Territory Type with cURL

Generate a new territory definition and provide ONLY the one‑line curl command. Use this exact format, replacing the placeholder values with your imaginary territory and other configuration arrays, and output NOTHING else (no markdown, no backticks, no explanations) except the raw command:

curl -X POST http://localhost:3000/api/admin/config -H "Content-Type: application/json" -d '{ "territoryTypes": [{ "key":"new_territory", "en":"New Territory", "fi":"Uusi alue" }], "eventTypes": [{"key":"immigration","en":"Immigration","fi":"Maahanmuutto"},{"key":"emigration","en":"Emigration","fi":"Muutto ulkomaille"},{"key":"disaster","en":"Disaster","fi":"Kaatastrofi"},{"key":"opportunity","en":"Opportunity","fi":"Mahdollisuus"},{"key":"milestone","en":"Milestone","fi":"Virstanpylväs"}], "categories": [{"key":"opportunity","en":"Opportunity","fi":"Mahdollisuus"},{"key":"disaster","en":"Disaster","fi":"Kaatastrofi"},{"key":"milestone","en":"Milestone","fi":"Virstanpylväs"},{"key":"neutral","en":"Neutral","fi":"Neutraali"}] }'

Note: the `/api/admin/config` endpoint expects the full config object, so supply whatever arrays are already configured alongside your new territory. Each array may contain either simple string values (legacy) or objects with `key`, `en` and `fi` fields; the server will accept both forms. If authentication is required, include appropriate headers.
