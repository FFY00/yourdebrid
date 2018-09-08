/**
 * Authors: Filipe Laíns
 * License: AGPLv3 https://www.gnu.org/licenses/agpl-3.0.txt
 */

module yourdebrid.util.config;

import std.path, std.file, std.json, std.experimental.logger;

/// Config manager class
class ConfigManager {
    private string path = "";
    private JSONValue authConfig;
    private JSONValue providerConfig;
    private string[] paths;

    this()
    {
        authConfig = findConfig("auth");
        providerConfig = findConfig("providers");
    }

    /// Finds the config file
    private JSONValue findConfig(string file)
    {
        paths = [getcwd() ~ "/" ~ file ~ ".json"];
        version(Posix)
        {
            paths ~= [  expandTilde("~/.config/yourdebrid/" ~ file ~ ".json"),
                        "/etc/yourdebrid/" ~ file ~ ".json"];
        } // TODO: Add windows specific paths

        findFile: foreach(entry; paths)
        {
            try
            {
                if(entry.isFile())
                {
                    path = entry;
                    break findFile;
                }
            } catch (Exception e) {}
        }

        if(path == "")
        {
            fatalf("Config file '%s.json' not found!", file);
        }

        return parseJSON(readText(path));
    }

    public JSONValue getLoginData(string name)
    {
        if(name in authConfig)
            return authConfig[name];
        
        warningf("Couldn't find login information for '%s'", name);
        return parseJSON("");
    }

    public JSONValue getProviderData(string name)
    {
        if(name in providerConfig)
            return providerConfig[name];
        
        warningf("Couldn't find provider information for '%s'", name);
        return parseJSON("");
    }
}