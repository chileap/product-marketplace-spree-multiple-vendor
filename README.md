# Mall

This a dockerized [Spree Commerce](https://spreecommerce.org) application template ready to for local development and deployment to cloud providers.

## Deploy in the cloud

### Using Heroku
[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

## Local Installation

### Using Docker (Recommended)
#### Install required tools and dependencies:

* [Docker](https://www.docker.com/community-edition#/download)

#### Run setup script

```bash
bin/setup-docker
```

#### (Optional) Import sample data such as products, categories, etc

```bash
docker compose run web rake spree_sample:load
```

#### After the setup is finished, launch the webserver with:

```bash
bin/start-docker
```

### Using Hybrid installation
#### Install required tools and dependencies:

* [Docker](https://www.docker.com/community-edition#/download)
* Ruby 3.2.0
* [libvips](https://www.libvips.org/install.html)

#### Run setup script

```bash
bin/setup-hybrid
```


#### (Optional) Import sample data such as products, categories, etc

```bash
bundle exec rake spree_sample:load
```

#### After loading all docker dependencies launch local server with:

```bash
bin/start-hybrid
```

### Without Docker (not recommended for beginners)

#### Install required tools and dependencies

1. HomeBrew - https://brew.sh/
2. Install required packages: GPG, PostgreSQL, Redis, ImageMagick, and VIPS

      ```bash
      brew install gpg postgresql redis imagemagick vips
      createuser -P -d postgres
      ```

3. RVM - https://rvm.io/
4. NVM - https://github.com/nvm-sh/nvm
5. Ruby - `rvm install 3.2.0`
6. Node - `nvm install`
7. Yarn - `npm -g install yarn`

#### Run setup script

```bash
bin/setup-no-docker
```

## Updating

### Connect to the docker container
```bash
docker compose run web bash
```

### Run update commands

```
bundle update
bin/rails spree:install:migrations
bin/rails db:migrate
```

For additional instructions please visit [Spree Upgrade Guides](https://dev-docs.spreecommerce.org/upgrades)

## Development

### Launching rails console

```bash
docker compose run web rails c
```

### Launching bash console

```bash
docker compose run web bash
```

## Customization
### Adding new gems

Update `Gemfile` and run

```bash
bundle install
docker compose build
```

You will need to restart the server if running:

```bash
docker compose restart
```

## Environment variables

| variable | description | default value |
|---|---|---|
| DEBUG_ASSETS | Enables/disables [asset debugging in development](https://guides.rubyonrails.org/asset_pipeline.html#turning-debugging-off) | false |
| DB_POOL | database connection pool | 5 |
| MEMCACHED_POOL_SIZE | memcache connection pool | 5 |
| SENDGRID_API_KEY | API key to interface Sendgrid API | |

### uninitialized constant Spree::Preference (NameError)

If upgrading your spree app to Rails 7, you may run into the following error:
```shell
/lib/spree/core/preferences/store.rb:96:in `should_persist?':
uninitialized constant Spree::Preference (NameError)
```
To fix this error, you'll need to update your spree config initializer. In `config/initializers/spree.rb`, wrap the `Spree.config` block in a `Rails.application.config.after_initialize` block, like so:
```ruby
Rails.application.config.after_initialize do
  Spree.config do |config|
    # config settings initialized here
  end
end
```
