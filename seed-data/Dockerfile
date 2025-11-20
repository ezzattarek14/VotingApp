FROM python:3.11-alpine

WORKDIR /app
COPY generate-votes.sh .
COPY make-data.py .
COPY posta .
COPY postb .

RUN apk add --no-cache curl apache2-utils bash \
    && chmod +x generate-votes.sh

CMD ["./generate-votes.sh"]

