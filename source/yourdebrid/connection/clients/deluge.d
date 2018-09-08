/**
 * Authors: Filipe Laíns
 * License: AGPLv3 https://www.gnu.org/licenses/agpl-3.0.txt
 */

module yourdebrid.connection.clients.deluge;

import std.net.curl, std.json, std.path;
import yourdebrid.util.rpc, yourdebrid.util.structs, yourdebrid.model.client;

public class Deluge : Client {
        private HTTP conn;
        private immutable auto checkKeys = ["is_finished", "save_path", "files"];

        public:
                this(string password)
                {
                        conn = HTTP();
                        conn.method = HTTP.Method.post;
                        conn.addRequestHeader("Content-Type", "application/json");
                        conn.addRequestHeader("Accept", "application/json");

                        conn.url = "http://localhost:8112/json"; // TODO
                        
                        auto querry = new Rpc("auth.login");
                        querry.setParams(password);

                        auto querryString = querry.getJson();

                        conn.onSend = (void[] data)
                        {
                                auto m = cast(void[]) querryString;
                                size_t len = m.length > data.length ? data.length : m.length;
                                if (len == 0) return len;
                                data[0 .. len] = m[0 .. len];
                                querryString = querryString[len..$];
                                return len;
                        };
                        conn.contentLength = querryString.length;

                        conn.perform(); // Should keep cookies
                }

                override string addTorrent(string magnet)
                {
                        auto querry = new Rpc("core.add_torrent_magnet");
                        querry.setParams(JSONValue( [magnet, []] ));

                        auto querryString = querry.getJson();

                        conn.onSend = (void[] data)
                        {
                                auto m = cast(void[]) querryString;
                                size_t len = m.length > data.length ? data.length : m.length;
                                if (len == 0) return len;
                                data[0 .. len] = m[0 .. len];
                                querryString = querryString[len..$];
                                return len;
                        };
                        conn.contentLength = querryString.length;

                        ubyte[] res;
                        conn.onReceive = (ubyte[] data)
                        {
                                res ~= data;
                                return data.length;
                        };

                        conn.perform();

                        return cast(string) res;
                }

                override TorrentStatus checkTorrent(string hash)
                {
                        auto querry = new Rpc("core.get_torrents_status");
                        JSONValue params;
                        params[0] = hash;
                        params[1] = checkKeys;
                        querry.setParams(params);

                        auto querryString = querry.getJson();

                        conn.onSend = (void[] data)
                        {
                                auto m = cast(void[]) querryString;
                                size_t len = m.length > data.length ? data.length : m.length;
                                if (len == 0) return len;
                                data[0 .. len] = m[0 .. len];
                                querryString = querryString[len..$];
                                return len;
                        };
                        conn.contentLength = querryString.length;

                        ubyte[] res;
                        conn.onReceive = (ubyte[] data)
                        {
                                res ~= data;
                                return data.length;
                        };

                        conn.perform();

                        auto j = parseJSON(cast(string) res);

                        // Get status
                        auto torrent = new TorrentStatus;
                        if ("result" in j)
                        {
                                if ("is_finished" in j["result"])
                                {
                                        torrent.status = j["result"]["is_finished"].toString == "true" ? TorrentDownload.FINISHED : TorrentDownload.DOWNLOADING;
                                }
                        }
                        if (torrent.status != TorrentDownload.FINISHED && torrent.status != TorrentDownload.DOWNLOADING)
                                torrent.status = TorrentDownload.ERROR;

                        // Get files
                        if ("save_path" !in j || "files" !in j)
                                return *torrent;

                        foreach(file; j["files"].array)
                        {
                                torrent.files ~= buildPath(j["save_path"].str, file.str);
                        }

                        return *torrent;
                }

}