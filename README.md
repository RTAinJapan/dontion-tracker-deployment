# donation-tracker-deployment

Donation Tracker を Docker で起動するためのプロジェクトです.

## Checkout submodule

Donation Tracker 本体を submodule として取得します.

```sh
git submodule init
git submodule update
```

## For production

`.env` ファイルを用意して, `docker-compose` で起動します.

```sh
cp .env.production .env
```

```sh
docker-compose -f "docker-compose.yml"  up -d --build
```

## For development

開発にも（多分）使えます. 開発時には `docker-compose.development.yml` を使います.

```sh
cp .env.development .env
```

.env の `APP_SECRET` には https://djecrety.ir/ などで生成した文字列を設定してください.

```sh
docker-compose -f "docker-compose.development.yml"  up -d --build
```

コンテナが立ち上がったら django のセットアップを行います.

```sh
# DBテーブルのマイグレーション
docker-compose exec gunicorn python manage.py migrate

# 管理ユーザ作成
docker-compose exec gunicorn python manage.py createsuperuser
```

以下の URL で donation tracker が見れるようになります.

- http://localhost:8080
- http://localhost:8080/admin
  - 管理画面には `createsuperuser` で作成したアカウントでログインできます.