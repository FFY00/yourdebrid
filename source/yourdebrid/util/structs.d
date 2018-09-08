module yourdebrid.util.structs;

enum TorrentDownload
{
        FINISHED,
        DOWNLOADING,
        ERROR,
        UNKNOWN
}

struct TorrentStatus
{
        auto status = TorrentDownload.UNKNOWN;
        string[] files;
}