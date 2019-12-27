FROM openjdk:8-jdk-slim
LABEL maintainer="zhangyaohui<yaohui.zhang@email.hypers.com>"
COPY target/*.jar /app.jar
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
CMD ["sh", "-c", "java -Djava.security.egd=file:/dev/./urandom $JVM_MEM_OPTS $JVM_GC_OPTS $JVM_GC_LOG_OPTS -jar /app.jar"]
EXPOSE 8000