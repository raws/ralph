# Ralph

Ralph is the [LevelUp](https://www.thelevelup.com) Platform team's lovable [Zulip](https://zulipchat.com) chat bot.

## Usage

You'll need to set the following environment variables:

| Name | Description | Example |
|------|-------------|---------|
| `ZULIP_API_KEY` | Your Zulip bot's [API key](https://zulipchat.com/api/rest). | `443e78ed81c758c6ebcbcfea` |
| `ZULIP_EMAIL` | Your Zulip bot's email. | `ralph-bot@zulipchat.com` |
| `ZULIP_HOST` | Your Zulip server's hostname. | `example.zulipchat.com` |

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

To run Ralph, use `bin/ralph`.

```sh
bin/ralph
# Connecting to example.zulipchat.com as ralph-bot@zulipchat.com...
```

Ensure your changes have adequate test coverage before submitting a pull request.

```sh
bin/rspec
```

## License

MIT
