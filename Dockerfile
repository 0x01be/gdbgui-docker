FROM alpine as build

RUN apk --no-cache add --virtual gdbgui-build-dependencies \
      build-base \
      python3-dev \
      py3-pip \
      libffi-dev

RUN pip3 install --prefix /opt/gdbgui gdbgui

FROM alpine

RUN apk --no-cache add --virtual gdbgui-runtime-dependencies \
      python3 \
      py3-six \
      gdb \
      g++ \
      libtool

COPY --from=build /opt/gdbgui/ /opt/gdbgui/

ENV PATH $PATH:/opt/gdbgui/bin/
ENV PYTHONPATH /usr/lib/python3.8/site-packages/:/opt/gdbgui/lib/python3.8/site-packages/

ENV PORT 5555

EXPOSE ${PORT}

WORKDIR /workspace

CMD gdbgui -r -n --port ${PORT}

