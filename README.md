# donation-tracker-deployment

Donation Tracker を Docker で起動するためのプロジェクトです.

## For production

`.env` ファイルを用意して, `docker-compose` で起動します.

```sh
cp .env.production .env
```

```sh
docker-compose up -f docker-compose.yml --build -d
```

## For development

開発にも（多分）使えます. 開発時には `docker-compose.development.yml` を使います.

```sh
cp .env.development .env
```

```sh
docker-compose up -f docker-compose.development.yml --build -d
```