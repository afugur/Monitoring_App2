// Hubs/FlutterMyHub.cs
using Microsoft.AspNetCore.SignalR;
using System.Threading.Tasks;

namespace FlutterBackend.Hubs
{
    public class FlutterMyHub : Hub
    {
        public async Task SendMessage(object data)
        {
            await Clients.All.SendAsync("ReceiveMessage", data);
        }
    }
}
