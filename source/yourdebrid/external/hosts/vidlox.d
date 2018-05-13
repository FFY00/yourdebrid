/**
 * Authors: Filipe Laíns
 * License: AGPLv3 https://www.gnu.org/licenses/agpl-3.0.txt
 */

module source.yourdebrid.external.hosts.vidlox;

import std.uuid, std.file, std.json, std.net.curl, std.format;
import yourdebrid.external.hosts.host, yourdebrid.util.http, yourdebrid.util.config;

class Vidlox : Host {
    private string key = "";

    unittest
    {
        import std.stdio, std.path;
        import std.datetime : SysTime, Clock, dur;

        auto config = new ConfigManager();
        Host host = new Vidlox(config);

        SysTime stattime = Clock.currTime();

        writeln("==============================");
        writeln("Testing Vidlox");
        writeln("==============================");

        writeln("\n" ~ host.upload(getcwd() ~ "/../test_files/nyan_cat.mp4") ~ "\n");

        writeln("\nVIDLOX upload() ==> ", Clock.currTime() - stattime, "\n");
    }

    this(ConfigManager config)
    {
        base_url = "https://vidlox.me/api";
        
        auto data = config.getData();
        if("vidlox" in data)
            if("key" in data["vidlox"])
                key = data["vidlox"]["key"].str;
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
        auto j = getData(format("%s/upload/server?key=%s",
                                    base_url, key));

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