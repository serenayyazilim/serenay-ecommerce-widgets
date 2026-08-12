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

The card's border/header/text accent color reads from
`EcommerceWidgetTheme.fastRegisterAccentColor` (defaults to WhatsApp green)
instead of a hardcoded color, so it can be re-branded like the rest of the
catalog. If the WhatsApp link can't be opened (e.g. WhatsApp isn't
installed), a snackbar shows `theme.fastRegisterLaunchFailedLabel`.
