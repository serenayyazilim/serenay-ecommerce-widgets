# YOUTUBE

A single YouTube video embedded inline, auto-playing muted and looping.

```json
{
  "type": "YOUTUBE",
  "params": { "url": "https://www.youtube.com/watch?v=dQw4w9WgXcQ" }
}
```

`url` accepts any standard YouTube URL form (`watch?v=`, `youtu.be/`,
`/embed/`, `/shorts/`). Renders nothing if the video id can't be parsed
from `url`.
