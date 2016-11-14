FROM profootballfocus/phoenix:1.2.1

# Remove the startup service
RUN rm -rf /etc/service/app