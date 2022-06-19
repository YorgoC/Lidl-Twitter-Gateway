#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["lidl-twitter-gateway.csproj", "."]
RUN dotnet restore "./lidl-twitter-gateway.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "lidl-twitter-gateway.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "lidl-twitter-gateway.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "lidl-twitter-gateway.dll"]
