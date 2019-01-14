FROM microsoft/dotnet:2.1-sdk AS builder
WORKDIR /app
COPY ./DotnetEFRazorCompSSR.App ./DotnetEFRazorCompSSR.App
RUN dotnet build ./DotnetEFRazorCompSSR.App/DotnetEFRazorCompSSR.App.csproj 
COPY ./DotnetEFRazorCompSSR.Server ./DotnetEFRazorCompSSR.Server
RUN dotnet build ./DotnetEFRazorCompSSR.Server/DotnetEFRazorCompSSR.Server.csproj -c Release 
RUN dotnet publish ./DotnetEFRazorCompSSR.Server/DotnetEFRazorCompSSR.Server.csproj -c Release -o out --no-restore
FROM microsoft/dotnet:2.1-aspnetcore-runtime
WORKDIR /app
COPY --from=builder /app/DotnetEFRazorCompSSR.Server/out .
CMD ASPNETCORE_URLS=http://*:$PORT dotnet DotnetEFRazorCompSSR.Server.dll