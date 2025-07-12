# Grab Alpine Linux base image
FROM public.ecr.aws/apryse/fluent-restful:latest AS base

# # Create a non-root user and group
# RUN addgroup -S tomcat && adduser -S -G tomcat tomcat

# Copy the tomcat installation to the /opt directory
COPY ./ /usr/local/tomcat/build

# Set correct permissions for Tomcat files
# RUN chown -R tomcat:tomcat /opt/apache-tomcat-9.0.107 && \
#     chmod +x /usr/local/tomcat/bin/*.sh
# Copy the entrypoint script
COPY entrypoint.sh /usr/local/tomcat/build/entrypoint.sh
RUN chmod +x /usr/local/tomcat/build/entrypoint.sh
RUN chmod +x /usr/local/tomcat/build/OfficeToPdf.exe
# Run as non-root
# USER tomcat
WORKDIR /usr/local/tomcat

ENTRYPOINT ["./build/entrypoint.sh"]


