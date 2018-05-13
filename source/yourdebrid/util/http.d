/**
 * Authors: Filipe Laíns
 * License: AGPLv3 https://www.gnu.org/licenses/agpl-3.0.txt
 */

module source.yourdebrid.external.hosts.http;

import std.format, std.net.curl, std.json, std.path, std.file;
import std.range : repeat;
import std.stdio;

class Http {
    private void[] data;
    private HTTP conn;

    this()
    {
        conn = HTTP();
        conn.method = HTTP.Method.post;

        version(unittest)
        {
            conn.verbose(true);

            version(Posix)
            {
                ubyte old_prog;
                conn.onProgress = (size_t dltotal, size_t dlnow,
                    size_t ultotal, size_t ulnow)
                {
                    ubyte prog;

                    if(ultotal != 0 && ulnow != 0)
                        prog = cast(ubyte) (ulnow * 100 / ultotal);

                    if(old_prog != prog)
                    {
                        write("\rProgress: ", prog, "% \x1b[96m", '█'.repeat(prog / 2), "\x1b[0m");
                        stdout.flush();

                        if(prog == 100)
                            writeln();
                    }

                    old_prog = prog;
                    return 0;
                };
            }
        }
    }

    public void addFile(string file)
    {
        if(!file.isFile())
            return;

        conn.addRequestHeader("Content-Type", "multipart/form-data; boundary=xxBOUNDARYxx");

        string filename = baseName(file);
        data ~= cast(void[]) "--xxBOUNDARYxx\r\n";
        data ~= cast(void[]) "Content-Disposition: form-data; name=\"" ~ filename ~ "\"; filename=\"" ~ filename ~ "\"\r\n";
        data ~= cast(void[]) "\r\n";
        data ~= read(file);
        data ~= cast(void[]) "\r\n";
        data ~= cast(void[]) "--xxBOUNDARYxx--\r\n";
    }

    public void setUrl(string url)
    {
        conn.url = url; 
    }

    public void setMethod(HTTP.Method m)
    {
        conn.method = m;
    }

    public string send()
    {
        string res = "";

        conn.onReceive = (ubyte[] data)
        {
            res = cast(string) data;
            return data.length;
        };

        conn.onSend = (void[] data)
        {
            auto m = cast(void[]) this.data;
            size_t length = m.length > data.length ? data.length : m.length;
            if (length == 0) return 0;
            data[0 .. length] = m[0 .. length];
            this.data = this.data[length..$];
            return length;
        };

        immutable sz = data.length;
        if(sz != ulong.max)
            conn.contentLength = sz;

        conn.perform();

        return res;
    }

}