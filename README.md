# Ralph

Ralph is the [LevelUp](https://www.thelevelup.com) Platform team's lovable [Zulip](https://zulipchat.com) chat bot.

## Usage

You'll need to set the following environment variables:

| Name | Description | Example |
|------|-------------|---------|
| `BOT_NAME` | The name to which your bot will respond. | `Ralph` |
| `ZULIP_API_KEY` | Your Zulip bot's [API key](https://zulipchat.com/api/rest). | `443e78ed81c758c6ebcbcfea` |
| `ZULIP_EMAIL` | Your Zulip bot's email. | `ralph-bot@zulipchat.com` |
| `ZULIP_HOST` | Your Zulip server's hostname. | `example.zulipchat.com` |

These environment variables are required in a non-development environment:

| Name | Description | Default |
|------|-------------|---------|
| `DATABASE_URL` | PostgreSQL [connection URI](https://www.postgresql.org/docs/current/libpq-connect.html#id-1.7.3.8.3.6). | `postgres://user:pass@host:port/database` |

These environment variables are optional:

| Name | Description | Default |
|------|-------------|---------|
| `DB_STATEMENT_TIMEOUT` | PostgreSQL [statement timeout](https://www.postgresql.org/docs/current/runtime-config-client.html). | `30s` |
| `RALPH_ENV` | Ralph's environment. There must be a matching environment config file at `config/environments/${RALPH_ENV}.rb`. | `development` |

Then, install dependencies and start Ralph.

```sh
bundle install
bin/ralph
```

## Contributing

Contributions are welcome!

To get started, create a `.env` file for your development environment and set your own Zulip credentials, and install gem dependencies.

```sh
cp example.env .env
bundle install
```

Create a development database and load the current schema.

```sh
bin/rake db:create
bin/rake db:schema:load
```

To run Ralph, use `bin/ralph`.

```sh
bin/ralph
# Connecting to example.zulipchat.com as ralph-bot@zulipchat.com...
```

Before submitting a pull request, ensure your changes have adequate test coverage and adhere to the style guide.

```sh
bin/rspec
bin/rubocop
```

### Console

You can open a [Pry REPL](https://pry.github.io/) with Ralph's application environment loaded, similar to Ruby on Rails' console.

```sh
bin/console
```

### Database Migrations

To generate a new database migration, use the `generate:migration` Rake task.

```sh
bin/rake generate:migration[name_of_migration]
# Created db/migrations/20200510233313_name_of_migration.rb
```

See `bin/rake -T` for a list of other database Rake tasks, including `db:migrate`, `db:migrate:status` and `db:rollback`.

## License

MIT
