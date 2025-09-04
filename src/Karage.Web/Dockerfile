FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build

# Build arguments for versioning
ARG BUILD_CONFIGURATION=Release
ARG BUILD_NUMBER=1
ARG GIT_COMMIT_HASH=unknown
ARG BUILD_SOURCEBRANCHNAME=main
ARG ASPNETCORE_ENVIRONMENT=Production

WORKDIR /src
COPY *.props .
COPY ["src/Karage.Domain/Karage.Domain.csproj", "Karage.Domain/"]
COPY ["src/Karage.Infrastructure/Karage.Infrastructure.csproj", "Karage.Infrastructure/"]
COPY ["src/Karage.Web/Karage.Web.csproj", "Karage.Web/"]
RUN dotnet restore "./Karage.Web/Karage.Web.csproj" --locked-mode
COPY src/ .

# Build with version information
RUN dotnet publish "/src/Karage.Web/Karage.Web.csproj" \
    -c $BUILD_CONFIGURATION \
    -o /app \
    -p:BuildNumber=$BUILD_NUMBER \
    -p:GitCommitHash=$GIT_COMMIT_HASH \
    -p:BUILD_SOURCEBRANCHNAME=$BUILD_SOURCEBRANCHNAME \
    -p:ASPNETCORE_ENVIRONMENT=$ASPNETCORE_ENVIRONMENT

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:9.0
WORKDIR /app
COPY --from=build /app .
USER app
EXPOSE 8080
ENTRYPOINT ["dotnet", "Karage.Web.dll"]