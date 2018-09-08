/**
 * Authors: Filipe Laíns
 * License: AGPLv3 https://www.gnu.org/licenses/agpl-3.0.txt
 */

module yourdebrid.util.rpc;

import std.experimental.logger;
import std.json;

public class Rpc {
        private JSONValue querry;

        public:
                this(string method)
                {
                        querry.object["id"] = 1;
                        setMethod(method);
                }

                void setMethod(string name)
                {
                        querry.object["method"] = JSONValue(name);
                }

                void setParams(string params)
                {
                        querry.object["params"] = JSONValue([ params ]);
                }

                void setParams(string[] params)
                {
                        querry.object["params"] = JSONValue(params);
                }

                void setParams(JSONValue params)
                {
                        querry.object["params"] = params;
                }

                string getJson()
                {
                        if ("method" !in querry)
                                warning("RPC querry is missing an element: 'method'");

                        if ("params" !in querry)
                                warning("RPC querry is missing an element: 'params'");

                        return querry.toString;
                }

}