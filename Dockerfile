# FROM ubuntu:latest AS build

# RUN apt-get update
# RUN apt-get install openjdk-17-jdk -y

# COPY . .

# RUN apt-get install maven -y
# RUN mvn clean install

# FROM openjdk:17-jdk-slim
# EXPOSE 80

# COPY --from=build target/todolist2-1.0.0.jar app.jar
# ENTRYPOINT [ "java", "-jar", "app.jar"]
# Estágio de build
FROM ubuntu:latest AS build

# Configuração inicial
RUN apt-get update && \
    apt-get install -y openjdk-17-jdk maven

# Configuração da pasta de trabalho
WORKDIR /app

# Copia apenas o arquivo pom.xml inicial para aproveitar o cache do Maven
COPY pom.xml .

# Baixa as dependências do Maven (isso é feito antes de copiar o restante do código-fonte)
RUN mvn dependency:go-offline

# Copia o restante do código-fonte
COPY src ./src

# Compila o código
RUN mvn package

# Estágio final
FROM openjdk:17-jdk-slim

# Configuração da pasta de trabalho
WORKDIR /app

# Expõe a porta 80
EXPOSE 80

# Copia o artefato construído do estágio de build
COPY --from=build /app/target/todolist2-1.0.0.jar app.jar

# Comando de execução
ENTRYPOINT ["java", "-jar", "app.jar"]
