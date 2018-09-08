/**
 * Authors: Filipe Laíns
 * License: AGPLv3 https://www.gnu.org/licenses/agpl-3.0.txt
 */
 
 module yourdebrid.model.host;

 import std.json, std.experimental.logger;

 class Host {
    protected:
        // Info
        string name = "";
        string api = "";

        // Parses the json data avoiding the JSONException
        protected JSONValue getJson(string data) {
            try {
                return parseJSON(data);
            } catch (JSONException e) {
                warningf("JSONException: %s", e.msg);
                return parseJSON("");
            }
        }

    public:
        /***********************************
        * Upload file
        *
        * Params:
        *      file =   Path of the file to upload
        *
        * Returns: Returned data from the server (usually JSON)
        */
        string upload(string file){
            return "";
        }
    
 }