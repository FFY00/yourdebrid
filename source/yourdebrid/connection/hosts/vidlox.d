/**
 * Authors: Filipe Laíns
 * License: AGPLv3 https://www.gnu.org/licenses/agpl-3.0.txt
 */

module yourdebrid.connection.hosts.vidlox;

import yourdebrid.model.host, yourdebrid.util.http, yourdebrid.util.config;
import std.uuid, std.file, std.json, std.net.curl, std.format, std.experimental.logger;
import std.uri : uriLength;

class Vidlox : Host {
    // Login
    private string key = "";


    unittest
    {
        import std.stdio, std.path;
        import std.datetime : SysTime, Clock, dur;

        auto config = new ConfigManager();
        Host host = new Vidlox(config);

        SysTime stattime = Clock.currTime();

        writeln("==============================");
        writeln("Testing Vidlox (vidlox)");
        writeln("==============================");

        writeln("\n" ~ host.upload(getcwd() ~ "/../test_files/nyan_cat.mp4") ~ "\n");

        writeln("\nVIDLOX upload() ==> ", Clock.currTime() - stattime, "\n");
    }

    this(ConfigManager config)
    {
        name = "vidlox";

        // Get login data
        auto data = config.getLoginData(name);
        if("login" in data && "key" in data)
            key = data["key"].str;

        // Get api key
        data = config.getProviderData(name);
        assert(data["driver"].str = "vidlox");
        if("api" in data)
            api = data["api"].str;
    }

    override public string upload(string file) {
        // Check if the keys exist and have the correct values
        bool sanityCheck(JSONValue j) {
            try {
                // Check for error (Ex.: Authetication failed)
                if(j["status"].integer == 403)
                    errorf("Erorr uploading to host '%s': %s", name, j["msg"]);

                return j["status"].integer != 200 || j["result"]["url"].str == "";
            } catch (JSONException e) {
                warningf("JSONException: %s", e.msg);
            }
            log("ret");
            return true;
        }

        auto url = get(format("%s/upload/server?key=%s", api, key));
        if (uriLength(url) == -1)
        {
            errorf("Invalid url: '%s'", url);
            return "";
        }
        auto res = getJson(cast(string) url);
        if(sanityCheck(res))
            return "";

        auto conn = new Http;
        conn.setUrl(res["result"]["url"].str);
        conn.setFile(file);

        res = getJson(conn.sendFile());
        if(sanityCheck(res))
            return "";

        return res["result"]["url"].str;
    }
}