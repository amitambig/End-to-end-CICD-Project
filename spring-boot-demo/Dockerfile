FROM openjdk:17-jdk-alpine
WORKDIR /app

COPY target/spring-boot-demo-0.0.1-SNAPSHOT.jar app.jar

EXPOSE 8080
# This should not be changed
ENTRYPOINT ["java","-jar","app.jar"]
