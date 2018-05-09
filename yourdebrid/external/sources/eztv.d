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

    private string constructUrl(int imdb_id, int limit = 10, int page = 50) /** no support form custom search query :( */
    {
        return format("%s&imdb_id=%d&limit=%d&page=%d",
                        this.url, imdb_id, limit, page);
    }

    /***********************************
    * Search shows in EZTV
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
            url = constructUrl(imdb_id, limit, page);
            delay(100);
            try {
                j = parseJSON(get(url));
            } catch (HTTPStatusException e) {
                if(e.status == 429){
                    delay(2000); /** delay and try again.
                                        there are no API limitations afiak
                                        but it's still good to have a delay */
                    try
                        j = parseJSON(get(url));
                    catch (HTTPStatusException e)
                        return result;
                }
            }

            if(!("torrents" in j)) /** no more results */
                return result;

            foreach (ref res; j["torrents"].array) {
                if(canFind(toLower(res["title"].str), toLower(ep))){ /** episode check. not really needed */
                    if(release == "" ||
                        !canFind(toLower(res["title"].str), toLower(release))
                    ){
                        result.insertBack(res["magnet_url"].str);
                    } else {
                        result.insertFront(res["magnet_url"].str);
                    }
                }
            }
            page++;
        }

        return result;
    }

}

/***********************************
 * Search shows in EZTV
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
 DList!string searchShowEztv(int imdb_id, int season, int episode,
    string release = "", byte max = 10, byte limit = 50)
{
    DList!string result;
    byte page = 1;
    auto ep = format("S%02dE%02d", season, episode);
    JSONValue j;
    while (walkLength(result[]) < max) {
        j = parseJSON(get(
                format("https://eztv.ag/api/get-torrents?imdb_id=%d&limit=%d&page=%d", imdb_id, limit, page)
            ));

        if(!("torrents" in j))
            return result;

        foreach (ref res; j["torrents"].array) {
            if(canFind(toLower(res["title"].str), toLower(ep))){
                if(release == "" ||
                    !canFind(toLower(res["title"].str), toLower(release))
                ){
                    result.insertBack(res["magnet_url"].str);
                } else {
                    result.insertFront(res["magnet_url"].str);
                }
            }
        }
        page++;
    }

    return result;
}