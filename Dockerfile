# syntax=docker/dockerfile:1
FROM node:14-alpine AS node-build
COPY ./donation-tracker /donation-tracker
WORKDIR /donation-tracker

RUN yarn
RUN yarn build

FROM python:3.9 AS django-base
ENV PYTHONUNBUFFERED=1

RUN apt-get -y update
RUN apt-get -y install locales gettext
RUN echo "ja_JP UTF-8" > /etc/locale.gen
RUN echo "en_US UTF-8" > /etc/locale.gen
RUN locale-gen

COPY --from=node-build /donation-tracker /app/donation-tracker
COPY ./tracker_deployment /app/tracker_deployment
COPY .env /app/tracker_deployment/.env
COPY ./manage.py /app/manage.py
COPY ./requirements.txt /app/requirements.txt
WORKDIR /app
RUN pip install -r requirements.txt
RUN python manage.py compilemessages
RUN python manage.py collectstatic --no-input

FROM django-base AS tracker-gunicorn

RUN pip install gunicorn

EXPOSE 8000
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "tracker_deployment.wsgi"]

FROM django-base AS tracker-daphne

RUN pip install daphne

EXPOSE 8000
CMD ["daphne", "-b", "0.0.0.0", "-p", "8000", "tracker_deployment.routing:application"]

FROM nginx AS web-nginx
COPY --from=django-base /static /var/www/tracker.rtain.jp/public/static
COPY ./nginx/nginx.conf /etc/nginx/conf.d/default.conf