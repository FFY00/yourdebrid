/**
 * Authors: Filipe Laíns
 * License: AGPLv3 https://www.gnu.org/licenses/agpl-3.0.txt
 */

module yourdebrid.external.sources.eztv;

import yourdebrid.external.sources.source;
import yourdebrid.util;
import std.net.curl, std.json, std.algorithm, std.string, std.uni;
import std.container : DList;
import std.range.primitives : walkLength;


class EztvSource : Source {
    private const string url = "https://eztv.ag/api/get-torrents?";

    private bool test = false;

    this(bool test = false){
        this.test = test;
    }

    private string constructUrl(int imdb_id, int limit = 10, int page = 50) /** no support form custom search query :( */
    {
        return format("%s&imdb_id=%d&limit=%d&page=%d",
                        this.url, imdb_id, limit, page);
    }

    private JSONValue getData(string url)
    {
        if(test){
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
        string[] front, back;
        int nresults;
        byte page = 1;
        auto ep = format("S%02dE%02d", season, episode);
        string url = "";
        JSONValue j;

        while (nresults < max) {
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
                        return front ~ back;
                }
            }

            if(!("torrents" in j)) /** no more results */
                return front ~ back;

            foreach (ref res; j["torrents"].array) {
                if(canFind(toLower(res["title"].str), toLower(ep))){ /** episode check. not really needed */
                    if(release == "" ||
                        !canFind(toLower(res["title"].str), toLower(release))
                    ){
                        back ~= res["magnet_url"].str;
                        nresults++;
                    } else {
                        front ~= res["magnet_url"].str;
                        nresults++;
                    }
                }
            }
            page++;
        }

        return front ~ back;
    }

}