# algorand-node

## Build Args
| Argument | Description | Default Value |
| --- | --- | --- |
| repo | The github repo to build from. | algorand/go-algorand |
| ref | The git ref (commit or branch) to build from | rel/stable |
| create_sandnet | Whether sandnet should be created | false |
| dev_mode | Whether sandnet should use DevMode. Has no affect if `create_sandnet` is false | true |

## Environment Variables
| Variable | Description | Default Value |
| --- | --- | --- |
| ALGOD_TOKEN | The token to use when using algod's HTTP endpoints | aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa |
| KMD_TOKEN | The token to use when using KMD's HTTP endpoints | aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa |
| ENABLE_DEVELOPER_API | Whether the developer API endpoints should be enabled | true |
| ARCHIVAL | Whether the node should configured as archival | false |
| NETWORK | Which network to connect to | mainnet |

# algorand-indexer

## Build Args

| Argument | Description | Default Value |
| --- | --- | --- |
| repo | The github repo to build from. | algorand/go-algorand |
| ref | The git ref (commit or branch) to build from | rel/stable |

## Environment Variables

| Variable | Description | Default Value |
| --- | --- | --- |
| POSTGRES_HOST | The hostname of the postgres server | indexer-db |
| POSTGRES_USER | The postgres user | algorand |
| POSTGRES_PASSWORD | The password for `POSTGRES_USER` | algorand |
| POSTGRES_DB | The name of the postgres database | indexer |
| ALGOD_HOST | The hostname of the algod HTTP API | algorand-node |
| ALGOD_PORT | The port of the algod HTTP API | 4001 |
| ALGOD_TOKEN | The token to use when using the algod HTTP API | aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa |
| LOG_LEVEL | Indexer log level | info |


