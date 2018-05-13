/**
 * Authors: Filipe Laíns
 * License: AGPLv3 https://www.gnu.org/licenses/agpl-3.0.txt
 */

module yourdebrid.external.hosts.streamango;

import std.uuid, std.file, std.json, std.net.curl, std.format;
import yourdebrid.external.hosts.host, yourdebrid.util.http, yourdebrid.util.config;

class Streamango : Host {
    private string login = "";
    private string key = "";

    unittest
    {
        import std.stdio, std.path;
        import std.datetime : SysTime, Clock, dur;

        auto config = new ConfigManager();
        Host host = new Streamango(config);

        SysTime stattime = Clock.currTime();

        writeln("==============================");
        writeln("Testing Streamango");
        writeln("==============================");

        writeln("\n" ~ host.upload(getcwd() ~ "/../test_files/nyan_cat.mp4") ~ "\n");

        writeln("\nSTREAMANGO upload() ==> ", Clock.currTime() - stattime, "\n");
    }

    this()
    {
        this(new ConfigManager);
    }

    this(ConfigManager config)
    {
        base_url = "https://api.fruithosted.net/file";
        
        auto data = config.getData();
        if("openload" in data)
        {
            if("login" in data["streamango"])
                login = data["streamango"]["login"].str;

            if("key" in data["streamango"])
                key = data["streamango"]["key"].str;
        }
    }

    private JSONValue getData(string url)
    {
        string dir = "/tmp/yourdebrid";
        if(!dir.isDir())
            dir.mkdir();
        string file = dir ~ "/" ~ randomUUID().toString() ~ ".json";
        download(url, file);
        try
        {
            return parseJSON(readText(file));
        } catch (JSONException e) {
            return parseJSON("");
        }
    }

    override public string upload(string file){
        auto j = getData(format("%s/ul?login=%s&key=%s",
                                    base_url, login, key));

        try
        {
            if(j["status"].integer != 200 ||
                j["result"]["url"].str == "")
                return "";
        } catch (JSONException e) {
            return "";
        }

        auto conn = new Http;
        conn.setUrl(j["result"]["url"].str);
        conn.addFile(file);
        
        try
        {
            j = parseJSON(conn.send());
        } catch (Exception e) {
            return "";
        }

        try
        {
            if(j["status"].integer != 200 ||
                j["result"]["url"].str == "")
                return "";
        } catch (JSONException e) {
            return "";
        }

        return j["result"]["url"].str;
    }

}