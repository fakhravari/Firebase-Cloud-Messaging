using FirebaseAdmin.Messaging;
using Microsoft.AspNetCore.Mvc;

namespace FirebaseDataMessages.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class WeatherForecastController : ControllerBase
    {
        [HttpGet]
        public async Task<IActionResult> Get()
        {
            var deviceTokens = new List<string>();
            var result = new List<string>();

            deviceTokens.Add("dTAJGqJTS_OlBIuEuI1fTj:APA91bFksnhq2jvOJLbFWtotzoDaq1hZXWoRwxwwNLllsI_K1hArrAHmhtymtU7owR1hrHiHdXOK_i-7HENHwkr4W3eSt8XQKlDcbZpd-Ds6BEcaRoWnJsYjIiRECUFRi5dx_iGs3QrU");
            deviceTokens.Add("d11J1fmnT66Y6Q_s_bo-ri:APA91bH_sp9tyzLHHHKQfbHz12vPa1XoDUyLKj9sWV3TjPHTkHnA_sY722cY9T-wL4oN1h8Su-yeXUiTtK1RHIkNR2VkaFacRZZ8WA7YMZdFguxjR3zs4JyrJZlGdtC5kTek4c2zgWn8");
            deviceTokens.Add("fkj-VvmjSc2BuHW80mNseZ:APA91bG9Ti5IWJqmKu2Uu7ElJ8nBe2qVlv47900gjVoOnjsnla4bCtbwGvqGflc1fGR75_QL_lDeVoBP8WrdS7WkNja0vZmhgMT4hUmXmOGxTRA-nrIbGWpv7UXDflw1KMXJtkpl7ECI");

            foreach (var item in deviceTokens)
            {
                try
                {
                    var message = new Message()
                    {
                        Token = item,
                        Notification = new Notification()
                        {
                            Title = "سلام، جوکاری",
                            Body = "محمدحسین فخرآوری"
                        },
                        Data = new Dictionary<string, string>()
                        {
                            { "key1", "مقدار 1" },
                            { "key2", "مقدار 2" }
                        }
                    };
                    string response = await FirebaseMessaging.DefaultInstance.SendAsync(message);
                    result.Add("Successfully sent message: " + response);
                }
                catch (FirebaseMessagingException ex)
                {
                    result.Add("Error sending message: " + ex.Message);
                }
            }

            return Ok(result);
        }
    }
}

