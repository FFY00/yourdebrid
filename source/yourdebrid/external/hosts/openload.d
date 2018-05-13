/**
 * Authors: Filipe Laíns
 * License: AGPLv3 https://www.gnu.org/licenses/agpl-3.0.txt
 */

module source.yourdebrid.external.hosts.openload;

import std.uuid, std.file, std.json, std.net.curl, std.format;
import yourdebrid.external.hosts.host, yourdebrid.util.http, yourdebrid.util.config;

import std.stdio;

class Openload : Host {
    private string login = "";
    private string key = "";

    unittest
    {
        import std.stdio, std.path;
        import std.datetime : SysTime, Clock, dur;

        auto config = new ConfigManager();
        Host host = new Openload(config);

        SysTime stattime = Clock.currTime();

        writeln("==============================");
        writeln("Testing Openload");
        writeln("==============================");

        writeln("\n" ~ host.upload(getcwd() ~ "/../test_files/nyan_cat.mp4") ~ "\n");

        writeln("\nOPENLOAD upload() ==> ", Clock.currTime() - stattime, "\n");
    }

    this(ConfigManager config)
    {
        base_url = "https://api.openload.co/1/file";

        auto data = config.getData();
        if("openload" in data)
        {
            if("login" in data["openload"])
                login = data["openload"]["login"].str;

            if("key" in data["openload"])
                key = data["openload"]["key"].str;
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