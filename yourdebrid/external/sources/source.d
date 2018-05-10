/**
 * Authors: Filipe Laíns
 * License: AGPLv3 https://www.gnu.org/licenses/agpl-3.0.txt
 */

module yourdebrid.external.sources.source;

import std.container : DList;

class Source {
    const protected string url;

    /***********************************
    * Search episode
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
    public string[] searchEpisode(int imdb_id, int season, int episode,
        string release = "", byte max = 10, byte limit = 50)
    {
        return [];
    }

    /***********************************
    * Search movie
    *
    * Params:
    *      imdb_id =   Series IMDB ID
    *      release =   Release name (ex. HDTV) (optional)
    *      max =   Max results
    *      limit = Per page result limit
    *
    * Returns: magnet link list for given movie
    */
    public string[] searchMovie(int imdb_id,
        string release = "", byte max = 10, byte limit = 50)
    {
        return [];
    }

}