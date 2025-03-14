FROM openjdk:17

WORKDIR /app

# Copy Java source code
COPY Watermark.java .

# Compile the Java file and put class in /app
RUN javac Watermark.java

# Set CMD to allow passing arguments at runtime
CMD ["java", "-cp", "/app", "Watermark"]

