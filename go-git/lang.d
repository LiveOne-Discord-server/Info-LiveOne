import std.stdio;
import std.string;
import std.process;
import std.json;
import vibe.vibe;
import vibe.http.client;
import vibe.data.json;

class DiscordBot {
    private:
        string discordToken;
        string githubToken;
        string webhookUrl;

    public:
        this(string discordToken, string githubToken, string webhookUrl) {
            this.discordToken = discordToken;
            this.githubToken = githubToken;
            this.webhookUrl = webhookUrl;
        }

        void start() {
            writeln("Bot is starting...");
            // Here you would typically start your Discord bot
            // For simplicity, we'll just simulate receiving a GitHub event
            simulateGithubEvent();
        }

        void simulateGithubEvent() {
            writeln("Simulating a GitHub event...");
            string eventData = `{
                "repository": {"full_name": "user/repo"},
                "commits": [
                    {
                        "message": "Update README.md",
                        "author": {"name": "John Doe"}
                    }
                ]
            }`;

            sendToDiscord(parseGithubEvent(eventData));
        }

        string parseGithubEvent(string eventData) {
            auto jsonData = parseJsonString(eventData);
            string repoName = jsonData["repository"]["full_name"].get!string;
            string commitMessage = jsonData["commits"][0]["message"].get!string;
            string authorName = jsonData["commits"][0]["author"]["name"].get!string;

            return format("New commit in %s by %s: %s", repoName, authorName, commitMessage);
        }

        void sendToDiscord(string message) {
            writeln("Sending message to Discord: ", message);

            requestHTTP(webhookUrl,
                (scope req) {
                    req.method = HTTPMethod.POST;
                    req.writeJsonBody(["content": message]);
                },
                (scope res) {
                    if (res.statusCode == 204)
                        writeln("Message sent successfully");
                    else
                        writeln("Failed to send message. Status code: ", res.statusCode);
                }
            );
        }
}

void main() {
    auto bot = new DiscordBot(
        "YOUR_DISCORD_TOKEN",
        "YOUR_GITHUB_TOKEN",
        "YOUR_DISCORD_WEBHOOK_URL"
    );
    bot.start();
}