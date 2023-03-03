FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 8000
EXPOSE 8443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["aspnetcoreapp.csproj", "."]
RUN dotnet restore "./aspnetcoreapp.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "aspnetcoreapp.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "aspnetcoreapp.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "aspnetcoreapp.dll"]