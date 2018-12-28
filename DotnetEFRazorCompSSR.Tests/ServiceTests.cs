using DotnetEFRazorCompSSR.App.Models;
using DotnetEFRazorCompSSR.App.Services;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using NUnit.Framework;

namespace DotnetEFRazorCompSSR.Tests
{
    public class ServiceTests
    {
        private WebsiteDataService websiteService;
        private WebsitesContext testContext;

        [SetUp]
        public void Setup()
        {
            var services = new ServiceCollection();
            services.AddDbContext<WebsitesContext>(options => options.UseInMemoryDatabase(), ServiceLifetime.Singleton);
            services.AddSingleton<WebsiteDataService>();
            var serviceProvider = services.BuildServiceProvider();
            testContext = serviceProvider.GetService<WebsitesContext>();
            testContext.SeedData();
            websiteService = new WebsiteDataService(testContext);
        }

        [Test]
        public void WebsiteDataService_GetWebsitesAsync()
        {
            var result = websiteService.GetWebsitesAsync(null,null);
            Assert.True(result.Result.Count > 0);
        }

        [Test]
        public void WebsiteDataService_GetMinMaxDateAsync()
        {
            var result = websiteService.GetMinMaxDateAsync();
            Assert.IsNotNull(result.Result);
            Assert.IsNotNull(result.Result.MaxDate);
            Assert.IsNotNull(result.Result.MinDate);
        }
    }
}