# Adding a New Event via Server (using `curl`)

This file documents how to send a `POST` request to the local admin API to register a new event. It is intended for language model agents or humans who need to script the operation.

## Endpoint

- **URL:** `http://localhost:3000/api/admin/events`
- **Method:** `POST`
- **Content-Type:** `application/json`

## Request Body

The API expects a JSON object with two keys:

- `event` – an object describing the event. At minimum it should include `id`, `title`, `description`, `type`, `populationChange`, `timestamp`, and any additional fields relevant to the event category or target territory.
- `territoryType` – a string that identifies which territory category the event belongs to (e.g. `forest`, `spaceStation`, `milestone`, etc.).

Example body:

```json
{
  "event": {
    "id": "evt_123456",
    "title": "New Colony Established",
    "description": "A new colony has been founded on Mars.",
    "type": "milestone",
    "populationChange": 0,
    "timestamp": 1710000000000
  },
  "territoryType": "milestone"
}
```

## Example `curl` Command

```bash
curl -X POST \
  http://localhost:3000/api/admin/events \
  -H "Content-Type: application/json" \
  -d '{
        "event": {
          "id": "evt_123456",
          "title": "New Colony Established",
          "description": "A new colony has been founded on Mars.",
          "type": "milestone",
          "populationChange": 0,
          "timestamp": 1710000000000
        },
        "territoryType": "milestone"
      }'
```

> **Note:** When running against a development server, make sure it's running (`npm run dev`). For production, adjust the URL or authentication accordingly. If the server responds with `{"success":true}`, the event was added successfully.

This file can be referenced by automated agents or documentation to ensure consistency when interacting with the admin API.
