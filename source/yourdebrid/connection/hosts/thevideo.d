/**
 * Authors: Filipe Laíns
 * License: AGPLv3 https://www.gnu.org/licenses/agpl-3.0.txt
 */

module yourdebrid.connection.hosts.thevideo;

import std.net.curl;
import yourdebrid.model.host, yourdebrid.util.config;

class Thevideo : Host {
    private string login = "";
    private string key = "";

    unittest
    {
        import std.stdio, std.path, std.file;
        import std.datetime : SysTime, Clock, dur;

        auto name = "thevideo";

        auto config = new ConfigManager();
        Host host = new Thevideo(name, config);

        SysTime stattime = Clock.currTime();

        writeln("==============================");
        writeln("Testing TheVideo");
        writeln("==============================");

        writeln("\n" ~ host.upload(getcwd() ~ "/../test_files/nyan_cat.mp4") ~ "\n");

        writeln("\nTHEVIDEO upload() ==> ", Clock.currTime() - stattime, "\n");
    }

    this(string name)
    {
        this(name, new ConfigManager);
    }

    this(string name, ConfigManager config)
    {
        this.name = name;

        // Get login data
        auto data = config.getLoginData(name);
        if ("login" in data && "key" in data)
        {
            login = data["login"].str;
            key = data["key"].str;
        }

        // Get api key
        data = config.getProviderData(name);
        assert(data["driver"].str = "thevideo");
        if ("api" in data)
            api = data["api"].str;
    }

    override public string upload(string file)
    {
        FTP conn = FTP();
        conn.setAuthentication(login, key);
        try
        {
            std.net.curl.upload(file, "ftp.thevideo.me", conn);
        } catch(CurlException e)
        {
            import std.stdio;
            writeln(e);
        }

        return "";
    }

}
