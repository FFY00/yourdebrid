/**
 * Authors: Filipe Laíns
 * License: AGPLv3 https://www.gnu.org/licenses/agpl-3.0.txt
 */

module yourdebrid.external.sources.eztv;

import yourdebrid.external.sources.source;
import yourdebrid.util.util;
import std.net.curl, std.json, std.string, std.uni;
import std.container : DList;
import std.algorithm : canFind;

class EztvSource : Source {
    
    this(){
        url = "https://eztv.ag/api/get-torrents?";
    }

    unittest
    {
        import std.stdio;
        import std.datetime : SysTime, Clock, dur;

        Source source = new EztvSource;
        SysTime stattime;

        writeln("==============================");
        writeln("Testing EztvSource");
        writeln("==============================");

        // Test searchEpisode()
        stattime = Clock.currTime();
        foreach(link; source.searchEpisode(4052886, 3, 23, "hdtv")){
            writeln("RESULT: ", link);
        }
        writeln("EZTV searchEpisode() ==> ", Clock.currTime() - stattime);

        // Test searchMovie()
        stattime = Clock.currTime();
        foreach(link; source.searchMovie(1559547, "hdtv")){
            writeln("RESULT: ", link);
        }
        writeln("\nEZTV searchMovie() ==> ", Clock.currTime() - stattime, "\n");
    }

    private string constructUrl(int imdb_id, int limit = 10, int page = 50) /** no support form custom search query :( */
    {
        return format("%s&imdb_id=%d&limit=%d&page=%d",
                        this.url, imdb_id, limit, page);
    }

    private JSONValue getData(string url)
    {
        version(unittest)
        {
            // Return cached data
        }
        
        return parseJSON(get(url));
    }

    /***********************************
    * Search episode in EZTV
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
    override public string[] searchEpisode(int imdb_id, int season, int episode,
        string release = "", byte max = 10, byte limit = 50)
    {
        string[] results;
        byte page = 1;
        auto ep = format("S%02dE%02d", season, episode);
        string url = "";
        JSONValue j;

        while (results.length < max) {
            url = constructUrl(imdb_id, limit, page);
            delay(100);
            try {
                j = getData(url);
            } catch (HTTPStatusException e) {
                if(e.status == 429){
                    delay(2000); /** delay and try again.
                                        there are no API limitations afiak
                                        but it's still good to have a delay */
                    try
                        j = parseJSON(get(url));
                    catch (HTTPStatusException e)
                        return results;
                }
            }

            if(!("torrents" in j)) /** no more results */
                return results;

            foreach (ref res; j["torrents"].array) {
                if(canFind(toLower(res["title"].str), toLower(ep))){ /** episode check. not really needed */
                    if(release == "" ||
                        !canFind(toLower(res["title"].str), toLower(release))
                    ){
                        results ~= res["magnet_url"].str;
                    } else {
                        results = res["magnet_url"].str ~ results;
                    }
                }

                if(results.length >= max)
                    return results;
            }
            page++;
        }

        return results;
    }

}