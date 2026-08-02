# lobby — cross-repo tickets

Filter: `ref-lobby <word …>` · file work where the owning repo reads it
Protocol, states, entry shape: docs/operations/systems/lobby/

## lobby — skills

| keys            | does                                     |
|-----------------|------------------------------------------|
| ## read         | look, route, audit — start nothing       |
| /lobby          | the router — asks file · read · audit    |
| /lobby-list     | print THIS repo's queue, start nothing   |
| /lobby-hygiene  | ledger vs reality, both directions       |
|                 |                                          |
| ## file         | write a ticket INTO another repo         |
| /lobby-dotfiles | → scripts · configs · ref cards · desk   |
| /lobby-humpty   | → agent behaviour · muzzle · gates       |
| /lobby-web      | → kol-website content · UI               |
| /lobby-ds       | → kol-ds-ui components · tokens          |
| /lobby-icon     | → an SVG into the shared icon set        |

## lobby — scripts

| keys                         | does                               |
|------------------------------|------------------------------------|
| pfx C-k                      | lobby — fzf over all four queues   |
| lobby --counts               | queue · done · archived · out·owed |
| lobby --outbox               | receipts — filed out, what's owed  |
| lobby --paths                | the registered lobby paths         |
| ref-lobby                    | this card                          |
|                              |                                    |
| ## clip-drop                 | screenshot straight into a lobby   |
| clip-drop.sh --`<flag>` NAME | screenshot → entry + ledger row    |
| clip-drop.sh --lobby         | list the registered lobbies        |
| pfx C-p                      | the capture menu (clip-drop)       |

flags: `--dotfiles` · `--humpty` · `--kol-website` · `--kol-ds-ui`

## lobby — the receipt

filing writes `<this repo>/lobby/outbox/<slug>.md`; the CLOSER writes back to it.

| keys            | does                                     |
|-----------------|------------------------------------------|
| inbox/          | sent TO this repo — the queue            |
| outbox/         | filed BY this repo — the receipts        |
| 📌 remainder     | closed there, still owed HERE            |
| /ag-init        | prints 📌 first, at boot                  |

the destination ledger is the truth; a receipt is a dated copy of it.

----
doc: docs/operations/systems/lobby/05-lookup.md
