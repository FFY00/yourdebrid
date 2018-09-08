/**
 * Authors: Filipe Laíns
 * License: AGPLv3 https://www.gnu.org/licenses/agpl-3.0.txt
 */

module yourdebrid.util.http;

import std.format, std.net.curl, std.json, std.path, std.file;
import std.range : repeat;
import std.stdio, std.experimental.logger;
import std.mmfile : MmFile;

/// HTTP request helper class
class Http {
    private:
        HTTP conn;
        File file;
        //MmFile file;

    public:
        /// Constructs the base request
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
                    conn.onProgress = (size_t _, size_t __, size_t ultotal, size_t ulnow)
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

        /***********************************
        * Add file to request
        *
        * Params:
        *      file =   Path of the file to add
        */
        void setFile(string file)
        {
            if(!file.isFile())
                return;

            this.file = File(file);
        }

        void setUrl(string url)
        {
            conn.url = url; 
        }

        void setMethod(HTTP.Method m)
        {
            conn.method = m;
        }

        void addHeader(string name, string data)
        {
            conn.addRequestHeader(name, data);
        }

        /***********************************
        * Sends the request
        *
        * Returns: Returned data from the server (usually JSON)
        */
        string sendFile()
        {
            string res = "";

            conn.addRequestHeader("Content-Type", "multipart/form-data; boundary=xxBOUNDARYxx");

            conn.onReceive = (ubyte[] data)
            {
                res = cast(string) data;
                return data.length;
            };


            auto filename = baseName(file.name);

            // Boundary prefix
            auto boundPre = "--xxBOUNDARYxx\r\n";
            boundPre ~= "Content-Disposition: form-data; name=\""~ filename ~ "\"; ";
            boundPre ~= "filename=\"" ~ filename ~ "\"\r\n\r\n";

            // Boundary suffix
            auto boundSuf = "\r\n--xxBOUNDARYxx--\r\n";

            // Send callback (thanks Wild :P)
            bool started, finished = false;
            conn.onSend = (void[] data)
            {
                if (!started)
                {
                    started = true;
                    sformat(cast(char[]) data, boundPre);
                    return boundPre.length;
                }

                if (file.eof)
                {
                    if(finished)
                        return 0;

                    finished = true;
                    sformat(cast(char[]) data, boundSuf);
                    return boundSuf.length;
                }
                
                auto slice = file.rawRead(data);
                return slice.length;
            };

            immutable sz = file.size + boundPre.length + boundSuf.length;
            if(sz != ulong.max)
                conn.contentLength = sz;

            conn.perform();

            return res;
        }

}