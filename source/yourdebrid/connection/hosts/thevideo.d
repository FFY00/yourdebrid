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

        auto config = new ConfigManager();
        Host host = new Thevideo(config);

        SysTime stattime = Clock.currTime();

        writeln("==============================");
        writeln("Testing TheVideo");
        writeln("==============================");

        writeln("\n" ~ host.upload(getcwd() ~ "/../test_files/nyan_cat.mp4") ~ "\n");

        writeln("\nTHEVIDEO upload() ==> ", Clock.currTime() - stattime, "\n");
    }

    this()
    {
        this(new ConfigManager);
    }

    this(ConfigManager config)
    {
        base_url = "https://api.fruithosted.net/file";
        
        auto data = config.getData();
        if("thevideo" in data)
        {
            if("login" in data["thevideo"])
                login = data["thevideo"]["login"].str;

            if("key" in data["thevideo"])
                key = data["thevideo"]["key"].str;
        }
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