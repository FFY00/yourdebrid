/**
 * Authors: Filipe Laíns
 * License: AGPLv3 https://www.gnu.org/licenses/agpl-3.0.txt
 */

module yourdebrid.external.sources.rarbg;

import yourdebrid.external.sources.source;
import yourdebrid.util;
import std.net.curl, std.json, std.algorithm, std.uni, std.format;
import std.container : DList;
import std.datetime : SysTime, Clock, dur;
import std.range.primitives : walkLength;

class RarbgSource : Source {
    private const string url = "https://torrentapi.org/pubapi_v2.php?app_id=yourdebrid&";
    private string token = "";
    SysTime tokenlife;

    private string getRarbgToken()
    {
        if(Clock.currTime() > tokenlife){
            auto j = parseJSON(get(format("%sget_token=get_token", this.url)));
            if("token" in j){
                if(token == j["token"].str)
                    return token;
                token = j["token"].str;
                tokenlife = Clock.currTime() + dur!"minutes"(14) + dur!"seconds"(55);
            }
        }
        return token;
    }

    private string constructUrl(int imdb_id, int limit = 10, int page = 50, string text = "")
    {
        string url = format("%stoken=%s&mode=search&search_imdb=tt%d&limit=%d&page=%d",
                            this.url, getRarbgToken(), imdb_id, limit, page);
        
        if(text != "")
            url ~= "&search_string=" ~ text;
        
        return url;
    }

    /***********************************
    * Search episode in RARBG
    *
    * Params:
    *      imdb_id =   Series IMDB ID
    *      season =    Season number
    *      episode =   Episode number
    *      release =   Release name (ex. HDTV) (optional)
    *      max =   Max results
    *      limit = Per page result limit
    *
    * Returns: magnet link list for given episode
    */
    override public DList!string searchEpisode(int imdb_id, int season, int episode,
        string release = "", byte max = 10, byte limit = 50)
    {
        DList!string result;
        byte page = 1;
        auto ep = format("S%02dE%02d", season, episode);
        string url = "";
        JSONValue j;

        while (walkLength(result[]) < max) {
            url = constructUrl(imdb_id, limit, page, ep);
            delay(100);
            try {
                j = parseJSON(get(url));
            } catch (HTTPStatusException e) {
                if(e.status == 429){
                    delay(2000); /** the RARBG API supposedly has a limit of 1req/2s,
                                        this doesn't seem to be happenning right now
                                        but it could enabled in the future */
                    try
                        j = parseJSON(get(url));
                    catch (HTTPStatusException e)
                        return result;
                }
            }

            if(!("torrent_results" in j)) /** no more results */
                return result;

            foreach (ref res; j["torrent_results"].array) {
                if(canFind(toLower(res["filename"].str), toLower(ep))){ /** episode check. not really needed */
                    if(release == "" ||
                        !canFind(toLower(res["filename"].str), toLower(release))
                    ){
                        result.insertBack(res["download"].str);
                    } else {
                        result.insertFront(res["download"].str);
                    }
                }
            }
            page++;
        }

        return result;
    }

    /***********************************
    * Search movie in RARBG
    *
    * Params:
    *      imdb_id =   Series IMDB ID
    *      season =    Season number
    *      episode =   Episode number
    *      release =   Release name (ex. HDTV) (optional)
    *      max =   Max results
    *      limit = Per page result limit
    *
    * Returns: magnet link list for given movie
    */
    override public DList!string searchMovie(int imdb_id,
        string release = "", byte max = 10, byte limit = 50)
    {
        DList!string result;
        byte page = 1;
        string url = "";
        JSONValue j;

        while (walkLength(result[]) < max) {
            url = constructUrl(imdb_id, limit, page);
            delay(100);
            try {
                j = parseJSON(get(url));
            } catch (HTTPStatusException e) {
                if(e.status == 429){
                    delay(2000); /** the RARBG API supposedly has a limit of 1req/2s,
                                        this doesn't seem to be happenning right now
                                        but it could enabled in the future */
                    try
                        j = parseJSON(get(url));
                    catch (HTTPStatusException e)
                        return result;
                }
            }

            if(!("torrent_results" in j)) /** no more results */
                return result;

            foreach (ref res; j["torrent_results"].array) {
                if(release == "" ||
                    !canFind(toLower(res["filename"].str), toLower(release))
                ){
                    result.insertBack(res["download"].str);
                } else {
                    result.insertFront(res["download"].str);
                }
            }
            page++;
        }

        return result;
    }

}