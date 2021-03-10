FROM debian
COPY runonhost.sh /
COPY wait.sh /
RUN chmod u+x runonhost.sh
CMD ["./runonhost.sh"]