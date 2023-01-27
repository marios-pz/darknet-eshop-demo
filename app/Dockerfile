FROM python:3.9-alpine3.17

RUN adduser -D backend \
    && echo "backend:password" | chpasswd

WORKDIR /home/python-user/app

COPY .  /home/python-user/app

ENV MARIADB_ROOT_PASSWORD="password"
ENV MARIADB_ALLOW_EMPTY_ROOT_PASSWORD="no"
ENV MARIADB_ROOT_HOST="%"
ENV MARIADB_DATABASE="ESHOP"

RUN python3 -m pip install -r requirements.txt

CMD [ "main.py" ]

ENTRYPOINT [ "python3" ]
