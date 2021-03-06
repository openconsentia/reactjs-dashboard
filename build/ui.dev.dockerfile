FROM node:13.10.1 as npminstall

WORKDIR /opt

COPY ./ui/dep.sh ./dep.sh
COPY ./ui/package.json ./package.json

RUN ./dep.sh

FROM node:13.10.1

WORKDIR /opt

COPY --from=npminstall /opt/node_modules ./node_modules
COPY --from=npminstall /opt/package-lock.json ./package-lock.json
COPY --from=npminstall /opt/package.json /opt/package.json

CMD ["npm","run","dev:run"]