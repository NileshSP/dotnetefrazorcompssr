#.net core with sql file process
FROM microsoft/dotnet:2.1-sdk AS builder
WORKDIR /app

COPY ./DotnetEFRazorCompSSR.App/*.csproj ./
#RUN dotnet restore DotnetEFRazorCompSSR.csproj
COPY ./DotnetEFRazorCompSSR.App ./
RUN dotnet build DotnetEFRazorCompSSR.App.csproj -c Release 
#--no-restore

RUN dotnet publish DotnetEFRazorCompSSR.App.csproj -c Release -o out --no-restore

COPY ./DotnetEFRazorCompSSR.Server/*.csproj ./
#RUN dotnet restore DotnetEFRazorCompSSR.csproj
COPY ./DotnetEFRazorCompSSR.Server ./
RUN dotnet build DotnetEFRazorCompSSR.Server.csproj -c Release 
#--no-restore

RUN dotnet publish DotnetEFRazorCompSSR.Server.csproj -c Release -o out --no-restore

FROM nginx:alpine
COPY ./DotnetEFRazorCompSSR.Server/bin/Release/netcoreapp2.1/publish /usr/share/nginx/html/
COPY nginx.conf /etc/nginx/nginx.conf

#FROM microsoft/dotnet:2.1-aspnetcore-runtime
#WORKDIR /app
#COPY --from=builder /app/out .
#CMD ASPNETCORE_URLS=http://*:$PORT dotnet DotnetEFRazorCompSSR.Server.dll
#ENTRYPOINT ["dotnet", "DotnetEFRazorCompSSR.dll"]