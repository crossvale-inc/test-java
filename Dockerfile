FROM java:8

EXPOSE 8080

USER 1001

CMD java -jar *.jar
