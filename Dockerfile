FROM microsoft/dotnet:2.1-sdk AS builder
WORKDIR /app
COPY ./DotnetEFRazorCompSSR.App/*.csproj ./DotnetEFRazorCompSSR.App/*.csproj
COPY ./DotnetEFRazorCompSSR.App ./DotnetEFRazorCompSSR.App
RUN dotnet build ./DotnetEFRazorCompSSR.App/DotnetEFRazorCompSSR.App.csproj 
RUN dotnet publish ./DotnetEFRazorCompSSR.App/DotnetEFRazorCompSSR.App.csproj 
COPY ./DotnetEFRazorCompSSR.Server/*.csproj ./DotnetEFRazorCompSSR.Server/*.csproj
COPY ./DotnetEFRazorCompSSR.Server ./DotnetEFRazorCompSSR.Server
RUN dotnet build ./DotnetEFRazorCompSSR.Server/DotnetEFRazorCompSSR.Server.csproj -c Release 
RUN dotnet publish ./DotnetEFRazorCompSSR.Server/DotnetEFRazorCompSSR.Server.csproj -c Release -o out --no-restore
FROM nginx:alpine
COPY ./DotnetEFRazorCompSSR.Server/nginx.conf /etc/nginx/nginx.conf
COPY --from=builder /app .
COPY . /usr/share/nginx/html/

#FROM microsoft/dotnet:2.1-aspnetcore-runtime
#WORKDIR /app
#COPY --from=builder /app/out .
#CMD ASPNETCORE_URLS=http://*:$PORT dotnet DotnetEFRazorCompSSR.Server.dll
#ENTRYPOINT ["dotnet", "DotnetEFRazorCompSSR.dll"]