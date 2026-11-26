# Stage 1: Build WAR bằng Maven và JDK 17
FROM maven:3.9.16-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn -B -ntp clean package -DskipTests

# Stage 2: Chạy ứng dụng bằng Tomcat 10.1
FROM tomcat:10.1.62-jdk17-temurin-jammy
ENV PORT=10000

# Xóa ứng dụng mẫu ROOT của Tomcat
RUN rm -rf /usr/local/tomcat/webapps/*

# Triển khai ứng dụng tại context root: /
COPY --from=build /app/target/bai9-download-solution.war /usr/local/tomcat/webapps/ROOT.war

# Render dùng PORT (mặc định 10000)
EXPOSE 10000
CMD ["sh", "-c", "PORT=\"${PORT:-10000}\"; sed -i \"s/<Connector port=\\\"8080\\\"/<Connector address=\\\"0.0.0.0\\\" port=\\\"${PORT}\\\"/\" /usr/local/tomcat/conf/server.xml; exec catalina.sh run"]
