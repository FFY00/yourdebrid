/**
 * Authors: Filipe Laíns
 * License: AGPLv3 https://www.gnu.org/licenses/agpl-3.0.txt
 */

module test.host;

import std.stdio;
import yourdebrid.external.hosts.host, yourdebrid.util.config;
import yourdebrid.external.hosts.openload, yourdebrid.external.hosts.streamango, yourdebrid.external.hosts.vidlox;

void main()
{
    Host host;
    auto config = new ConfigManager();
    
    host = new Openload(config);
    host = new Streamango(config);
    host = new Vidlox(config);
}