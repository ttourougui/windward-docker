# Grab Alpine Linux base image
FROM alpine:latest AS base

# Add necessary tools
RUN apk update && \
    apk upgrade && \
    apk add --no-cache bash openjdk8

# Create a non-root user and group
RUN addgroup -S tomcat && adduser -S -G tomcat tomcat

# Copy the tomcat installation to the /opt directory
COPY ./ /opt

# Set correct permissions for Tomcat files
RUN chown -R tomcat:tomcat /opt/apache-tomcat-9.0.107 && \
    chmod +x /opt/apache-tomcat-9.0.107/bin/*.sh
# Copy the entrypoint script
COPY entrypoint.sh /opt/apache-tomcat-9.0.107/entrypoint.sh
RUN chmod +x /opt/apache-tomcat-9.0.107/entrypoint.sh

# Run as non-root
USER tomcat
WORKDIR /opt/apache-tomcat-9.0.107

ENTRYPOINT ["./entrypoint.sh"]


