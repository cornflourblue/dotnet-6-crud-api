FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env

LABEL maintaner="Fernando Constantino <const.fernando@gmail.com>"

# This Dockerfile was based on 

WORKDIR /WebApi

# Copy everything
COPY WebApi/ ./

# Restore as distinct layers
RUN dotnet restore

# Build and publish a release
RUN dotnet publish ./WebApi.csproj --self-contained --runtime linux-musl-x64 --configuration Release --output ./out

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:6.0-alpine

WORKDIR /WebApi

COPY --from=build-env /WebApi/out/ .

EXPOSE 4000

ENTRYPOINT ["dotnet", "WebApi.dll"]
