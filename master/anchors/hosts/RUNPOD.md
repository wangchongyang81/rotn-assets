# RunPod, record

Date 2026-11-20. Training host for the pilot. Pod only.

## Auth
Header is `x-api-key`, NOT `Authorization: Bearer`. Bearer returns 401.
Endpoint POST https://api.runpod.io/graphql. `rest.runpod.io/v1` does not
resolve. `runpodctl` 3.1.1 sends Bearer and is therefore unusable; all calls
go through tools/runpod/gql.sh.
Key lives in ~/.runpod/config.toml, mode 600. Never in the repo.

## Quirks
`myself` returns null under a valid key. `creditBalance` is not on `User`.
`gpuTypes` works and is the reachability test.

## Open
4090-class stock per datacenter, unverified.
