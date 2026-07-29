# FASTREGISTER

A static WhatsApp quick-registration card: a 3-step explainer (enter number,
send the code, talk to a rep), a country code + phone field, and a "Send"
button that opens a WhatsApp chat with that number.

```json
{ "type": "FASTREGISTER", "params": {} }
```

`params` is currently unused — reserved by the backend contract for future
configuration. The country code list is a small fixed set built into the
widget (`+90`, `+1`, `+44`, `+49`, `+7`); there is no callback for this
widget since it only opens an external `https://wa.me/<number>` link.
