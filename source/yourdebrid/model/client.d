/**
 * Authors: Filipe Laíns
 * License: AGPLv3 https://www.gnu.org/licenses/agpl-3.0.txt
 */
 
module yourdebrid.model.client;

import yourdebrid.util.structs;

class Client {

        public:
                string addTorrent(string magnet)
                {
                        return "";
                }

                TorrentStatus checkTorrent(string hash)
                {
                        return TorrentStatus(TorrentDownload.ERROR, []);
                }

                TorrentDownload isDowloading(TorrentStatus torrent)
                {
                        return torrent.status;
                }

                TorrentDownload isDowloading(string hash)
                {
                        return isDowloading(checkTorrent(hash));
                }
}