/**
 * Authors: Filipe Laíns
 * License: AGPLv3 https://www.gnu.org/licenses/agpl-3.0.txt
 */

module yourdebrid.connection.hosts.openload;

import yourdebrid.model.host,
    yourdebrid.util.http,
    yourdebrid.util.config;
import std.uuid, std.file,
    std.json, std.net.curl,
    std.format,
    std.experimental.logger;
import std.uri : uriLength;

class Openload : Host
{
    // Login
    private string login = "";
    private string key = "";

    unittest
    {
        import std.stdio,
            std.path;
        import std.datetime : SysTime,
            Clock, dur;

        auto name = "streamango";

        auto config = new ConfigManager();
        Host host = new Openload(name, config);

        SysTime stattime = Clock.currTime();

        writeln("==============================");
        writeln("Testing Openload (" ~ name ~ ")");
        writeln("==============================");

        writeln("\n" ~ host.upload(getcwd() ~ "/../test_files/nyan_cat.mp4") ~ "\n");
        //writeln("\n" ~ host.upload("/srv/deluge/Downloads/the.young.kieslowski.2014.webl.aac.x264.mp4") ~ "\n");

        writeln("\nOPENLOAD upload() ==> ",
                Clock.currTime() - stattime, "\n");
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
        assert(data["driver"].str = "openload");
        if ("api" in data)
            api = data["api"].str;
    }

    override public string upload(string file)
    {
        // Check if the keys exist and have the correct values
        bool sanityCheck(JSONValue j)
        {
            try
            {
                // Check for error (Ex.: Authetication failed)
                if (j["status"].integer == 403)
                    errorf("Erorr uploading to host '%s': %s", name, j["msg"]);

                return j["status"].integer != 200 || j["result"]["url"].str == "";
            }
            catch (JSONException e)
            {
                warningf("JSONException: %s", e.msg);
            }
            log("ret");
            return true;
        }

        auto url = format("%s/file/ul?login=%s&key=%s", api, login, key);
        if (uriLength(url) == -1)
        {
            errorf("Invalid url: '%s'", url);
            return "";
        }
        auto res = getJson(cast(string) get(url));
        if (sanityCheck(res))
            return "";

        auto conn = new Http;
        conn.setUrl(res["result"]["url"].str);
        conn.setFile(file);

        res = getJson(conn.sendFile());
        if (sanityCheck(res))
            return "";

        return res["result"]["url"].str;
    }

}
