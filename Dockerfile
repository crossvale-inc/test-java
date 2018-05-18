FROM java:8

EXPOSE 8080

USER 1001

#CMD java -jar *.jar
CMD exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"
