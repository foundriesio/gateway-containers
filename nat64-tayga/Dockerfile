# Copyright (c) 2019 Foundries.io
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# STAGE 1
FROM alpine:latest as tayga-dev

# Based on work by Daneyon Hansen <danehans@cisco.com>
LABEL maintainer="Michael Scott <mike@foundries.io>"

ENV TAYGA_VERSION=0.9.2
ENV TAYGA_FILENAME=tayga-${TAYGA_VERSION}.tar.bz2
ENV TAYGA_FILE_MD5=7a7b24165ce008df772f398d86fa280e
ENV TAYGA_DOWNLOAD_URL=http://www.litech.org/tayga/${TAYGA_FILENAME}

# Install build tools
RUN apk add --no-cache \
	curl tar bzip2 libc-dev make gcc libc-dev linux-headers

RUN curl -O ${TAYGA_DOWNLOAD_URL}

# Split this line out so it's easy to see failure
RUN [ "$(md5sum ${TAYGA_FILENAME} | cut -d ' ' -f1)" == "${TAYGA_FILE_MD5}" ]

RUN bzip2 -dk ${TAYGA_FILENAME} \
	&& tar -xvf ${TAYGA_FILENAME} \
	&& cd tayga-${TAYGA_VERSION} \
	&& ./configure && make && make install

# STAGE 2
FROM alpine:latest

LABEL maintainer="Michael Scott <mike@foundries.io>"

RUN apk add --no-cache libstdc++ iproute2

COPY --from=tayga-dev /usr/local/etc/tayga.conf.example /usr/local/etc/tayga.conf.example
COPY --from=tayga-dev /usr/local/sbin/tayga /usr/local/sbin/tayga
COPY --from=tayga-dev /usr/local/share/man/man5/tayga.conf.5 /usr/local/share/man/man5/tayga.conf.5
COPY --from=tayga-dev /usr/local/share/man/man8/tayga.8 /usr/local/share/man/man8/tayga.8

COPY start.sh start.sh
RUN chmod +x start.sh

ENTRYPOINT ["/start.sh"]
